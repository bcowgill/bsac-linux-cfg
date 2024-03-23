"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.LocalUtilsDispatcher = void 0;
exports.urlToWSEndpoint = urlToWSEndpoint;
var _fs = _interopRequireDefault(require("fs"));
var _path = _interopRequireDefault(require("path"));
var _os = _interopRequireDefault(require("os"));
var _manualPromise = require("../../utils/manualPromise");
var _utils = require("../../utils");
var _dispatcher = require("./dispatcher");
var _zipBundle = require("../../zipBundle");
var _zipFile = require("../../utils/zipFile");
var _jsonPipeDispatcher = require("../dispatchers/jsonPipeDispatcher");
var _transport = require("../transport");
var _socksInterceptor = require("../socksInterceptor");
var _userAgent = require("../../utils/userAgent");
var _progress = require("../progress");
var _network = require("../../utils/network");
var _instrumentation = require("../../server/instrumentation");
function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
/**
 * Copyright (c) Microsoft Corporation.
 *
 * Licensed under the Apache License, Version 2.0 (the 'License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class LocalUtilsDispatcher extends _dispatcher.Dispatcher {
  constructor(scope, playwright) {
    const localUtils = new _instrumentation.SdkObject(playwright, 'localUtils', 'localUtils');
    const descriptors = require('../deviceDescriptors');
    const deviceDescriptors = Object.entries(descriptors).map(([name, descriptor]) => ({
      name,
      descriptor
    }));
    super(scope, localUtils, 'LocalUtils', {
      deviceDescriptors
    });
    this._type_LocalUtils = void 0;
    this._harBackends = new Map();
    this._stackSessions = new Map();
    this._type_LocalUtils = true;
  }
  async zip(params) {
    const promise = new _manualPromise.ManualPromise();
    const zipFile = new _zipBundle.yazl.ZipFile();
    zipFile.on('error', error => promise.reject(error));
    const addFile = (file, name) => {
      try {
        if (_fs.default.statSync(file).isFile()) zipFile.addFile(file, name);
      } catch (e) {}
    };
    for (const entry of params.entries) addFile(entry.value, entry.name);

    // Add stacks and the sources.
    const stackSession = params.stacksId ? this._stackSessions.get(params.stacksId) : undefined;
    if (stackSession !== null && stackSession !== void 0 && stackSession.callStacks.length) {
      await stackSession.writer;
      if (process.env.PW_LIVE_TRACE_STACKS) {
        zipFile.addFile(stackSession.file, 'trace.stacks');
      } else {
        const buffer = Buffer.from(JSON.stringify((0, _utils.serializeClientSideCallMetadata)(stackSession.callStacks)));
        zipFile.addBuffer(buffer, 'trace.stacks');
      }
    }

    // Collect sources from stacks.
    if (params.includeSources) {
      const sourceFiles = new Set();
      for (const {
        stack
      } of (stackSession === null || stackSession === void 0 ? void 0 : stackSession.callStacks) || []) {
        if (!stack) continue;
        for (const {
          file
        } of stack) sourceFiles.add(file);
      }
      for (const sourceFile of sourceFiles) addFile(sourceFile, 'resources/src@' + (0, _utils.calculateSha1)(sourceFile) + '.txt');
    }
    if (params.mode === 'write') {
      // New file, just compress the entries.
      await _fs.default.promises.mkdir(_path.default.dirname(params.zipFile), {
        recursive: true
      });
      zipFile.end(undefined, () => {
        zipFile.outputStream.pipe(_fs.default.createWriteStream(params.zipFile)).on('close', () => promise.resolve()).on('error', error => promise.reject(error));
      });
      await promise;
      await this._deleteStackSession(params.stacksId);
      return;
    }

    // File already exists. Repack and add new entries.
    const tempFile = params.zipFile + '.tmp';
    await _fs.default.promises.rename(params.zipFile, tempFile);
    _zipBundle.yauzl.open(tempFile, (err, inZipFile) => {
      if (err) {
        promise.reject(err);
        return;
      }
      (0, _utils.assert)(inZipFile);
      let pendingEntries = inZipFile.entryCount;
      inZipFile.on('entry', entry => {
        inZipFile.openReadStream(entry, (err, readStream) => {
          if (err) {
            promise.reject(err);
            return;
          }
          zipFile.addReadStream(readStream, entry.fileName);
          if (--pendingEntries === 0) {
            zipFile.end(undefined, () => {
              zipFile.outputStream.pipe(_fs.default.createWriteStream(params.zipFile)).on('close', () => {
                _fs.default.promises.unlink(tempFile).then(() => {
                  promise.resolve();
                }).catch(error => promise.reject(error));
              });
            });
          }
        });
      });
    });
    await promise;
    await this._deleteStackSession(params.stacksId);
  }
  async harOpen(params, metadata) {
    let harBackend;
    if (params.file.endsWith('.zip')) {
      const zipFile = new _zipFile.ZipFile(params.file);
      const entryNames = await zipFile.entries();
      const harEntryName = entryNames.find(e => e.endsWith('.har'));
      if (!harEntryName) return {
        error: 'Specified archive does not have a .har file'
      };
      const har = await zipFile.read(harEntryName);
      const harFile = JSON.parse(har.toString());
      harBackend = new HarBackend(harFile, null, zipFile);
    } else {
      const harFile = JSON.parse(await _fs.default.promises.readFile(params.file, 'utf-8'));
      harBackend = new HarBackend(harFile, _path.default.dirname(params.file), null);
    }
    this._harBackends.set(harBackend.id, harBackend);
    return {
      harId: harBackend.id
    };
  }
  async harLookup(
    params,
    metadata,
    sanitiseUrl, // BSAC (url: string) => string
   ) {
    warn(`BSAC harLookup santitiseUrl`, sanitiseUrl, '\nparams', params, '\nmeta, metadata');
    // try { throw new Error("BSAC STOP") } catch (e) {
    //   console.error('BSAC WHOAH', e);
    // }
    const harBackend = this._harBackends.get(params.harId);
    if (!harBackend) return {
      action: 'error',
      message: `Internal error: har was not opened`
    };
    warn(`BSAC await harBackend.lookup`);
    return await harBackend.lookup(
        params.url,
        params.method,
        params.headers,
        params.postData,
        params.isNavigationRequest,
        sanitiseUrl, // BSAC pipe it through to next call
        );
  }
  async harClose(params, metadata) {
    const harBackend = this._harBackends.get(params.harId);
    if (harBackend) {
      this._harBackends.delete(harBackend.id);
      harBackend.dispose();
    }
  }
  async harUnzip(params, metadata) {
    const dir = _path.default.dirname(params.zipFile);
    const zipFile = new _zipFile.ZipFile(params.zipFile);
    for (const entry of await zipFile.entries()) {
      const buffer = await zipFile.read(entry);
      if (entry === 'har.har') await _fs.default.promises.writeFile(params.harFile, buffer);else await _fs.default.promises.writeFile(_path.default.join(dir, entry), buffer);
    }
    zipFile.close();
    await _fs.default.promises.unlink(params.zipFile);
  }
  async connect(params, metadata) {
    const controller = new _progress.ProgressController(metadata, this._object);
    controller.setLogName('browser');
    return await controller.run(async progress => {
      var _params$exposeNetwork;
      const wsHeaders = {
        'User-Agent': (0, _userAgent.getUserAgent)(),
        'x-playwright-proxy': (_params$exposeNetwork = params.exposeNetwork) !== null && _params$exposeNetwork !== void 0 ? _params$exposeNetwork : '',
        ...params.headers
      };
      const wsEndpoint = await urlToWSEndpoint(progress, params.wsEndpoint);
      const transport = await _transport.WebSocketTransport.connect(progress, wsEndpoint, wsHeaders, true, 'x-playwright-debug-log');
      const socksInterceptor = new _socksInterceptor.SocksInterceptor(transport, params.exposeNetwork, params.socksProxyRedirectPortForTest);
      const pipe = new _jsonPipeDispatcher.JsonPipeDispatcher(this);
      transport.onmessage = json => {
        if (socksInterceptor.interceptMessage(json)) return;
        const cb = () => {
          try {
            pipe.dispatch(json);
          } catch (e) {
            transport.close();
          }
        };
        if (params.slowMo) setTimeout(cb, params.slowMo);else cb();
      };
      pipe.on('message', message => {
        transport.send(message);
      });
      transport.onclose = () => {
        socksInterceptor === null || socksInterceptor === void 0 || socksInterceptor.cleanup();
        pipe.wasClosed();
      };
      pipe.on('close', () => transport.close());
      return {
        pipe,
        headers: transport.headers
      };
    }, params.timeout || 0);
  }
  async tracingStarted(params, metadata) {
    let tmpDir = undefined;
    if (!params.tracesDir) tmpDir = await _fs.default.promises.mkdtemp(_path.default.join(_os.default.tmpdir(), 'playwright-tracing-'));
    const traceStacksFile = _path.default.join(params.tracesDir || tmpDir, params.traceName + '.stacks');
    this._stackSessions.set(traceStacksFile, {
      callStacks: [],
      file: traceStacksFile,
      writer: Promise.resolve(),
      tmpDir
    });
    return {
      stacksId: traceStacksFile
    };
  }
  async traceDiscarded(params, metadata) {
    await this._deleteStackSession(params.stacksId);
  }
  async addStackToTracingNoReply(params, metadata) {
    for (const session of this._stackSessions.values()) {
      session.callStacks.push(params.callData);
      if (process.env.PW_LIVE_TRACE_STACKS) {
        session.writer = session.writer.then(() => {
          const buffer = Buffer.from(JSON.stringify((0, _utils.serializeClientSideCallMetadata)(session.callStacks)));
          return _fs.default.promises.writeFile(session.file, buffer);
        });
      }
    }
  }
  async _deleteStackSession(stacksId) {
    const session = stacksId ? this._stackSessions.get(stacksId) : undefined;
    if (!session) return;
    await session.writer;
    if (session.tmpDir) await (0, _utils.removeFolders)([session.tmpDir]);
    this._stackSessions.delete(stacksId);
  }
}
exports.LocalUtilsDispatcher = LocalUtilsDispatcher;
const redirectStatus = [301, 302, 303, 307, 308];

const identity = (url) => url; // BSAC default sanitiser

class HarBackend {
  constructor(harFile, baseDir, zipFile) {
    this.id = (0, _utils.createGuid)();
    this._harFile = void 0;
    this._zipFile = void 0;
    this._baseDir = void 0;
    this._harFile = harFile;
    this._baseDir = baseDir;
    this._zipFile = zipFile;
  }
  async lookup(url, method, headers, postData, isNavigationRequest, sanitiseUrl = identity) {
    // BSAC pipe destination
    warn(`BSAC HarBackend.lookup santitiseUrl`, sanitiseUrl);
    warn(`BSAC HarBackend.lookup1 ${method} ${url}`);
    let entry;
    try {
      warn(`BSAC HarBackend.lookup2 ${method} ${url}`, this._harFindResponse);
      entry = await this._harFindResponse(url, method, headers, postData);
      warn(`BSAC HarBackend.lookup3`);
    } catch (e) {
      warn(`BSAC HarBackend.lookup4`, e);
      return {
        action: 'error',
        message: 'HAR error: ' + e.message
      };
    }
    warn(`BSAC HarBackend.lookup5 no entry?`);
    if (!entry) return {
      action: 'noentry'
    };
    warn(`BSAC HarBackend.lookup6 carry on, will redirect?\nERU: ${entry.request.url}\nURL: ${url}`);

    // If navigation is being redirected, restart it with the final url to ensure the document's url changes.
    if (entry.request.url !== url && isNavigationRequest) return {
      action: 'redirect',
      redirectURL: entry.request.url
    };
    warn(`BSAC HarBackend.lookup7 nope, go for it`);
    const response = entry.response;
    try {
      warn(`BSAC HarBackend.lookup8 _loadContent`);
      const buffer = await this._loadContent(response.content);
      warn(`BSAC HarBackend.lookup9 fulfill`, result);
      return {
        action: 'fulfill',
        status: response.status,
        headers: response.headers,
        body: buffer
      };
    } catch (e) {
      warn(`BSAC HarBackend.lookup10`, e);
      return {
        action: 'error',
        message: e.message
      };
    }
  }
  async _loadContent(content) {
    const file = content._file;
    let buffer;
    if (file) {
      if (this._zipFile) buffer = await this._zipFile.read(file);else buffer = await _fs.default.promises.readFile(_path.default.resolve(this._baseDir, file));
    } else {
      buffer = Buffer.from(content.text || '', content.encoding === 'base64' ? 'base64' : 'utf-8');
    }
    return buffer;
  }
  async _harFindResponse(url, method, headers, postData, sanitiseUrl = identity) {
    // BSAC more pipework
    warn(`BSAC _harFindResponse sanitiseUrl`, sanitiseUrl);
    const harLog = this._harFile.log;
    const visited = new Set();
    while (true) {
      warn(`BSAC _harFindResponseA`);
      const entries = [];
      for (const candidate of harLog.entries) {
        warn(`\nBSAC HAR CMP API ${candidate.request.method}==${method}\nHAR: ${candidate.request.url}\nAPI: ${url}`);
        if (
            // BSAC here is the fix location...
            sanitiseUrl(candidate.request.url) !== sanitiseUrl(url) ||
            candidate.request.method !== method
          )
          continue;
        warn(`BSAC _harFindResponse1`);
        if (method === 'POST' && postData && candidate.request.postData) {
          warn(`BSAC _harFindResponse2`);
          const buffer = await this._loadContent(candidate.request.postData);
          if (!buffer.equals(postData)) continue;
        }
        entries.push(candidate);
        warn(`BSAC _harFindResponse3`);
      }
      warn(`BSAC _harFindResponse4`);
      if (!entries.length) return;
      warn(`BSAC _harFindResponse5`);
      let entry = entries[0];
      warn(`BSAC _harFindResponse6`);

      // Disambiguate using headers - then one with most matching headers wins.
      if (entries.length > 1) {
        warn(`BSAC _harFindResponse7 multiple matches on URL`);
        const list = [];
        warn(`BSAC _harFindResponse8`);
        for (const candidate of entries) {
          warn(`BSAC _harFindResponse9 header matching...`);
          const matchingHeaders = countMatchingHeaders(candidate.request.headers, headers);
          list.push({
            candidate,
            matchingHeaders
          });
        }
        warn(`BSAC _harFindResponse10 sort by #header matches`);
        list.sort((a, b) => b.matchingHeaders - a.matchingHeaders);
        warn(`BSAC _harFindResponse11 select first match`);
        entry = list[0].candidate;
        warn(`BSAC _harFindResponse12`);
      }
      warn(`BSAC _harFindResponse13 check for cycle`);
      if (visited.has(entry)) throw new Error(`Found redirect cycle for ${url}`);
      warn(`BSAC _harFindResponse14 visited`);
      visited.add(entry);

      // Follow redirects.
      const locationHeader = entry.response.headers.find(h => h.name.toLowerCase() === 'location');
      warn(`BSAC _harFindResponse15 check redirect`);
      if (redirectStatus.includes(entry.response.status) && locationHeader) {
        warn(`BSAC _harFindResponse16`);
        const locationURL = new URL(locationHeader.value, url);
        url = locationURL.toString();
        warn(`BSAC _harFindResponse17 redirect ${url}`);
        if ((entry.response.status === 301 || entry.response.status === 302) && method === 'POST' || entry.response.status === 303 && !['GET', 'HEAD'].includes(method)) {
          warn(`BSAC _harFindResponse18 redirect with GET`);
          // HTTP-redirect fetch step 13 (https://fetch.spec.whatwg.org/#http-redirect-fetch)
          method = 'GET';
        }
        warn(`BSAC _harFindResponse19 continue`);
        continue;
      }
      warn(`BSAC _harFindResponse20 return single MATCHED entry`, entry);
      return entry;
    }
    warn(`BSAC _harFindResponse21 never`);
  }
  dispose() {
    var _this$_zipFile;
    (_this$_zipFile = this._zipFile) === null || _this$_zipFile === void 0 || _this$_zipFile.close();
  }
}
function countMatchingHeaders(harHeaders, headers) {
  const set = new Set(headers.map(h => h.name.toLowerCase() + ':' + h.value));
  let matches = 0;
  for (const h of harHeaders) {
    if (set.has(h.name.toLowerCase() + ':' + h.value)) ++matches;
  }
  return matches;
}
async function urlToWSEndpoint(progress, endpointURL) {
  var _progress$timeUntilDe;
  if (endpointURL.startsWith('ws')) return endpointURL;
  progress === null || progress === void 0 || progress.log(`<ws preparing> retrieving websocket url from ${endpointURL}`);
  const fetchUrl = new URL(endpointURL);
  if (!fetchUrl.pathname.endsWith('/')) fetchUrl.pathname += '/';
  fetchUrl.pathname += 'json';
  const json = await (0, _network.fetchData)({
    url: fetchUrl.toString(),
    method: 'GET',
    timeout: (_progress$timeUntilDe = progress === null || progress === void 0 ? void 0 : progress.timeUntilDeadline()) !== null && _progress$timeUntilDe !== void 0 ? _progress$timeUntilDe : 30_000,
    headers: {
      'User-Agent': (0, _userAgent.getUserAgent)()
    }
  }, async (params, response) => {
    return new Error(`Unexpected status ${response.statusCode} when connecting to ${fetchUrl.toString()}.\n` + `This does not look like a Playwright server, try connecting via ws://.`);
  });
  progress === null || progress === void 0 || progress.throwIfAborted();
  const wsUrl = new URL(endpointURL);
  let wsEndpointPath = JSON.parse(json).wsEndpointPath;
  if (wsEndpointPath.startsWith('/')) wsEndpointPath = wsEndpointPath.substring(1);
  if (!wsUrl.pathname.endsWith('/')) wsUrl.pathname += '/';
  wsUrl.pathname += wsEndpointPath;
  wsUrl.protocol = wsUrl.protocol === 'https:' ? 'wss:' : 'ws:';
  return wsUrl.toString();
}