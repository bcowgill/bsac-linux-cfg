/* eslint-disable prefer-arrow-callback */

import * as keyboard from './keyboard'

const suite = 'src/components/utils keyboard'

const getKey = keyboard.default

describe(suite, function descKeyboardSuite() {
	describe('getKey', function descKeyboardGetKeySuite() {
		it('should return key name from event', function testKeyboardGetKey() {
			const expected = 'ArrowUp'
			const actual = getKey({ key: 'ArrowUp' })
			expect(actual).toBe(expected)
		})
	}) // getKey()

	describe('getCursorPosition', function descKeyboardGetCursorPositionSuite() {
		it('should set start at start of content', function testKeyboardGetCursorPositionStart() {
			const expected = {
				start: true,
				end: false,
				middle: false,
			}
			const actual = keyboard.getCursorPosition({
				selectionDirection: 'forward',
				selectionStart: 0,
				selectionEnd: 0,
				value: '231',
			})
			expect(actual).toEqual(expected)
		})
		it('should set end at end of content', function testKeyboardGetCursorPositionEnd() {
			const expected = {
				start: false,
				end: true,
				middle: false,
			}
			const actual = keyboard.getCursorPosition({
				selectionDirection: 'forward',
				selectionStart: 0,
				selectionEnd: 3,
				value: '@@@',
			})
			expect(actual).toEqual(expected)
		})
		it('should set middle when within content', function testKeyboardGetCursorPositionMiddle() {
			const expected = {
				start: false,
				end: false,
				middle: true,
			}
			const actual = keyboard.getCursorPosition({
				selectionDirection: 'forward',
				selectionStart: 0,
				selectionEnd: 1,
				value: '\\o/',
			})
			expect(actual).toEqual(expected)
		})
		it('should set middle when within content with backward select direction', function testKeyboardGetCursorPositionMiddleReverse() {
			const expected = {
				start: false,
				end: false,
				middle: true,
			}
			const actual = keyboard.getCursorPosition({
				selectionDirection: 'backward',
				selectionStart: 1,
				selectionEnd: 2,
				value: '[o]',
			})
			expect(actual).toEqual(expected)
		})
		it('should set start and end when no content', function testKeyboardGetCursorPositionEmpty() {
			const expected = {
				start: true,
				end: true,
				middle: false,
			}
			const actual = keyboard.getCursorPosition({
				selectionDirection: 'forward',
				selectionStart: 0,
				selectionEnd: 0,
				value: '',
			})
			expect(actual).toEqual(expected)
		})
	}) // getCursorPosition()
})
