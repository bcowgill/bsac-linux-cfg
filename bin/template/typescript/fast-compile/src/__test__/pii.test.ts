import { strict as assert } from 'assert'
import * as TestMe from '../pii.ts'
import { suite, describe, log } from './lib.ts'

suite('pii module tests', function descPIISuite() {
	let DEBUG = false
	const longer = 4
	const password = 'pa6sword i$ obscuRed fu11y'

	describe('obscurePassword()', function descObscurePassword() {
		const result = TestMe.obscurePassword(password)
		log(
			`\t\tpw:[${password}] ${
				result.length - password.length
			} res:[${result}]`,
		)

		assert(
			result.length >= password.length,
			'obscured is same or longer in length',
		)
		assert(
			result.length <= password.length + longer,
			`obscured is at most ${longer} chars longer than password`,
		)
		assert.match(result, /^\*+$/, 'password string is fully obscured')
	}) // obscurePassword

	describe('obscureNumber()', function descObscureNumber() {
		function testObscureNumber(number, expect, message) {
			const actual = TestMe.obscureNumber(number)
			log(`\t\tnum:[${number}] actual:[${actual}]`)
			assert.equal(actual, expect, message)
		}

		testObscureNumber(4, '1', 'short numbers 1 are changed')
		testObscureNumber('58', '11', 'short numbers 2 are changed')
		testObscureNumber(436, '406', 'short numbers 3 are changed')
		testObscureNumber('5897', '5007', 'short numbers 4 are changed')
		testObscureNumber('89374', '80004', 'long numbers are changed')
		testObscureNumber('4352346', '4000006', 'long numbers are changed')
	}) // obscureNumber

	describe('obscureWord()', function descObscureWord() {
		function testObscureWord(word, expect, message) {
			const actual = TestMe.obscureWord(word)
			log(`\t\tword:[${word}] actual:[${actual}]`)
			assert.equal(actual, expect, message)
		}

		testObscureWord('a', '*', 'short words 1 fully obscured')
		testObscureWord('ab', '**', 'short words 2 fully obscured')
		testObscureWord('abc', '***', 'short words 3 fully obscured')
		testObscureWord('abcd', '****', 'short words 4 fully obscured')
		testObscureWord('abcde', 'a***e', 'long words are partially obscured')
		testObscureWord('4', '1', 'short numbers 1 are changed')
		testObscureWord('58', '11', 'short numbers 2 are changed')
		testObscureWord('436', '406', 'short numbers 3 are changed')
		testObscureWord('5897', '5007', 'short numbers 4 are changed')
		testObscureWord('89374', '80004', 'long numbers are changed')
		testObscureWord('4352346', '4000006', 'long numbers are changed')
	}) // obscureWord

	describe('obscureInfo()', function descObscureInfo() {
		function testObscureInfo(info, expect, message) {
			const actual = TestMe.obscureInfo(info)
			log(`\t\tinfo:[${info}] actual:[${actual}]`)
			assert.equal(actual, expect, message)
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

	describe('JSON.stringify() with replacer', function descObscureInfo() {
		const features = new Set()
		features.add('edit').add('delete')
		const data = {
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
			features,
		}

		function typeOf(source): string {
			const type =
				source !== null && typeof source !== 'undefined'
					? source.constructor.name
					: typeof source
			return type
		}

		function fnReplacer(keyName: string, original) {
			const source = this[keyName]
			let value = original
			const type = typeOf(source)
			const key = keyName.replace(/[^a-z0-9]/gi, '')

			if (DEBUG || keyName === 'list') {
				DEBUG = true
				// eslint-disable-next-line no-console
				console.warn(
					`fnReplacer key[${keyName}]->[${key}] ${type}->${typeOf(
						value,
					)}\nthis:`,
					this,
					'\nvalue<',
					value,
					'>',
				)
			}

			if (key === '') {
				return value
			}

			if (type === 'Set') {
				const SET_LIMIT = 2 // limit the number of items in the set in case there are very many...
				const set = []
				for (const item of original.keys()) {
					set.push(item)
					if (set.length >= SET_LIMIT) {
						set.push('…')
						break
					}
				}
				value = set
			}

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

			// All other keys are passed through as they are
			return value
		}

		const publicKeys = 'id name address'.split(/ /g)

		assert.deepEqual(
			JSON.parse(JSON.stringify(data, publicKeys)),
			{
				id: 234134,
				name: 'Frankie Hollywood',
				address: '123 Shinging Crescent, Anyville, Wyoming, 23123',
			},
			'stringify with PII obscured',
		)

		const result = JSON.parse(JSON.stringify(data, fnReplacer))
		assert.match(
			result.system.password,
			/^\*+$/,
			'password has been fully obscured',
		)
		result.system.password = '*****'
		assert.deepEqual(
			result,
			{
				id: 234134,
				system: { password: '*****', isEnrolled: true },
				name: 'F*****e H*******d',
				birthDate: '2003-11-1***7:11:11.****',
				age: 45,
				height: 6.5,
				weight: 76,
				job: 'Janitor',
				address: '103 S******g C******t, A******e, W*****g, 20003',
				financials: {
					sort_Code: '11-11-11',
					accountNo: '700000002',
					cardNo: '100000000004',
				},
				boolNullable: null,
				productNullable: 'Gizmos',
				ssnPII: '700000005',
			},
			'stringify with PII obscured',
		)
	}) // JSON.stringify(..., replacer)
}) // pii module tests
