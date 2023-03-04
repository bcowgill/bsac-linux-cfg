import { describe, expect, test } from '@jest/globals'
import * as testMe from '../errors'

const displayName = 'errors'

describe(`${displayName} module tests`, function descErrorsSuite() {
	const CONTEXT = 'CONTEXT: Caught Error: '
	const regexDate = '[-+:()\\sa-z0-9]+'

	describe('limitLength()', function descErrorsLimitLengthSuite() {
		test('should limit the length and show ellipsis […] to [2345678…]', function testErrorsLimitLength() {
			const info = '[23456789]'

			expect(testMe.limitLength(info, -1)).toHaveLength(info.length)

			expect(testMe.limitLength(info, 1)).toBe('[…]')
			expect(testMe.limitLength(info, 1)).toHaveLength(3)

			expect(testMe.limitLength(info, 1, '...')).toBe('[...]')
			expect(testMe.limitLength(info, 1, '...')).toHaveLength(5)

			expect(testMe.limitLength(info)).toHaveLength(info.length)
			expect(testMe.limitLength(info, 1)).toBe('[…]')
			expect(testMe.limitLength(info, 1)).toHaveLength(3)

			expect(testMe.limitLength(info, 2)).toHaveLength(3)
			expect(testMe.limitLength(info, 2)).toBe('[…]')

			expect(testMe.limitLength(info, 3)).toHaveLength(4)
			expect(testMe.limitLength(info, 3)).toBe('[2…]')

			expect(testMe.limitLength(info, 8)).toHaveLength(info.length - 1)
			expect(testMe.limitLength(info, 8)).toBe('[234567…]')

			expect(testMe.limitLength(info, 9)).toHaveLength(info.length)
			expect(testMe.limitLength(info, 9)).toBe('[2345678…]')

			expect(testMe.limitLength(info, 10)).toHaveLength(info.length)
			expect(testMe.limitLength(info, 10)).toBe('[23456789]')

			expect(testMe.limitLength(info, 11)).toHaveLength(info.length)
			expect(testMe.limitLength(info, 11)).toBe('[23456789]')

			expect(testMe.limitLength(info, 12)).toHaveLength(info.length)
			expect(testMe.limitLength(info, 12)).toBe('[23456789]')
		})
	}) // limitLength()

	describe('objectToString()', function descErrorsObjectToStringSuite() {
		test('should handle null', function testErrorObjectToStringNull() {
			expect(testMe.objectToString(null)).toBe('null')
		})

		test('should handle RegExp', function testErrorObjectToStringRegExp() {
			expect(testMe.objectToString(/^this is the regex$/gi)).toBe(
				'/^this is the regex$/gi',
			)
		})

		test('should handle Date', function testErrorObjectToStringDate() {
			expect(testMe.objectToString(new Date(123412443))).toMatch(
				new RegExp(`^${regexDate}$`, 'i'),
			)
		})

		test('should handle an object which JSON.stringify cannot handle', function testErrorObjectToStringError() {
			const throwError: Record<string, string | bigint | object> = {
				name: 'throwError',
				tooBig: BigInt(98570985),
				myself: {},
			}
			throwError.myself = throwError
			expect(testMe.objectToString(throwError)).toMatch(
				/^\[object Object\] error with stringify! TypeError: Do not know how to serialize a BigInt/,
				// /^\[object Object\] error with stringify! TypeError: Converting circular/,
			)
		}) // JSON.stringify error

		test('should handle an Array with length limit', function testErrorObjectToStringArrayLimit() {
			const list = [1, 2, 3, 4, 'longer and longer']
			expect(testMe.objectToString(list)).toBe(
				'[1,2,3,4,longer and longer]',
			)

			const LIMIT = 12
			const short = testMe.objectToString(list, LIMIT)
			expect(short).toHaveLength(LIMIT + 1)
			expect(short).toBe('[1,2,3,4,lo…]')
		}) // Array

		test('should handle an HTMLInputElement with length limit', function testErrorObjectToStringHTMLElementLimit() {
			const element = document.createElement('input')
			element.id = 'ID'
			element.name = 'NAME'
			element.type = 'password'
			element.tabIndex = -1
			element.className = 'CLASSNAME'
			element.title = 'TITLE'
			element.value = 'VALUE'
			element.defaultValue = 'DVALUE'
			element.required = true
			element.autofocus = true
			element.hidden = true
			element.disabled = true
			element.readOnly = true
			element.ariaRoleDescription = 'ARIADESC'

			expect(testMe.objectToString(element)).toBe(
				'{"tagName":"INPUT","localName":"input","id":"ID","name":"NAME","type":"password","tabIndex":-1,"className":"CLASSNAME","title":"TITLE","ariaRoleDescription":"ARIADESC","value":"VALUE","defaultValue":"DVALUE","checked":false,"indeterminate":false,"defaultChecked":false,"required":true,"hidden":true,"disabled":true,"readOnly":true,"autofocus":true,"size":20,"minLength":0,"maxLength":524288}',
			)

			const LIMIT = 390
			const short = testMe.objectToString(element, LIMIT)
			expect(short).toHaveLength(LIMIT + 1)
			expect(short).toBe(
				'{"tagName":"INPUT","localName":"input","id":"ID","name":"NAME","type":"password","tabIndex":-1,"className":"CLASSNAME","title":"TITLE","ariaRoleDescription":"ARIADESC","value":"VALUE","defaultValue":"DVALUE","checked":false,"indeterminate":false,"defaultChecked":false,"required":true,"hidden":true,"disabled":true,"readOnly":true,"autofocus":true,"size":20,"minLength":0,"maxLength":52428…}',
			)
		}) // HTMLInputElement
	}) // objectToString()

	describe('toErrorString()', function descErrorsToErrorStringSuite() {
		test('should convert abnormal values to string', function testErrorsToStringAbnormal() {
			expect(testMe.toErrorString(CONTEXT)).toBe(`${CONTEXT}undefined`)
			expect(testMe.toErrorString(CONTEXT, null)).toBe(`${CONTEXT}null`)
			expect(testMe.toErrorString(CONTEXT, NaN)).toBe(
				`${CONTEXT}(number)NaN`,
			)
			expect(testMe.toErrorString(CONTEXT, Infinity)).toBe(
				`${CONTEXT}(number)Infinity`,
			)
			expect(testMe.toErrorString(CONTEXT, -Infinity)).toBe(
				`${CONTEXT}(number)-Infinity`,
			)
			expect(testMe.toErrorString(CONTEXT, new Number(NaN))).toBe(
				`${CONTEXT}(object:Number)NaN`,
			)
			expect(testMe.toErrorString(CONTEXT, new Number(Infinity))).toBe(
				`${CONTEXT}(object:Number)Infinity`,
			)
			expect(testMe.toErrorString(CONTEXT, new Number(-Infinity))).toBe(
				`${CONTEXT}(object:Number)-Infinity`,
			)
			expect(testMe.toErrorString(CONTEXT, '')).toBe(
				`${CONTEXT}(string)<empty string>`,
			)
			expect(testMe.toErrorString(CONTEXT, new String(''))).toBe(
				`${CONTEXT}(object:String)<empty string>`,
			)

			expect(testMe.toErrorString(CONTEXT, '          ')).toBe(
				`${CONTEXT}(string)<          >`,
			)
			expect(
				testMe.toErrorString(CONTEXT, new String('          ')),
			).toBe(`${CONTEXT}(object:String)<          >`)
			expect(testMe.toErrorString(CONTEXT, '    weird      ')).toBe(
				`${CONTEXT}(string)<    weird      >`,
			)

			expect(
				testMe.toErrorString(CONTEXT, new String('    weird      ')),
			).toBe(`${CONTEXT}(object:String)<    weird      >`)
		}) // abnormal values

		test('should convert other primitives to string', function testErrorsToStringPrimitive() {
			expect(testMe.toErrorString(CONTEXT, true)).toBe(
				`${CONTEXT}(boolean)true`,
			)
			expect(testMe.toErrorString(CONTEXT, false)).toBe(
				`${CONTEXT}(boolean)false`,
			)
			expect(testMe.toErrorString(CONTEXT, new Boolean(false))).toBe(
				`${CONTEXT}(object:Boolean)false`,
			)
			expect(testMe.toErrorString(CONTEXT, -3245)).toBe(
				`${CONTEXT}(number)-3245`,
			)
			expect(testMe.toErrorString(CONTEXT, new Number(-3245))).toBe(
				`${CONTEXT}(object:Number)-3245`,
			)
			expect(testMe.toErrorString(CONTEXT, BigInt(-3245))).toBe(
				`${CONTEXT}(bigint)-3245`,
			)
			expect(testMe.toErrorString(CONTEXT, 'normal creation')).toBe(
				`${CONTEXT}(string)normal creation`,
			)
			expect(
				testMe.toErrorString(CONTEXT, new String('weird creation')),
			).toBe(`${CONTEXT}(object:String)weird creation`)
			expect(testMe.toErrorString(CONTEXT, /^REGEX$/gi)).toBe(
				`${CONTEXT}(object:RegExp)/^REGEX$/gi`,
			)
			expect(
				testMe.toErrorString(
					CONTEXT,
					'limit the length of the string',
					20,
					'...',
				),
			).toBe(`${CONTEXT}(string)limit the length of...g`)
		}) // other primitives

		test('should convert other objects to string', function testErrorsToStringObjects() {
			expect(testMe.toErrorString(CONTEXT, /^REGEX$/gi)).toBe(
				`${CONTEXT}(object:RegExp)/^REGEX$/gi`,
			)
			expect(testMe.toErrorString(CONTEXT, new Date())).toMatch(
				new RegExp(`^${CONTEXT}\\(object:Date\\)${regexDate}$`, 'i'),
			)
			expect(
				testMe.toErrorString(CONTEXT, new TypeError('TYPE_ERROR')),
			).toBe(`${CONTEXT}(object:TypeError)TypeError: TYPE_ERROR`)
			expect(testMe.toErrorString(CONTEXT, [0, 1, 2, 'what'])).toBe(
				`${CONTEXT}(object:Array)[0,1,2,what]`,
			)
			expect(testMe.toErrorString(CONTEXT, global)).toMatch(
				new RegExp(`^${CONTEXT}\\(object:Window\\){.+http://.+}$`),
			)
			expect(testMe.toErrorString(CONTEXT, window)).toMatch(
				new RegExp(`^${CONTEXT}\\(object:Window\\){.+http://.+}$`),
			)
			expect(testMe.toErrorString(CONTEXT, document)).toBe(
				`${CONTEXT}(object:Document){}`,
			)
			expect(
				testMe.toErrorString(CONTEXT, document.documentElement),
			).toBe(
				`${CONTEXT}(object:HTMLHtmlElement){"tagName":"HTML","localName":"html","tabIndex":-1,"hidden":false}`,
			)
			expect(
				testMe.toErrorString(CONTEXT, {
					0: 'rty',
					what: 1,
					true: 2,
					why: false,
				}),
			).toBe(
				`${CONTEXT}(object){"0":"rty","what":1,"true":2,"why":false}`,
			)
		}) // other objects

		test('should be no eslint/typescript issues with catch(exception) being logged as string', function testErrorsToStringCatch() {
			try {
				expect('ok').toBe('ok')
			} catch (exception: unknown) {
				// Without the toErrorString() would give Invalid type "unknown" of template literal expression      @typescript-eslint/restrict-template-expressions
				// eslint-disable-next-line no-console
				console.error(testMe.toErrorString(`Exception: `, exception))
			}
		}) // other primitives
	}) // toErrorString()

	describe('throwAsError()', function descErrorsThrowAsErrorSuite() {
		test('should return the Error itself for throwing', function testErrorsThrowAsErrorIsError() {
			const error = new TypeError('TYPE_ERROR')
			expect(
				testMe.throwAsError(
					error,
					'UNUSED CONTEXT if already an Error',
				),
			).toBe(error)
		})

		test('should convert non-Error to Error for throw', function testErrorsThrowAsErrorNonError() {
			expect(() => {
				throw testMe.throwAsError(/^REGEX$/gi)
			}).toThrow(Error)
			expect(() => {
				throw testMe.throwAsError(/^REGEX$/gi, CONTEXT)
			}).toThrow(`${CONTEXT}(object:RegExp)/^REGEX$/gi`)
		})
	}) // throwAsError()
})
