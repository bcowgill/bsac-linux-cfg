import config from './config';

require('es6-promise/auto');
require('whatwg-fetch');

let fetcher = fetch;

export function setFetch(fnFetch) {
  const old = fetcher;
  if (fnFetch) {
    fetcher = fnFetch;
  }
  return old;
}

export function logBackEnd(payload) {
  return fetcher(config.log, {
    method: 'POST',
    body: payload,
  });
}
