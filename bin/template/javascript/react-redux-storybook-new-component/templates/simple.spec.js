/* eslint-disable prefer-arrow-callback */

import TEMPLATEOBJNAME from './TEMPLATEFILENAME'

const suite = 'TEMPLATESRCPATH TEMPLATEOBJNAME'

describe(suite, function descTEMPLATETESTNAMESuite() {
	it('should handle default parameters', function testTEMPLATETESTNAME() {
		const expected = 'some result'
		const actual = TEMPLATEOBJNAME('some input')
		expect(actual).toBe(expected)
	})
})
