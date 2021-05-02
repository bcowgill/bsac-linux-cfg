/* eslint-disable prefer-arrow-callback */

import * as hoc from './hoc'

const suite = 'src/components/utils/ hoc'

const hocName = hoc.default

describe(suite, function descHocSuite() {
	describe('getFunctionName()', function descHocGetFunctionNameSuite() {
		it('should handle a function', function testHocGetFunctionNameMissingDisplayName() {
			const expected = 'FunctionName'
			const actual = hoc.getFunctionName(function FunctionName() {})
			expect(actual).toBe(expected)
		})
		it('should handle unknown', function testHocGetFunctionNameDisplayName() {
			const expected = 'Unknown'
			const actual = hoc.getFunctionName({})
			expect(actual).toBe(expected)
		})
	}) // getFunctionName()

	describe('hocName()', function descHocNameSuite() {
		it('should handle displayName', function testHocNameDisplayName() {
			const expected = 'HOC(DisplayName)'
			const actual = hocName('HOC', { displayName: 'DisplayName' })
			expect(actual).toBe(expected)
		})
		it('should handle missing displayName', function testHocNameMissingDisplayName() {
			const expected = 'HOC(FunctionName)'
			const actual = hocName('HOC', function FunctionName() {})
			expect(actual).toBe(expected)
		})
		it('should handle unknown', function testHocNameDisplayName() {
			const expected = 'HOC(Unknown)'
			const actual = hocName('HOC', {})
			expect(actual).toBe(expected)
		})
	}) // hocName()
})
