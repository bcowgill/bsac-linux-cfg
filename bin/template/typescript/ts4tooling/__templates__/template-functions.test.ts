import { describe, expect, test } from '@jest/globals'
import * as testMe from '../TemplateFile'

const displayName = 'TemplateFunction'

describe(`${displayName} module tests`, function descTemplateNameSuite() {
	describe(`function1()`, function descTemplateNameFunction1Suite() {
		test('should supply default parameters', function testTemplateNameFunction1Default() {
			expect(testMe.function1()).toBe({})
		})
	})

	describe(`function2()`, function descTemplateNameFunction2Suite() {
		test('should supply default parameters', function testTemplateNameFunction2Default() {
			expect(testMe.function2()).toBe({})
		})
	})
})
