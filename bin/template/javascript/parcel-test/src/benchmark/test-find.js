// The data set to test against, shoule be representative of what the function really sees
// in the correct distribution
const Data = [
	'',
	'o',
	'ao',
	'aao',
	'aaao',
	'iaaao',
	'iiaaao',
	'iiiaaao',
	'iiiiaaao',
	'iiiiiaaao',
	'iiiiiiaaao',
	'Hello World!',
]

// Each test function should operate on the data set in sequence
function makeDataSetTest(fn) {
	let idx = -1
	const length = Data.length
	return function findProgressive() {
		++idx
		return fn(Data[idx % length])
	}
}

const Tests = {
	//'Baseline': makeDataSetTest(function NoopTest () {}),
	'RegExp#test': makeDataSetTest(function RegExpTest(string) {
		;/o/.test(string)
	}),
	'String#indexOf': makeDataSetTest(function StringIndexOfTest(string) {
		string.indexOf('o') > -1
	}),
	'String#match': makeDataSetTest(function StringMatchTest(string) {
		!!string.match(/o/)
	}),
}

export default Tests
