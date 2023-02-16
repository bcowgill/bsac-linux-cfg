import { strict as assert } from 'assert'
import * as TestMe from '../pii.ts'

const DEBUG = false
const longer = 4

let suite = 'pii module tests'
log(suite)
let testCase

function log(message: string) {
	if (DEBUG) console.log(message)
}

testCase = '\tobscurePassword()'
log(testCase)

try {
	const password = 'pa6sword i$ obscuRed fu11y'
	let result = TestMe.obscurePassword(password)
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

	testCase = '\tobscureNumber()'
	log(testCase)

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

	testCase = '\tobscureWord()'
	log(testCase)

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

	testCase = '\tobscureInfo()'
	log(testCase)

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
} catch (testFailure) {
	log(suite)
	log(testCase)

	if (testFailure.name === 'AssertionError') {
		console.error(`${testFailure.code}: ${testFailure.operator}`)
		console.error('got     :', testFailure.actual)
		console.error('expected:', testFailure.expected)
	}
	console.error(testFailure)
}
