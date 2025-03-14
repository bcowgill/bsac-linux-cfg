// Global setup to simulate a browser window like environment.
const win : any = {
	closed             : false,
	crossOriginIsolated: false,
	defaultstatus      : "",
	defaultStatus      : "",
	devicePixelRatio   : 1,
	innerHeight        : 768,
	innerWidth         : 1024,
	isSecureContext    : true,
	length             : 0,
	name               : "",
	origin             : "htt\p://localhost",
	originAgentCluster : false,
	outerHeight        : 768,
	outerWidth         : 1024,
	pageXOffset        : 0,
	pageYOffset        : 0,
	screen             : {
		availHeight: 768,
		availLeft  : 0,
		availTop   : 0,
		availWidth : 1024,
		colorDepth : 24,
		height     : 768,
		orientation: {
			angle: 0, // ScreenOrientation
			type : "landscape-primary"
		},
		pixelDepth : 24, // Screen
		width      : 1024
	},
	screenLeft         : 0,
	screenTop          : 0,
	screenX            : 0,
	screenY            : 0,
	scrollX            : 0,
	scrollY            : 0,
	status             : "",
	visualViewport     : {
		height    : 634,
		offsetLeft: 0,
		offsetTop : 0,
		pageLeft  : 0,
		pageTop   : 0,
		scale     : 1, // VisualViewport
		width     : 1204
	}
};

export const NOISY = false;
export const LET_FAIL_TESTS = false;
export const UTF_OK = false;

const global = win;

function mockDocument(inner = '') : Document
{
	// regex matches <a ...> </a> <hr/> <hr />
	const text = inner.replace(/<\/?\w+[^>]*\/?>/g, ' ');
	const document = {
		body: {
			attributes: [],
			innerHTML : inner,
			innerText : text,
			outerHTML : `<body>${inner}</body>`,
			outerText : text,
			tagName   : 'body'
		}
	};
	// console.warn(`doc`, document);
	return document as unknown as Document;
} // mockDocument()

// Simulate the node/jenkins/jest testing environment.
export const process = {
	env: {
		JENKINS_HOME: '/home/me',
		TRACE       : Math.random() < 0.25
	}
};
export const describe = () => {};
describe.skip = () => {};
export const test = () => {};
test.skip = () => {};

interface Jfnvoid extends Function
{
	fnuid?: number;
	getMockName?: () => string;
};

export const jest : any = {};
jest.fn = function jestMockFn(fn : Jfnvoid = () => {}) : Jfnvoid
{
	fn.getMockName = () => 'jest.fn.MOCKNAME';
	return fn;
}
jest.useFakeTimers = function jestUseFakeTimers() : typeof jest
{
	return jest;
}
jest.setSystemTime = function jestSetSystemTime(_unused : Date) : typeof jest
{
	return jest;
}

export const uev : any = {};

// react-testing-library screen mock
function mockScreen() {
	const screen = {
		queryAllByAltText        : () => [],
		queryAllByDisplayValue   : () => [],
		queryAllByLabelText      : () => [],
		queryAllByPlaceholderText: () => [],
		queryAllByRole           : () => [],
		queryAllByTestId         : () => [],
		queryAllByText           : () => [],
		queryAllByTitle          : () => []
	};
	return screen;
} // mockScreen()
let screen = mockScreen();

//console.warn('this', win) Define types needed
interface Map
{
	entries : () => [
		[any, any]
	];
}
interface WeakMap
{
	entries : () => [
		[any, any]
	];
}
interface Set
{
	keys : () => any[];
}
interface WeakSet
{
	keys : () => any[];
}
namespace React
{
	export type ReactElement = any;
	export type ReactNode = any;
	export type Dispatch < T >           = (value : T) => void;
	export type SetStateAction < T > = (value : T) => void;
}
export type ReactElement = any;
export type ReactNode = any;

// A minimal unit testing library inside the tscompiler browser

let EX_SHOW_SPACES = false;
let EX_AS_JS = false;
function show(what : string) {
	if (EX_AS_JS) {
		return what
			.replace(/\n/g, '\\n')
			.replace(/`/g, '\`')
			.replace(/^(.*)$/, '`$1`');
	}
	return !EX_SHOW_SPACES
		? what
		: what
			.replace(/\n/g, '\\n')
			.replace(/\t/g, '\\t')
			.replace(/\f/g, '\\f')
			.replace(/\r/g, '\\r')
			.replace(/\v/g, '\\v')
			.replace(/\x0d/g, '\\x0d')
			.replace(/\x0a/g, '\\x0a')
			.replace(/\s/g, '~');
} // show()

function sameNaN(got : any, expected : any) : boolean
{
	if (typeof got === 'number' && typeof expected === 'number') {
		if (isNaN(got) && isNaN(expected)) {
			return true;
		}
	}
	return false;
} // sameNaN()

const EX_QUIET = true;
let EX_TESTED = 0;
let EX_FAILED = 0;

function expectToBe(got : any, expected : any, desc = 'expectToBe') : void
{
	// return expect(got).toBe(expected);
	EX_TESTED++;
	if (got === expected || sameNaN(got, expected)) {
		if (!EX_QUIET) {
			console.warn(`OK ${desc}`);
		}
	} else {
		EX_FAILED++;
		console.warn(`NOT OK ${desc}`);
		console.warn(`# expected:`, show(expected));
		console.warn(`#      got:`, show(got));
	}
} // expectToBe()

function expectNotToBe(got : any, expected : any, desc = 'expectNotToBe') : void
{
	// return expect(got).not.toBe(expected);
	EX_TESTED++;
	if (got !== expected && !sameNaN(got, expected)) {
		if (!EX_QUIET) {
			console.warn(`OK ${desc}`);
		}
	} else {
		EX_FAILED++;
		console.warn(`NOT OK ${desc}`);
		console.warn(`# expected different:`, got);
	}
} // expectNotToBe()

function strJ(thing : any) {
	return JSON.stringify(thing, void 0, 2);
}

function expectToEqual(got : any, expected : any, desc = 'expectToEqual') : void
{
	// return expect(got).toEqual(expected);
	EX_TESTED++;
	const gotStr = strJ(got);
	const expectStr = strJ(expected);
	if (gotStr === expectStr) {
		if (!EX_QUIET) {
			console.warn(`OK ${desc}`);
		}
	} else {
		EX_FAILED++;
		console.warn(`NOT OK ${desc}`);
		console.warn(`# expected:`, expected);
		console.warn(`#      got:`, got);
	}
} // expectToEqual()

function expectToMatch(re : RegExp, text : string, desc = 'expectToMatch', times = 1, matchArray?: any) : void
{
	// return expect(text).toMatch(re);
	EX_TESTED++;
	const gotMatches = text.match(re);
	const matches = (gotMatches || []).length;
	const got = strJ(gotMatches);
	const expected = strJ(matchArray);
	let failed = true;

	if (matches === times) {
		if (matchArray) {
			if (got === expected) {
				failed = false;
			}
		} else {
			failed = false;
		}
		if (!failed && !EX_QUIET) {
			console.warn(`OK ${desc} matches: ${times}`);
			console.warn(`#    the regex:`, re);
			console.warn(`# matched text: [${text}]`);
			if (matchArray) {
				console.warn(`#  match array:`, gotMatches);
			}
		}
	} // if matches === times
	if (failed) {
		EX_FAILED++;
		console.warn(`NOT OK ${desc}`);
		console.warn(`#            the regex:`, re);
		console.warn(`#   did not match text: [${text}]`);
		console.warn(`#     expected matches:`, times);
		console.warn(`#          got matches:`, matches, gotMatches);
		if (matchArray) {
			console.warn(`# expected match array:`, matchArray.length, expected);
			console.warn(`  index: ${matchArray.index},`);
			console.warn(`  input: '${matchArray.input}',`);
			console.warn(`  groups: ${matchArray.groups},`);
		} // if matchArray
	} // if failed
} // expectToMatch()

function expectNotToMatch(re : RegExp, text : string, desc = 'expectNotToMatch', times = 0) : void
{
	// return expect(text).not.toMatch(re);
	EX_TESTED++;
	const matches = (text.match(re) || []).length;
	if (matches === times) {
		if (!EX_QUIET) {
			console.warn(`OK ${desc} matches: ${times}`);
			console.warn(`#          the regex:`, re);
			console.warn(`# did not match text: [${text}]`);
		}
	} else {
		EX_FAILED++;
		console.warn(`NOT OK ${desc}`);
		console.warn(`#        the regex:`, re);
		console.warn(`#     matched text: [${text}]`);
		console.warn(`# expected matches:`, times);
		console.warn(`#      got matches:`, matches, text.match(re));
	}
} // expectNotToMatch()

function expectToReplace(re : RegExp, text : string, expected : string, desc = 'expectToReplace', pattern = '1:[$1] 2:[$2] 3:[$3]') : void
{
	expectToBe(text.replace(re, pattern), expected, desc);
} // expectToReplace()

function expectToSplit(re : RegExp, text : string, expected : string[], desc = 'expectToSplit') : void
{
	// return expect(text.split(re)).toEqual(expected);
	const gotSplit = text.split(re);
	const got = strJ(gotSplit);
	const split = strJ(expected);
	EX_TESTED++;
	if (got === split) {
		if (!EX_QUIET) {
			console.warn(`OK ${desc}`);
			console.warn(`#      the regex:`, re);
			console.warn(`# splil the text: [${text}]`);
		}
	} else {
		EX_FAILED++;
		console.warn(`NOT OK ${desc}`);
		console.warn(`#     the regex:`, re);
		console.warn(`# did not split: [${text}]`);
		console.warn(`#      expected:`, split);
		console.warn(`#           got:`, got);
	}
} // expectToSplit()

function testSummary() : void
{
	// return
	const passed = EX_TESTED - EX_FAILED;
	if (EX_FAILED) {
		console.warn(`${EX_FAILED} failed, ${passed} passed, ${EX_TESTED} total`)
	} else {
		console.warn(`All passed, ${EX_TESTED} total`)
	}
} // testSummary()

function expect(got : any) {
	return {
		not            : {
			toBe           : (expected : any) => {
				expectNotToBe(got, expected, `expect(${got}).not.toBe(${expected})`);
			},
			toHaveAttribute: (name : string) => {
				const attr = got
					.attributes
					.find((attr : any) => {
						return attr.name === name;
					});
				if (attr) {
					expectToBe(attr.value === undefined
						? 'not present'
						: undefined, attr.value, `expect(${got}).not.toHaveAttribute(${name}) -- attribute ${name} exists`);
				} else {
					expectToBe(undefined, undefined, `expect(${got}).not.toHaveAttribute(${name})`);
				}
			}, // .not.toHaveAttribute()
			toMatch        : (expected : any) => {
				expectNotToMatch(expected, got, `expect(${got}).not.toMatch(${expected})`);
			}
		}, // .not.
		toBe           : (expected : any) => {
			expectToBe(got, expected, `expect(${got}).toBe(${expected})`);
		},
		toHaveAttribute: (name : string, value : string) => {
			const attr = got
				.attributes
				.find((attr : any) => {
					return attr.name === name;
				});
			if (attr) {
				expectToBe(attr.value, value, `expect(${got}).toHaveAttribute(${name}, '${value})'`);
			} else {
				expectToBe(undefined, value, `expect(${got}).toHaveAttribute(${name}, '${value}') -- attribute ${name} does not exist`);
			}
		}, // .toHaveAttribute()
		toMatch        : (expected : any) => {
			expectToMatch(expected, got, `expect(${got}).toMatch(${expected})`);
		}
	}; // return
} // expect()
