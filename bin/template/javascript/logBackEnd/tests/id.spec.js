/* eslint import/no-named-as-default-member: 0 */
import * as id from '../id';
import navFactory from './Navigator.factory.js';

describe('commons/debug/id', () => {
  const uidSave = id.uid();

  afterEach(() => {
    id.setUid(uidSave);
  });

  describe('setUid', () => {
    it('should be able to override uid as needed', () => {
      id.setUid('IDTEST');
      expect(id.uid()).toEqual('IDTEST');
    });
  });

  describe('uid', () => {
    it('should return a unique ID which is date/time like', () => {
      expect(id.uid()).toMatch(/^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\.\d+Z\d+$/);
    });
  });

  describe('sign', () => {
    it('should sign each line of a message with the uid', () => {
      id.setUid('IDTEST');
      expect(id.sign('a\nb\nc')).toEqual(
        'UILOG: IDTEST: a\nUILOG: IDTEST: b\nUILOG: IDTEST: c',
      );
    });
    it('should sign initial blank line', () => {
      id.setUid('IDTEST');
      expect(id.sign('\na\nb\nc')).toEqual(
        'UILOG: IDTEST: \nUILOG: IDTEST: a\nUILOG: IDTEST: b\nUILOG: IDTEST: c',
      );
    });
    it('should sign blank message', () => {
      id.setUid('IDTEST');
      expect(id.sign('')).toEqual('UILOG: IDTEST: ');
    });
  });

  describe('getLanguage', () => {
    it('should get language from Mock browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromMock();
      expect(id.getLanguage(mockNavigator)).toEqual(
        'language,languages,userLanguage,browserLanguage,systemLanguage',
      );
    });

    it('should get language from Safari browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromSafari();
      expect(id.getLanguage(mockNavigator)).toEqual('en-GB,en-GB');
    });

    it('should get language from Chrome browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromChrome();
      expect(id.getLanguage(mockNavigator)).toEqual('en-GB,en-US,en');
    });

    it('should get language from FireFox browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromFireFox();
      expect(id.getLanguage(mockNavigator)).toEqual('en-US,en-US,en');
    });

    it('should get language from IE9 browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromIE9();
      expect(id.getLanguage(mockNavigator)).toEqual('en-us,en-us,en-gb');
    });

    it('should get language from IE10 browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromIE10();
      expect(id.getLanguage(mockNavigator)).toEqual('en-GB,en-US,en-GB');
    });

    it('should get language from IE11 browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromIE11();
      expect(id.getLanguage(mockNavigator)).toEqual('en-GB,en-GB,en-US,en-GB');
    });
  });

  describe('formatBrowserIdentity', () => {
    it('should format browser identity string from Mock browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromMock();
      expect(id.formatBrowserIdentity(mockNavigator)).toEqual(
        'cookies | language,languages,userLanguage,browserLanguage,systemLanguage | platform | vendor | vendorSub | product | productSub | appName | appCodeName' +
          '\nuserAgent' +
          '\nappVersion',
      );
    });

    it('should format browser identity string from Safari browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromSafari();
      expect(id.formatBrowserIdentity(mockNavigator)).toEqual(
        'cookies | en-GB,en-GB | MacIntel | Apple Computer, Inc. |  | Gecko | 20030107 | Netscape | Mozilla' +
          '\nMozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17' +
          '\n5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17',
      );
    });

    it('should format browser identity string from Chrome browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromChrome();
      expect(id.formatBrowserIdentity(mockNavigator)).toEqual(
        'cookies | en-GB,en-US,en | Linux x86_64 | Google Inc. |  | Gecko | 20030107 | Netscape | Mozilla' +
          '\nMozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36' +
          '\n5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36',
      );
    });

    it('should format browser identity string from FireFox browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromFireFox();
      expect(id.formatBrowserIdentity(mockNavigator)).toEqual(
        'cookies | en-US,en-US,en | Linux_x86_64 |  |  | Gecko | 20100101 | Netscape | Mozilla' +
          '\nMozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:43.0) Gecko/20100101 Firefox/43.0' +
          '\n5.0 (X11)',
      );
    });

    it('should format browser identity string from IE9 browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromIE9();
      expect(id.formatBrowserIdentity(mockNavigator)).toEqual(
        'cookies | en-us,en-us,en-gb | Win32 |  |  |  |  | Microsoft Internet Explorer | Mozilla' +
          '\nMozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)' +
          '\n5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)',
      );
    });

    it('should format browser identity string from IE10 browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromIE10();
      expect(id.formatBrowserIdentity(mockNavigator)).toEqual(
        'cookies | en-GB,en-US,en-GB | Win32 |  |  |  |  | Microsoft Internet Explorer | Mozilla' +
          '\nMozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)' +
          '\n5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)',
      );
    });

    it('should format browser identity string from IE11 browser', () => {
      const mockNavigator = navFactory.makeNavigatorFromIE11();
      expect(id.formatBrowserIdentity(mockNavigator)).toEqual(
        'cookies | en-GB,en-GB,en-US,en-GB | Win32 |  |  | Gecko |  | Netscape | Mozilla' +
          '\nMozilla/5.0 (Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; rv: 11.0) like Gecko' +
          '\n5.0 (Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; rv: 11.0) like Gecko',
      );
    });
  });
});
