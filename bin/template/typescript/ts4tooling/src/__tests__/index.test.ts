import { describe, expect, test } from '@jest/globals'
import * as testMe from '../common'
import '../index'

const displayName = 'common'

describe(`${displayName} module tests`, function descCommonSuite() {
	test('should export things', function testCommonExports() {
		expect(testMe.A).toBe('foo')
		expect(testMe.B).toBe('bar')
	})
})
