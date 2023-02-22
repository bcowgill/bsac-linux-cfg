import { describe, expect, test } from '@jest/globals'
import testMe from '../TemplateFile'

const displayName = 'TemplateFunction'

describe(`${displayName}() module tests`, function descTemplateNameSuite() {
	test('should supply default parameters', function testTemplateNameDefault() {
		expect(testMe()).toBe({})
	})
})
