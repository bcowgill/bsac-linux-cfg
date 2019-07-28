import * as id from './id';
import * as logger from './logBackEnd';
import stringify from '../stringify';

const INTERVAL = 2 * 60 * 1000;
let logBackEnd = logger;
let messages = [];

export function uid() {
  return id.uid();
}

export function prefix() {
  return id.prefix();
}

export function setUid(newUid) {
  return id.setUid(newUid);
}

export function setLogBackEnd(fnLog) {
  const old = logBackEnd;
  if (fnLog) {
    logBackEnd = fnLog;
  }
  return old;
}

export function log(...args) {
  const pretty = args.map(obj => stringify(obj)).join(' ');
  messages.push(pretty);
}

export function logSession(navObj) {
  log(`New user from browser.\n${id.formatBrowserIdentity(navObj)}`);
}

export function queued() {
  return [...messages];
}

export function formatMessage(multiLines) {
  const logs = multiLines.replace(/\n$/, '');
  const message = /^\s*$/.test(logs) ? '' : id.sign(logs);
  return message;
}

export function formatMessages() {
  const message = messages.map(entry => formatMessage(entry)).join('\n');
  return message;
}

export function flush(discard) {
  if (!discard) {
    const message = formatMessages();
    if (message.length) {
      // console.info('FLUSHING LOGS TO BACK END');
      logBackEnd.logBackEnd(message);
    }
  }
  messages = [];
}

/* eslint no-console : 0 */
export function logPeriodically(interval = INTERVAL) {
  console.warn(
    `${prefix()}BACK END LOGGING FLUSHED EVERY ${interval / 1000} SECONDS`,
  );
  logSession();
  return setInterval(() => {
    flush();
  }, interval);
}
