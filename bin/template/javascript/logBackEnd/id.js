/* eslint no-underscore-dangle: 0 */
const PREFIX = 'UILOG: ';
const when = new Date();
const rand = Math.trunc(1000 * Math.random());
let UID;

export function setUid(newUid) {
  UID = newUid;
}

export function _globalNavigator(navObj) {
  return navObj || navigator;
}

export function uid() {
  return UID || when.toISOString() + rand;
}

export function prefix() {
  return `${PREFIX + uid()}: `;
}

export function sign(message) {
  const ident = prefix();
  return ident + message.replace(/\n/g, `\n${ident}`);
}

export function getLanguage(nav) {
  const navObj = _globalNavigator(nav);
  const languages = [];
  if (navObj.language) {
    languages.push(navObj.language);
  }
  if (navObj.languages) {
    navObj.languages.forEach(language => {
      languages.push(language);
    });
  }
  if (navObj.userLanguage) {
    languages.push(navObj.userLanguage);
  }
  if (navObj.browserLanguage) {
    languages.push(navObj.browserLanguage);
  }
  if (navObj.systemLanguage) {
    languages.push(navObj.systemLanguage);
  }
  return languages.join(',');
}

export function formatBrowserIdentity(nav) {
  const navObj = _globalNavigator(nav);
  let message = [
    navObj.cookieEnabled ? 'cookies' : '!cookies',
    getLanguage(navObj),
    navObj.platform,
    navObj.vendor,
    navObj.vendorSub,
    navObj.product,
    navObj.productSub,
    navObj.appName,
    navObj.appCodeName,
  ].join(' | ');
  message += `\n${navObj.userAgent}\n${navObj.appVersion}`;
  return message;
}

UID = uid();
