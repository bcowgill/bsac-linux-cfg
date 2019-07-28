// timeTest.js
// A tool for performing date / time related tests with fixed dates so that
// time zone and daylight savings time does not cause test failures every 6 months

import replace from 'lodash/replace';
import timeMachine from 'timemachine';
import isUndefined from 'lodash/isUndefined';

/*
  Example of how to perform time related tests so that different time zones
  are checked against different expected test data.

  Note, on windows to test alternate time zones you have to manually change
  your time zone in control panel / Date and Time then change the Europe/London
  DEFAULT_ZONE string in timeTest.js manually to the matching unix time zone TZ name

  const timeZoneInfo = {
    // You should test with at least two dates 6 months apart
    TEST_TIME: 'December 25, 1991 12:12:59 GMT',
    TEST_SUMMER_TIME: 'July 22, 1991 12:13:59',
    UTC: {
      // Jenkins no Daylight time
      0: {
        ISO_DATE: '1991-12-25T12:12:59.000Z',
        ISO_SUMMER_DATE: '1991-07-22T12:13:59.000Z',
        LOCAL_DATE: 'Wednesday 25 Dec 1991 12:12:59 PM (GMT Standard Time)',
        LOCAL_SUMMER_DATE: 'Monday 22 Jul 1991 12:13:59 PM (GMT Standard Time)',
      },
    },
    'Europe/London': {
      0: {
        ISO_DATE: '1991-12-25T12:12:59.000Z',
        LOCAL_DATE: 'Wednesday 25 Dec 1991 12:12:59 PM (GMT Standard Time)',
      },
      '-60': {
        ISO_SUMMER_DATE: '1991-07-22T11:13:59.000Z',
        LOCAL_SUMMER_DATE: 'Monday 22 Jul 1991 12:13:59 PM (GMT Daylight Time)',
      },
    },
    'America/Vancouver': {
      480: {
        ISO_DATE: '1991-12-25T12:12:59.000Z',
        LOCAL_DATE: 'Wednesday 25 Dec 1991 4:12:59 AM (Pacific Standard Time)',
      },
      420: {
        ISO_SUMMER_DATE: '1991-07-22T19:13:59.000Z',
        LOCAL_SUMMER_DATE:
          'Monday 22 Jul 1991 12:13:59 PM (Pacific Daylight Time)',
      },
    },
  };

  const timeTest = makeTimeTester(timeZoneInfo);

  describe ...
    timeTest.it('should perform a test with a fixed date for new Date()',
      // See npm module timemachine for config options
      { dateString: timeZoneInfo.TEST_TIME },
      function testDateText() {
        const actual = timeTest.replaceShortTimeZoneNames(some_function_of_current_date_time());
        const expected = timeTest.insertDates(
          'Surrounding Text and %FORMATTED% date values %FORMATTED_LOCAL%');
        expect(actual).toBe(expected);
    });
*/

// eslint-disable-next-line no-console
const log = console.error;

// use a name of UTC on Jenkins linux machine
// use Europe/London on windows machines as summer time in use
const DEFAULT_ZONE = process.platform === 'win32' ? 'Europe/London' : 'UTC';

// Use this to test other time zone locally on windows
// because TZ env variable does not work.
// Set your control panel date to Pacific time also.
// const DEFAULT_ZONE = 'America/Vancouver';

// Map short linux time zone names to longer Windows ones for unit test uniformity.
const timeZoneMap = {
  '(GMT)': '(GMT Standard Time)',
  '(UTC)': '(GMT Standard Time)',
  '(BST)': '(British Summer Time)',
  '(PST)': '(Pacific Standard Time)',
  '(PDT)': '(Pacific Daylight Time)',
  '(GMT Daylight Time)': '(British Summer Time)',
  '(Coordinated Universal Time)': '(GMT Standard Time)',
//  '(GMT Standard Time)': '(UTC)',
//  '(British Summer Time)': '(BST)',
//  '(Pacific Standard Time)': '(PST)',
//  '(Pacific Daylight Time)': '(PDT)',
};

function replaceShortTimeZoneNames(text) {
  const reTimeZone = /(\([^)]+\))/g;
  // log('replaceShortTimeZoneNames', text);
  /* eslint-disable prefer-arrow-callback */
  const replaced = replace(text, reTimeZone,
    function replaceTimeZoneToken(placeholder, token) {
      // log('replaceShortTimeZoneNames', token, timeZoneMap[token]);
      return timeZoneMap[token] || token;
    });
  /* eslint-enable prefer-arrow-callback */
  return replaced;
}

export default function makeTimeTester(timeZoneInfo) {
  const timeZone = process.env.TZ || DEFAULT_ZONE;
  const timeTester = {
    timeZone,
    debugInfo(message) {
      const date = new Date();
      log(`timeTest debugInfo from ${message}`);
      log('process.platform', process.platform);
      log('process.env.TZ', process.env.TZ);
      log('system TZ=', timeZone);
      log('Date valueOf           ', date.valueOf());
      log('Date toString          ', date.toString());
      log('Date getTimezoneOffset ', date.getTimezoneOffset());
      // log('Date getTimezoneName', date.getTimezoneName());
      // log('Date toDateString      ', date.toDateString());
      // log('Date toTimeString      ', date.toTimeString());
      log('Date toISOString       ', date.toISOString());
      // log('Date toJSON            ', date.toJSON());
      // log('Date toGMTString       ', date.toGMTString());
      // log('Date toUTCString       ', date.toUTCString());
      // log('Date toLocaleString    ', date.toLocaleString());
      // log('Date toLocaleDateString', date.toLocaleDateString());
      // log('Date toLocaleTimeString', date.toLocaleTimeString());
    },

    TZ(date, key) {
      const offset = date.getTimezoneOffset();
      const zone = timeZoneInfo[timeZone];
      if (zone) {
        const savings = zone[offset];
        if (savings && !isUndefined(savings[key])) {
          return savings[key];
        }
      }
      throw new Error(
        `timeZoneInfo[${timeZone}][${offset}].${key} is not configured with test data.`,
      );
    },

    replaceShortTimeZoneNames,
    insertDate(text, key, date = new Date()) {
      const regex = new RegExp(`%${key}%`, 'g');
      return replace(text, regex, timeTester.TZ(date, key));
    },

    insertDates(template, date = new Date()) {
      const reToken = /%(\w+)%/g;
      const errorTokens = [];
      // eslint-disable-next-line prefer-arrow-callback
      let replaced = replace(template, reToken, function replaceDateToken(placeholder, token) {
        try {
          return timeTester.TZ(date, token);
        } catch (error) {
          errorTokens.push(token);
          return `\n<< ${error.toString()} >>`;
        }
      });
      if (errorTokens.length) {
        const markers = `%${errorTokens.join('%, %')}%`;
        throw new Error(`Expected test template is missing time zone specific data.\nmarkers: ${markers}\n${replaced}`);
      }
      // log('insertDates 1', replaced);
      replaced = replaceShortTimeZoneNames(replaced);
      // log('insertDates 2', replaced);
      return replaced;
    },

    it(title, config, fnTest) {
      it(title, () => {
        let thisError;

        /* eslint-disable no-param-reassign */
        if (!fnTest) {
          fnTest = config;
          config = {};
        }
        /* eslint-enable no-param-reassign */

        // log('timeTest CONFIG', config);
        timeMachine.config(config);
        try {
          fnTest();
        } catch (failure) {
          thisError = failure;
        } finally {
          timeMachine.reset();
          timeMachine.config({});
        }
        if (thisError) {
          throw thisError;
        }
      });
    },

    async: {
      it(title, config, fnTest) {
        it(title, (asyncDone) => {
          let thisError;

          /* eslint-disable no-param-reassign */
          if (!fnTest) {
            fnTest = config;
            config = {};
          }
          /* eslint-enable no-param-reassign */

          // log('timeTest CONFIG', config);
          timeMachine.config(config);
          try {
            fnTest();
          } catch (failure) {
            thisError = failure;
          } finally {
            timeMachine.reset();
            timeMachine.config({});
          }
          if (thisError) {
            throw thisError;
          }
          asyncDone();
        });
      },
    },
  };
  timeTester.it.skip = function timeTestSkip(title, unusedConfig, fnTest) {
    // eslint-disable-next-line  jest/no-disabled-tests
    it.skip(title, fnTest);
  };
  timeTester.async.it.skip = timeTester.it.skip;
  return timeTester;
}
