// BSAC our warning function
function warn(...args) {
  if (process.env.HAR_DEBUG) {
    console.warn(...args);
  }
}

in page.js:

async routeFromHAR(har, options = {}) {
  warn(`BSAC routeFromHAR options`, options);

in HarRouter=js:

class HarRouter
  static async create(localUtils, file, notFoundAction, options) {
    warn(`BSAC HarRouter.create options`, options);
  constructor(localUtils, harId, notFoundAction, options) {
    ...
    warn(`BSAC HarRouter.constructor options`, options);
  }
  async _handle(route) {
    const request...
    warn(`BSAC HarRouter._handle options`, this._options);
    warn(`BSAC HarRouter._handle _channel`, this._localUtils._channel.harLookup);
    ...
    sanitiseUrl: this._options.sanitiseUrl, // BSAC AHA the missing connection
    ...
    },
    { HELLO: 'XYZZY' }, // BSAC

in dispatcher.js:

async _handleCommand(callMetadata, method, validParams) {
  if (method === 'harLookup') {
    warn(`BSAC _handleCommand ${method} meta`, callMetadata);
    warn(`BSAC _handleCommand validParams`, validParams);
  }
in localUtilsDispatcher.js:

async harLookup(
  params,
  metadata,
  sanitiseUrl, // BSAC (url: string) => string
} {
  warn(`BSAC harLookup santitiseUrl`, sanitiseUrl, '\nparams', params, '\nmeta, metadata');
  // try { throw new Error("BSAC STOP") } catch (e) {
  //   console.error('BSAC WHOAH', e);
  // }
  ...
  warn(`BSAC await harBackend.lookup`);
  return await harBackend.lookup(
    ...
    sanitiseUrl, // BSAC pipe it through to next call
  );

const identity = (url) => url; // BSAC default sanitiser

class HarBackend {
  ...
  async lookup(url, method, headers, postData, isNavigationRequest, sanitiseUrl = identity) {
    // BSAC pipe destination
  warn(`BSAC HarBackend.lookup santitiseUrl`, sanitiseUrl);
  warn(`BSAC HarBackend.lookup1 ${method} ${url}`);
  try {
    warn(`BSAC HarBackend.lookup2 ${method} ${url}`, this._harFindResponse);
    entry = await thie._harFindResponse(url, method, headers, postData, sanitiseUrl); // BSAC piping it through
    warn(`BSAC HarBackend.lookup3`);
  } catch (e) {
    warn(`BSAC HarBackend.lookup4`, e);
    return {
      action: 'error',
      message: 'HAR error: ' + e.message,
    };
  }
  warn(`BSAC HarBackend.lookup5 no entry?`);

  if (!entry) return { ... };
  warn(`BSAC HarBackend.lookup6 carry on, will redirect?\nERU: ${entry.request.url}\nURL: ${url}`);
  ...
  warn(`BSAC HarBackend.lookup7 nope, go for it`);
  const response = entry.response;
  try {
    warn(`BSAC HarBackend.lookup8 _loadContent`);
    ...
    warn(`BSAC HarBackend.lookup9 fulfill`, result);
    return result;
  } catch (e) {
    warn(`BSAC HarBackend.lookup10`, e);
    return { action: 'error',

async _harFindResponse(url, method, headers, postData, sanitiseUrl = identity) {
  // BSAC more pipework
  warn(`BSAC _harFindResponse sanitiseUrl`, sanitiseUrl);
  ...
  while (true) {
    warn(`BSAC _harFindResponseA`);
    ...
    for (const candidate of harLog.entries) {
      warn(`\nBSAC HAR CMP API ${candidate.request.method}==${method}\nHAR: ${candidate.request.url}\nAPI: ${url}`);
      if (
        // BSAC here is the fix location...
        sanitiseUrl(candidate.request.url) !== sanitiseUrl(url) ||
        candidate.request.method !== method
      )
        continue;
      warn(`BSAC _harFindResponse1`);

     if (method === 'POST' ...)
      warn(`BSAC _harFindResponse2`);
      entries.push(...)
      warn(`BSAC _harFindResponse3`);
    }
    warn(`BSAC _harFindResponse4`);
    if (entries.length) return;
    warn(`BSAC _harFindResponse5`);
    let entry = entries[0];
    warn(`BSAC _harFindResponse6`);
    if (entrids.length > 1) {
      warn(`BSAC _harFindResponse7 multiple matches on URL`);
      const list = [];
      warn(`BSAC _harFindResponse8`);
      for (const candidate...
        warn(`BSAC _harFindResponse9 header matching...`);
        ...
      }
      warn(`BSAC _harFindResponse10 sort by #header matches`);
      list.sort(...
      warn(`BSAC _harFindResponse11 select first match`);
      entry = list[0]...
      warn(`BSAC _harFindResponse12`);
    }
    warn(`BSAC _harFindResponse13 check for cycle`);
    if (visited.has(entry...
    warn(`BSAC _harFindResponse14 visited`);
    ...
    warn(`BSAC _harFindResponse15 check redirect`);
    if (redirectStatus.includes(...) {
      warn(`BSAC _harFindResponse16`);
      const locatoinURL = new...
      url = locatoinURL.toString();
      warn(`BSAC _harFindResponse17 redirect ${url}`);
      if (
        ...
      ) {
        warn(`BSAC _harFindResponse18 redirect with GET`);
        // HTTP-redirect...
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
  dispose()...
