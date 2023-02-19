type FnTest = () => void

const DEBUG = process.env.NODE_TEST
	? /^(1|y|t)/i.test(process.env.NODE_TEST)
	: false
const tests: Array<FnTest> = []

let failures = 0
let testSuite = 'no suite'
let testCase = 'no testCase'

export function log(message: string): void {
	if (DEBUG) say(message)
}

export function say(message: string) {
	// eslint-disable-next-line no-console
	console.log(message)
}

function error(...args) {
	// eslint-disable-next-line no-console
	console.error(...args)
}

export function suite(message: string, fn: FnTest): void {
	tests.push(function runSuite() {
		testSuite = message
		log(testSuite)
		fn()
	})
}

export function describe(message: string, fn: FnTest): void {
	testCase = '\t' + message
	log(testCase)

	try {
		fn()
	} catch (testFailure) {
		say(testSuite)
		say(testCase)

		if (testFailure.name === 'AssertionError') {
			error(`${testFailure.code}: ${testFailure.operator}`)
			error('got     :', testFailure.actual)
			error('expected:', testFailure.expected)
		}
		error(testFailure)
		++failures
	}
}

export function run() {
	tests.forEach(function runSuite(fnSuite) {
		try {
			fnSuite()
		} catch (exception) {
			error(exception)
			++failures
		}
	})
	say(`${failures} failed tests`)
	process.exit(failures)
}
