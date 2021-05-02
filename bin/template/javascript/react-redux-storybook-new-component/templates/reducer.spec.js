/* eslint-disable prefer-arrow-callback */
import TEMPLATEOBJNAME from './TEMPLATEFILENAME'
import { TEMPLATEACTION_SUCCESS } from '../actions/types'
import { TEMPLATEACTIONFUNC } from '../actions/TEMPLATEACTIONFILE'

const suite = 'src/reducers/TEMPLATEPATH TEMPLATEOBJNAME Reducer'

describe(suite, function descTEMPLATETESTNAMESuite() {
	it('should return initial state', function testTEMPLATETESTNAME() {
		const expected = {}
		const actual = TEMPLATEOBJNAME()
		expect(actual).toEqual(expected)
	})

	it('should return current state for unknown action', function testTEMPLATETESTNAMEUnknownAction() {
		const expected = TEMPLATEOBJNAME()
		const actual = TEMPLATEOBJNAME(expected, {})
		expect(actual).toBe(expected)
	})

	it('should handle TEMPLATEACTION_SUCCESS action', function testTEMPLATETESTNAMETEMPLATEACTIONTESTAction() {
		const state = TEMPLATEOBJNAME()
		const expected = { bogus: 'information', data: [] }
		const actual = TEMPLATEOBJNAME(state, {
			type: TEMPLATEACTION_SUCCESS,
			payload: { some: 'stuff' },
		})
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})

	it('should handle TEMPLATEACTIONFUNC function action', function testTEMPLATETESTNAMETEMPLATEACTIONTESTFunctionAction() {
		const state = TEMPLATEOBJNAME()
		const expected = { bogus: 'information', data: [] }
		const actual = TEMPLATEOBJNAME(state, TEMPLATEACTIONFUNC({ some: 'stuff' }))
		expect(actual).toEqual(expected)
		expect(actual).not.toBe(state) // state is immutable
	})
})
