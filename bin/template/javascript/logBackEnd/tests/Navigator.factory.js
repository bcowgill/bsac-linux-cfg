export default {
  makeNavigatorFromSafari() {
    return {
      language: 'en-GB',
      languages: ['en-GB'],
      cookieEnabled: true,
      platform: 'MacIntel',
      vendor: 'Apple Computer, Inc.',
      vendorSub: '',
      product: 'Gecko',
      productSub: '20030107',
      appName: 'Netscape',
      appCodeName: 'Mozilla',
      appVersion:
        '5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17',
      userAgent:
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17',
    };
  },
  makeNavigatorFromChrome() {
    return {
      langugage: 'en-GB',
      languages: ['en-GB', 'en-US', 'en'],
      cookieEnabled: true,
      platform: 'Linux x86_64',
      vendor: 'Google Inc.',
      vendorSub: '',
      product: 'Gecko',
      productSub: '20030107',
      appName: 'Netscape',
      appCodeName: 'Mozilla',
      appVersion:
        '5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36',
      userAgent:
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36',
    };
  },
  makeNavigatorFromFireFox() {
    return {
      language: 'en-US',
      languages: ['en-US', 'en'],
      cookieEnabled: true,
      platform: 'Linux_x86_64',
      vendor: '',
      vendorSub: '',
      product: 'Gecko',
      productSub: '20100101',
      appName: 'Netscape',
      appCodeName: 'Mozilla',
      appVersion: '5.0 (X11)',
      userAgent:
        'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:43.0) Gecko/20100101 Firefox/43.0',
    };
  },
  makeNavigatorFromIE9() {
    return {
      // made up, not checked in real browser
      language: 'en-us',
      // userLanguage: 'en-gb',
      browserLanguage: 'en-us',
      systemLanguage: 'en-gb',
      cookieEnabled: true,
      platform: 'Win32',
      vendor: '',
      vendorSub: '',
      product: '',
      productSub: '',
      appName: 'Microsoft Internet Explorer',
      appCodeName: 'Mozilla',
      appVersion:
        '5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)',
      userAgent:
        'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)',
    };
  },
  makeNavigatorFromIE10() {
    return {
      // made up, not checked in real browser
      userLanguage: 'en-GB',
      browserLanguage: 'en-US',
      systemLanguage: 'en-GB',
      cookieEnabled: true,
      platform: 'Win32',
      vendor: '',
      vendorSub: '',
      product: '',
      productSub: '',
      appName: 'Microsoft Internet Explorer',
      appCodeName: 'Mozilla',
      appVersion:
        '5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)',
      userAgent:
        'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)',
    };
  },
  makeNavigatorFromIE11() {
    return {
      language: 'en-GB',
      userLanguage: 'en-GB',
      browserLanguage: 'en-US',
      systemLanguage: 'en-GB',
      cookieEnabled: true,
      platform: 'Win32',
      vendor: '',
      vendorSub: '',
      product: 'Gecko',
      productSub: '',
      appName: 'Netscape',
      appCodeName: 'Mozilla',
      appVersion:
        '5.0 (Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; rv: 11.0) like Gecko',
      userAgent:
        'Mozilla/5.0 (Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; rv: 11.0) like Gecko',
    };
  },
  makeNavigatorFromMock() {
    return {
      language: 'language',
      languages: ['languages'],
      userLanguage: 'userLanguage',
      browserLanguage: 'browserLanguage',
      systemLanguage: 'systemLanguage',
      cookieEnabled: true,
      platform: 'platform',
      vendor: 'vendor',
      vendorSub: 'vendorSub',
      product: 'product',
      productSub: 'productSub',
      appName: 'appName',
      appCodeName: 'appCodeName',
      appVersion: 'appVersion',
      userAgent: 'userAgent',
    };
  },
};
