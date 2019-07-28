import * as log from '../log';
import navFactory from './Navigator.factory.js';

describe('commons/debug/log', () => {
  const logBackEnd = log.logBackEnd;
  const realUid = log.uid();

  beforeEach(() => {
    log.setUid('LOGTEST');
    log.flush(true);
  });

  describe('uid/setUid', () => {
    it('should be able to override uid as needed', () => {
      expect(log.uid()).toEqual('LOGTEST');
    });
  });

  describe('log', () => {
    it('should log a message to the queue', () => {
      log.log('a simple message');
      expect(log.queued()).toHaveLength(1);
    });
    it('should log multiple messages to the queue', () => {
      log.log('a simple message');
      log.log('a\nsimple\nmessage');
      expect(log.queued()).toEqual(['a simple message', 'a\nsimple\nmessage']);
    });
    it('should be able to log an object', () => {
      log.log('hello', { a: true });
      expect(log.formatMessages()).toEqual('UILOG: LOGTEST: hello {"a":true}');
    });
    it('should be able to log anything we throw at it', () => {
      log.log(
        'hello',
        { a: true },
        [1, 2],
        true,
        null,
        undefined,
        NaN,
        -Infinity,
        () => {},
      );
      expect(log.formatMessages()).toEqual(
        'UILOG: LOGTEST: hello {"a":true} [1,2] true null undefined NaN -Infinity function () {}',
      );
    });
  });

  describe('logSession', () => {
    it('should log browser identification for a new session', () => {
      const mockNavigator = navFactory.makeNavigatorFromMock();
      log.logSession(mockNavigator);
      expect(log.queued()).toHaveLength(1);
      expect(log.formatMessages()).toEqual(
        'UILOG: LOGTEST: New user from browser.' +
          '\nUILOG: LOGTEST: cookies | language,languages,userLanguage,browserLanguage,systemLanguage | platform | vendor | vendorSub | product | productSub | appName | appCodeName' +
          '\nUILOG: LOGTEST: userAgent' +
          '\nUILOG: LOGTEST: appVersion',
      );
    });
  });

  describe('queued', () => {
    it('should have no messages queued', () => {
      expect(log.queued()).toHaveLength(0);
    });
    it('should not be able to mess with returned queue internally', () => {
      expect(log.queued()).toHaveLength(0);
      log.queued().push('addind a message to the returned queue');
      expect(log.queued()).toHaveLength(0);
    });
  });

  describe('formatMessage', () => {
    it('should be empty when message empty', () => {
      expect(log.formatMessage('')).toEqual('');
    });
    it('should prefix each line with uid', () => {
      expect(log.formatMessage('a\nb\nc\n')).toEqual(
        'UILOG: LOGTEST: a\nUILOG: LOGTEST: b\nUILOG: LOGTEST: c',
      );
    });
    it('should prefix real uid', () => {
      log.setUid(realUid);
      expect(log.formatMessage('a\n')).toEqual(`UILOG: ${realUid}: a`);
    });
  });

  describe('formatMessages', () => {
    it('should be empty when no messages', () => {
      expect(log.formatMessages()).toEqual('');
    });
  });

  describe('flush', () => {
    let logSpy;
    beforeEach(() => {
      logSpy = jest.fn();
      log.setLogBackEnd({ logBackEnd: logSpy });
    });

    afterEach(() => {
      log.setLogBackEnd(logBackEnd);
    });

    it('should discard all messages in the buffer', () => {
      log.log('a simple message');
      log.flush(true);
      expect(log.queued()).toHaveLength(0);
      expect(logSpy).not.toHaveBeenCalled();
    });
    it('should send all messages in the buffer to the back end', () => {
      log.log('a simple message');
      log.log('a\nsimple\nmessage');
      log.flush();
      expect(log.queued()).toHaveLength(0);
      expect(logSpy).toHaveBeenCalledWith(
        'UILOG: LOGTEST: a simple message' +
          '\nUILOG: LOGTEST: a' +
          '\nUILOG: LOGTEST: simple' +
          '\nUILOG: LOGTEST: message',
      );
    });
    it('should not sent to back end if nothing in buffer', () => {
      expect(log.queued()).toHaveLength(0);
      log.flush();
      expect(log.queued()).toHaveLength(0);
      expect(logSpy).not.toHaveBeenCalled();
    });
  });
});
