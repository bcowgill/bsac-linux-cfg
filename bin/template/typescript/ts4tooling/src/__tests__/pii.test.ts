import { describe, expect, test } from '@jest/globals'
import * as TestMe from '../pii'

describe('pii module tests', function descPIISuite() {
	const LONGER = 4
	const password = 'pa6sword i$ obscuRed fu11y'

	test('obscurePassword()', function testObscurePassword() {
		const result = TestMe.obscurePassword(password)

		expect(result.length).toBeGreaterThanOrEqual(password.length)
		expect(result.length).toBeLessThanOrEqual(password.length + LONGER)
		expect(result).toMatch(/^\*+$/)

		// Call a few more times so random branches gets covered
		TestMe.obscurePassword(password)
		TestMe.obscurePassword(password)
		TestMe.obscurePassword(password)
		TestMe.obscurePassword(password)
		TestMe.obscurePassword(password)
		TestMe.obscurePassword(password)
		TestMe.obscurePassword(password)
		TestMe.obscurePassword(password)
	}) // obscurePassword

	test('obscureNumber()', function testObscureNumber() {
		function testObscureNumber(
			number: number | string,
			expected: string,
			detail: string,
		): void {
			const actual = TestMe.obscureNumber(number)
			expect(actual).toBe(
				actual !== expected ? `${expected} - ${detail}` : expected,
			)
		}

		testObscureNumber(4, '1', 'short numbers length 1 are changed')
		testObscureNumber('58', '11', 'short numbers length 2 are changed')
		testObscureNumber(436, '406', 'short numbers length 3 are changed')
		testObscureNumber('5897', '5007', 'short numbers length 4 are changed')
		testObscureNumber('89374', '80004', 'long numbers are changed')
		testObscureNumber('4352346', '4000006', 'long numbers are changed')
	}) // obscureNumber

	test('obscureWord()', function testObscureWord() {
		function testObscureWord(
			word: string,
			expected: string,
			detail: string,
		) {
			const actual = TestMe.obscureWord(word)
			expect(actual).toBe(
				actual !== expected ? `${expected} - ${detail}` : expected,
			)
		}

		testObscureWord('a', '*', 'short words length 1 fully obscured')
		testObscureWord('ab', '**', 'short words length 2 fully obscured')
		testObscureWord('abc', '***', 'short words length 3 fully obscured')
		testObscureWord('abcd', '****', 'short words length 4 fully obscured')
		testObscureWord('abcde', 'a***e', 'long words are partially obscured')
		testObscureWord('4', '1', 'short numbers length 1 are changed')
		testObscureWord('58', '11', 'short numbers length 2 are changed')
		testObscureWord('436', '406', 'short numbers length 3 are changed')
		testObscureWord('5897', '5007', 'short numbers length 4 are changed')
		testObscureWord('89374', '80004', 'long numbers are changed')
		testObscureWord('4352346', '4000006', 'long numbers are changed')
	}) // obscureWord

	test('obscureInfo()', function testObscureInfo() {
		function testObscureInfo(
			info: string,
			expected: string,
			detail: string,
		) {
			const actual = TestMe.obscureInfo(info)
			expect(actual).toBe(
				actual !== expected ? `${expected} - ${detail}` : expected,
			)
		}

		testObscureInfo(
			password,
			'p******d *$ o******d f***y',
			'password partially obscured',
		)
		testObscureInfo(
			'this is some private information to obscure',
			'**** ** **** p*****e i*********n ** o*****e',
			'long and short words obscured properly',
		)

		testObscureInfo(
			'58008 mixtures of, words! $3,123,434.00 numbers 12-34-56 234321435 and "punctuation" obscured correctly',
			'50008 m******s **, w***s! $1,103,404.11 n*****s 11-11-11 200000005 *** "p*********n" o******d c*******y',
			'long and short words and numbers obscured properly',
		)
		testObscureInfo(
			'c7bc3308-ae20-11ed-afa1-0242ac120002',
			'c******8-****-****-****-0**********2',
			'uuid v1 obscured properly',
		)

		testObscureInfo(
			'000003e8-ae27-21ed-8a00-325096b39f47',
			'0******8-****-****-****-3**********7',
			'uuid v2 obscured properly',
		)

		testObscureInfo(
			'8e25c082-3dd7-4199-b080-cfd0c0fcc727',
			'8******2-****-4009-****-c**********7',
			'uuid v4 obscured properly',
		)
	}) // obscureInfo

	test('JSON.stringify() with replacer', function testObscureInfo() {
		type stuff = number | string

		interface Data {
			id: number
			system?: {
				password: string
				isEnrolled: boolean
			}
			name: string
			birthDate?: Date
			age?: number
			height?: number
			weight?: number
			job?: string
			address: string
			financials?: {
				sort_Code: string
				accountNo: string
				cardNo: string
			}
			removeThis?: string
			boolNullable?: boolean | null
			productNullable?: string | null
			ssnPII?: string
			list?: stuff[]
		}

		const data: Data = {
			id: 234134,
			system: {
				password:
					'the password is a real secret and should not be shared',
				isEnrolled: true,
			},
			name: 'Frankie Hollywood',
			birthDate: new Date(
				new Date('2023-02-18 07:29:31').valueOf() - 45 * 365,
			),
			age: 45,
			height: 6.5,
			weight: 76,
			job: 'Janitor',
			address: '123 Shinging Crescent, Anyville, Wyoming, 23123',
			financials: {
				sort_Code: '99-23-12',
				accountNo: '739432912',
				cardNo: '127409231234',
			},
			removeThis: 'should not appear in stringified output at all',
			boolNullable: false,
			productNullable: 'Gizmos',
			ssnPII: '734942145',
			list: [1, 2, 34, 'what'],
		} // data

		function fnReplacer(
			this: object,
			keyName: string,
			value: unknown,
		): unknown {
			if (keyName === '') {
				return value
			}
			const key = keyName.replace(/[^a-z0-9]/gi, '')

			// Keys which should NOT be included in stringified object
			// example only, specific key name
			if (/^removethis$/i.test(key)) {
				return void 0
			}

			// Keys which should become null if they have no truthy value
			// example only, anything ending with nullable (ignoring case)
			if (/nullable$/i.test(key)) {
				return value || null
			}

			if (typeof value === 'string') {
				// Keys which contain passwords to be fully obscured
				// anything with password anywhere within it (ignoring case)
				if (/password/i.test(key)) {
					return TestMe.obscurePassword(value)
				}

				// Keys which contain personally identifiable information and should be partially obscured
				// anything ending with PII (ignoring case)
				// anything with birth in it anywhere
				// and some fully qualified specific field names
				if (
					/pii$/i.test(key) ||
					/birth/i.test(key) ||
					/^(name|address|sortcode|accountno|cardno)$/i.test(key)
				) {
					return TestMe.obscureInfo(value)
				}
			} // string
			// All other keys are passed through as they are
			return value
		} // fnReplacer()

		const publicKeys = 'id name address'.split(/ /g)

		expect(JSON.parse(JSON.stringify(data, publicKeys)) as Data).toEqual({
			id: 234134,
			name: 'Frankie Hollywood',
			address: '123 Shinging Crescent, Anyville, Wyoming, 23123',
		})

		const result = JSON.parse(JSON.stringify(data, fnReplacer)) as Data
		expect(result.system?.password).toMatch(/^\*+$/)
		if (result.system) {
			result.system.password = '*****'
		}
		expect(result).toEqual({
			id: 234134,
			system: { password: '*****', isEnrolled: true },
			name: 'F*****e H*******d',
			birthDate: '2003-11-1***7:11:11.****',
			age: 45,
			height: 6.5,
			weight: 76,
			job: 'Janitor',
			address: '103 S******g C******t, A******e, W*****g, 20003',
			// MUSTDO need to figure out key path ['', financials, sort_Code]
			financials: {
				sort_Code: '11-11-11',
				accountNo: '700000002',
				cardNo: '100000000004',
			},
			boolNullable: null,
			productNullable: 'Gizmos',
			ssnPII: '700000005',
			list: [1, 2, 34, 'what'],
		})
	}) // JSON.stringify(..., replacer)
}) // pii module tests
