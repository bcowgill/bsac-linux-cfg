/* eslint-disable prefer-arrow-callback */

/* eslint-disable import/no-unresolved, import/extensions */
import makeTimeTester from '../parcel-test/src/test/timeTest.js';
/* eslint-enable import/no-unresolved, import/extensions */

import dateFormat from './date-format';

const suite = 'src/util/date-format dateFormat Function';

const timeZoneInfo = {
  FORMAT: 'YYYY-MM-DD h:mm:ss ZZZ',
  FORMAT_NAMES: '(UTC) (BST) (PST) (PDT)',
  TEST_TIME: 'December 25, 1991 12:12:59 GMT',
  TEST_LOCAL_TIME: 'July 25, 1991 12:12:59',
  UTC: {
    // Jenkins no Daylight time
    0: {
      DEFAULT: '1991-12-25T12:12:59.000+00:00',
      FORMATTED: '1991-12-25 12:12:59 (GMT Standard Time)',
      FORMATTED_LOCAL: '1991-07-25 12:12:59 (GMT Standard Time)',
    },
  },
  'Europe/London': {
    0: {
      DEFAULT: '1991-12-25T12:12:59.000+00:00',
      FORMATTED: '1991-12-25 12:12:59 (GMT Standard Time)',
      FORMATTED_LOCAL: '1991-12-25 12:12:59 (GMT Standard Time)',
    },
    '-60': {
      // BST time zone offest from GMT
      FORMATTED_LOCAL: '1991-07-25 12:12:59 (GMT Daylight Time)',
    },
  },
  'America/Vancouver': {
    480: {
      // PST time zone offset from GMT for Pacific Time
      DEFAULT: '1991-12-25T04:12:59.000-08:00',
      FORMATTED: '1991-12-25 4:12:59 (Pacific Standard Time)',
    },
    420: {
      // PDT time zone offest from GMT for Pacific Daylight Time
      FORMATTED_LOCAL: '1991-07-25 12:12:59 (Pacific Daylight Time)',
    },
  },
};

const timeTest = makeTimeTester(timeZoneInfo);

describe(suite, function descDateFormatSuite() {
  timeTest.it(
    'should handle default parameters',
    { dateString: timeZoneInfo.TEST_TIME },
    function testDateFormat() {
      const expected = timeTest.insertDates('%DEFAULT%');
      const actual = timeTest.replaceShortTimeZoneNames(dateFormat());
      expect(actual).toBe(expected);
    },
  );

  timeTest.it(
    'should extend formats with ZZZ format GMT',
    { dateString: timeZoneInfo.TEST_TIME },
    function testDateFormatExtendZZZGMT() {
      const expected = timeTest.insertDates('%FORMATTED%');
      const actual = timeTest.replaceShortTimeZoneNames(
        dateFormat(timeZoneInfo.FORMAT),
      );
      expect(actual).toBe(expected);
    },
  );

  // really belongs in a unit test file for timeTest.js
  timeTest.it(
    'insertDates should replace short time zone names with long',
    { dateString: timeZoneInfo.TEST_LOCAL_TIME },
    function testDateFormatExtendZZZLocal() {
      const expected =
        '(GMT Standard Time) (British Summer Time) (Pacific Standard Time) (Pacific Daylight Time)';
      const actual = timeTest.insertDates(timeZoneInfo.FORMAT_NAMES);
      expect(actual).toBe(expected);
    },
  );

  timeTest.it(
    'should extend formats with ZZZ format local time zone',
    { dateString: timeZoneInfo.TEST_LOCAL_TIME },
    function testDateFormatExtendZZZLocal() {
      timeTest.debugInfo(suite);
      const expected = timeTest.insertDates('%FORMATTED_LOCAL%');
      const actual = timeTest.replaceShortTimeZoneNames(
        dateFormat(timeZoneInfo.FORMAT),
      );
      expect(actual).toBe(expected);
    },
  );
});
