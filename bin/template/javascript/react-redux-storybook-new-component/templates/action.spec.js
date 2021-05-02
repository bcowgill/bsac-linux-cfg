/* eslint-disable prefer-arrow-callback */
import { TEMPLATEOBJNAMESuccess } from './TEMPLATEFILENAME'

const suite = 'src/actions/TEMPLATEPATH TEMPLATEOBJNAME Actions'

describe(suite, function descTEMPLATETESTNAMEActionSuite() {
	it('should return a success action', function testTEMPLATETESTNAMEActionSuccess() {
		const expected = {
			payload: {},
			type: 'TEMPLATEACTION_SUCCESS',
		}
		const actual = TEMPLATEOBJNAMESuccess({ some: 'success payload' })
		expect(actual).toEqual(expected)
	})
})
