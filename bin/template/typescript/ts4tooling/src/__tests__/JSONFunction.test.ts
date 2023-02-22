import { describe, expect, test } from '@jest/globals'
import * as testMe from '../JSONFunction'

const displayName = 'JSONFunction'

describe(`${displayName} module tests`, function descJSONFunctionSuite() {
	const TYPE = testMe.displayName
	function fnFunc(x: number, y: number, z = 0) {
		return (x + y) * z
	}
	function fnFuncVar(...args: unknown[]) {
		// eslint-disable-next-line no-console
		console.warn(displayName, ...args)
	}

	describe(`${displayName}()`, function descJSONFunctionSuite() {
		test('JSON.stringify does not handle Function objects', function testJSONStringifyFunction() {
			const got = JSON.stringify({
				split: function SplitMe(str: string, ch: string | RegExp) {
					return str.split(ch)
				},
			})
			expect(got).toBe('{}') // Not very useful would at least be nice to know there was a function there
		})

		test('should serialise to array with name and number of required parameters', function testJSONFunctionOk() {
			expect(testMe.JSONFunction(fnFunc)).toEqual([TYPE, 'fnFunc', 2])
		})

		test('should serialise to array with name and variable parameters', function testJSONFunctionVariable() {
			expect(testMe.JSONFunction(fnFuncVar)).toEqual([
				TYPE,
				'fnFuncVar',
				0,
			])
		})

		test('should serialise to array with anonymous function', function testJSONFunctionAnon() {
			expect(testMe.JSONFunction(() => void 0)).toEqual([TYPE, '', 0])
		})
	})
})
