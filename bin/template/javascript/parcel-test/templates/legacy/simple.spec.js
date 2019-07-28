/* eslint-disable prefer-arrow-callback */

import TEMPLATE from './';

const suite = 'src/util/TEMPLATE';

describe(suite, function descTEMPLATESuite() {
  it('should handle default parameters', function testTEMPLATE() {
    const expected = 'some result';
    const actual = TEMPLATE();
    expect(actual).toBe(expected);
  });
});
