// a simple test of a component by comparing an html snapshot
/* eslint-disable prefer-arrow-callback */
import React from 'react';
import { shallow } from 'enzyme';
/* eslint-disable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import { prettify } from '../parcel-test/src/test/snapshot';
import makeTimeTester from '../parcel-test/src/test/timeTest';
/* eslint-enable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import timeZoneInfo from './demo/test-dates';
import DateText from './';

const suite = 'src/DateText <DateText> Component';

const timeTest = makeTimeTester(timeZoneInfo);

const DATE_FORMAT = 'dddd D MMM YYYY h:mm:ss A ZZZ';

/* eslint-disable no-useless-escape */
// You should be able to paste the HTML output shown on the console directly
// and the prettify function will take care of the spacing differences.
const HTML = `
<time
id={[undefined]}
className=\"DateText\"
dateTime=\"%ISO_DATE%\"
title=\"%ISO_DATE%\"
style={{...}}>
%LOCAL_DATE%
</time>
`;

const HTML_SUMMER = `
<time
id={[undefined]}
className=\"DateText\"
dateTime=\"%ISO_SUMMER_DATE%\"
title=\"%ISO_SUMMER_DATE%\"
style={{...}}>
%LOCAL_SUMMER_DATE%
</time>
`;

const HTML_ALL = `
<time
id=\"ID\"
className=\"CLASS NAME LIST DateText\"
dateTime=\"%ISO_DATE%\"
title=\"%ISO_DATE%\"
style={{...}}>
%LOCAL_DATE%
</time>
`;
/* eslint-enable no-useless-escape */

describe(suite, function descDateTextComponentSuite() {
  function buildComponent(props = {}) {
    const context = { router: {} };
    // console.log('buildComponent DATE', new Date());
    const mergedProps = {
      date: new Date(),
      dateFormat: DATE_FORMAT,
      ...props,
    };
    const wrapped = shallow(<DateText {...mergedProps} />, { context });
    return wrapped;
  }

  describe('match snapshot HTML', function descDateTextSnapshotSuite() {
    timeTest.it(
      'should match when rendered with minimal props',
      { dateString: timeZoneInfo.TEST_TIME },
      function testDateTextMinimalRender() {
        const component = buildComponent();
        const html = component.debug();
        const expected = timeTest.insertDates(prettify(HTML));
        const actual = timeTest.replaceShortTimeZoneNames(prettify(html));
        expect(actual).toBe(expected);
      },
    );

    timeTest.it(
      'should match when rendered with summer time',
      { dateString: timeZoneInfo.TEST_SUMMER_TIME },
      function testDateTextSummerRender() {
        const component = buildComponent();
        const html = component.debug();
        const expected = timeTest.insertDates(prettify(HTML_SUMMER));
        const actual = timeTest.replaceShortTimeZoneNames(prettify(html));
        expect(actual).toBe(expected);
      },
    );

    timeTest.it(
      'should match when rendered with all props',
      { dateString: timeZoneInfo.TEST_TIME },
      function testDateTextRenderAllProps() {
        const component = buildComponent({
          id: 'ID',
          className: 'CLASS NAME LIST',
          style: { background: 'lemonchiffon' },
        });
        const html = component.debug();
        const expected = timeTest.insertDates(prettify(HTML_ALL));
        const actual = timeTest.replaceShortTimeZoneNames(prettify(html));
        expect(actual).toBe(expected);
      },
    );
  }); // match snapshot HTML

  describe('match styles', function descDateTextStylesSuite() {
    function getStyle(component) {
      // eslint-disable-next-line lodash/prefer-lodash-method
      const found = component.find('time#ID').get(0).props.style;
      return found;
    }

    it('should match styles by default', function testDateTextStyles() {
      const component = buildComponent({
        id: 'ID',
      });
      expect(getStyle(component)).toEqual({});
    });

    it('should match styles by override', function testDateTextStylesOverride() {
      const component = buildComponent({
        id: 'ID',
        style: { background: 'lemonchiffon' },
      });
      expect(getStyle(component)).toEqual({ background: 'lemonchiffon' });
    });
  }); // match styles
});
/* eslint-enable prefer-arrow-callback */
