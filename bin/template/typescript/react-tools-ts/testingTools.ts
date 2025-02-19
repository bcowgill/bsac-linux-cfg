//==========================================================
// testingTools.ts - a collection of tools for testing react applications with jest and @testing-library/react
/* istanbul ignore file */
// @ts-ignore-file
import uev from '@testing-library/user-event';
import React, {ReactNode, ReactElement} from 'react';
import {render, screen} from '@testing-library/react';

/*
	MUSTDO sample test plan in project
	@example test for special characters
	test.only('testingTools', () => {
		document.body.setAttribute('id', 'ID');
		document.body.setAttribute('data-testid', 'TESTID');
		document.body.setAttribute('style', 'color: white;');
		document.body.setAttribute('class', 'CLASS');
		console.warn(`elementInfo`, T.elementInfo(document.body));
		console.warn(`getEl`, T.getEl('div'));
		expect(T.showThing('this is too long', 3)).toBe('\u{201c}thi\u{2026}\u{201d}');
		T.checkUndefined('\x{a3}14.00');
		T.checkUndefined('\x{a3}NaN');
		// Render your component here...
		console.warn('RENDERED', T.getHtmlNice());
		T.checkPageIds();
		T.checkUndefined();
		T.checkDocumentTextEmpty();
		console.warn(`getEl`, T.getEl('div'));
	});
*/

const appId = 'app-name';

export type FNVoid = () => void;
export type KeyMap = Record < string,
unknown >;
export type AliasMap = Record < string,
string >;
export type MessagesMap = Record < string,
string[] >;
export type FlagMap = Record < string,
boolean >;
export type SetStateBoolean = React.Dispatch < React.SetStateAction < boolean >>;
export type SetFlagState = (key : string, value : boolean) => void;

export interface ElementWrapper
{
	children : ReactElement;
}
export interface Wrapper
{
	children : ReactNode;
}

type IElement = Element;
export type IElementMatcher = RegExp | string;
export type IElementLocator = IElement | IElementMatcher | number;
export type IElementList = |HTMLCollectionOf < any > | NodeListOf < any > | HTMLElement[];

export interface ElementWithType
{
	type : string;
	element : IElement;
}

const FLIP = false; // true to reverse which attributes are shown in getTextNice()
const MAX_THING = 128; // longest thing to log before shortening with an ellipsis in showThing()

// checkDocumentTextEmpty() specify hidden text that is present even in an empty document
const reVersionNickname = />\s*version\.nickname: [^<]+</; // NOSONAR

// checkPageIds() specify which non-unique or numbered id values are allowed.
const reAllowId = /^(csl-dialog-desc\d+)$/;

// checkUndefined() specify which HTML attributes are allowed to have true/false values.
const reAttrsBoolean = /\b(focusable|aria-(hidden|modal|invalid|checked|expanded))="(true|false)"/gi;
//const reAttrsBoolean = /\b(value|focusable|aria-(hidden|modal|invalid|checked|expanded)|data-(focus-guard|focus-lock-disabled|autofocus-inside|popper-arrow))="(true|false)"/gi;

// getTextNice() specify which HTML attributes to show.
const reAttrsToShow = /^(id|name|type|role|target|rel|disabled|focusable|hidden|width|height|tabindex|for|title|placeholder|alt|href|(data|aria)-.+)$/i;
// show class and style also, more noisy but may be useful in some cases.
//const reAttrsToShow = /^(class|style|id|name|type|role|target|rel|disabled|focusable|hidden|width|height|tabindex|for|title|placeholder|alt|href|(data|aria)-.+)$/i;

// getElementInfo configure what props/attrs to show when dumping elements
const showAllPropSources = true;
const attrsToShow =
	'data-testid:name:type:role:aria-role:target:rel:disabled:focusable:width:height:hidden:aria-hidden:tabIndex:for:label:aria-label:value:defaultValue:selected:checked:aria-checked:aria-invalid:aria-expanded:title:placeholder:alt:href'.split(
		/:/g
	);

let _LS = 'L'; // £ pound sterling UTF8
let _EL = '_'; // … ellipsis UTF8
let _LDQ = '\\'; // “ left quote (double) UTF8
let _RDQ = '/'; // ” right quote (double) UTF8
let _LRDQ = `\\\\\\/`;
// let _LDQ = '"('; // “ left quote (double) UTF8 let _RDQ = ')"'; // ” right
// quote (double) UTF8
if (UTF_OK) {
	_LS   = '\xa3'; // £ pound sterling UTF8
	_EL   = '\u2026'; // … ellipsis UTF8
	_LDQ  = '\u201c'; // “ left quote (double) UTF8
	_RDQ  = '\u201d'; // ” right quote (double) UTF8
	_LRDQ = `${_LDQ}${_RDQ}`;
}
export const LS = _LS; // £ pound sterling UTF8
export const EL = _EL; // … ellipsis UTF8
export const LDQ = _LDQ; // “ left quote (double) UTF8
export const RDQ = _RDQ; // ” right quote (double) UTF8
const LRDQ = _LRDQ;

const NL = '{NL}';
const TAB = '\t';
const SPC = '[SPACE]';
const reRawHtml = /^\s*<.+>\s*$/m; // NOSONAR
const reDocTextEmpty = /<[^>]+>/g; // NOSONAR
const reElemWithId = /<[^>]+?\s+id="([^"]*)"[^>]*>/gi; // NOSONAR
const reBoolean = /false|true/gi;
const reMissingMoney = new RegExp(`[${LS}\\$][^\\d\\s]`, 'gi'); // /[\xa3$][^\d\s]/gi;
const reStringified = /undefined|null|\bNaN\b|Infinity|\[object Object\]|function /gi;

// Match element indexing and going up the parent tree: [+/-NNN]^^^@LIST
const reIndexUp = /\s*(?:\[([+-]?\d+)\])?\s*(\^*)\s*(@LIST)?\s*$/i; // NOSONAR

// <h/> cuddle up the spaces in singular elements
const reExtraSpacesClosureElem = /\s+\/>/; // NOSONAR

const reOuterSpaces = /^(\s*)(.*?)(\s*)$/gm; // NOSONAR
const reSplitAfterElement = />([^<]*)$/g; // NOSONAR
const reSplitBeforeElement = /^([^<]*)</g;
const reSplitBetweenElement = />([^<]*)</g; // NOSONAR

const reIndentElemAttr = /(\b|\s+)([a-zA-Z0-9-]+="[^"]*")\s*/g; // NOSONAR
const reStyleAttr = /\bstyle="([^"]+)"/g;
const reEndingSemi = /;$/;
const reSemiSpaces = /;\s*/g;

const reLineBeforeElement = /(^|\n)</g; // extra lines before text and indent elements
const reLineBeforeText = />($|\n)/g; // extra lines before text
const reAttribute = /\b([a-zA-Z0-9-]+)=("[^"]*")\s*/g;

// <h> cuddle up the spaces in elements
const reExtraSpacesElem = /\s+>/g; // NOSONAR
const rePlainElem = /<\/?\w+(\s*\/)?>/g; // <name> </name> <hr /> elements with no attributes
const reBlankLines = /\n\s*\n/g;
// getIdentity()
const reAttrIdentity = /(\b(id|name|role|data-[\w-]+|aria-(label|desc|role)[\w-]*)="[^"]+")/g;
const reElemNoAttr = /<\/?\w+\s*\/?>/g;

const reMultiSpaced = /\n\s*\n+/g;
const reNicePreamble = /(.|\n)+={10} .+?\n/gm; // NOSONAR
const reInitialLineSpaces = /^\s*/gm;
const reNewLines = /\n/gm;
const reExpectStraggler = /^\s*expect\(screen\.queryByText\(RE\[\s*$/gm; // NOSONAR
const reEmbeddedRE = /RE\[(.+?)\]ER/g;
const reSpaceMarker = /(\[SPACE\])+/g;
const reRemoveBlankExpects = /expect[^\n]+BLANKBLANK[^\n]+\n/g

const reSpacesHyphens = /[\s\x20\xA0\u202F\uFEFF\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u200B\u205F\u3000\u303F\xAD\u2010\u2011\u2027\uFE63\uFF0D]/g;

const spaceMap = {
	'\u0009': '[TAB]',
	'\u000A': '[LF]\n',
	'\u000B': '[VT]\n',
	'\u000C': '[FF]\n',
	'\u000D': '[CR]\n',
	//	  '\u0020': '[SP]',
	'\u00A0': '[NBSP]',
	//	  '\uE0020': '[TAG.SPACE]',
	'\u00AD': '[SOFT.HYPHEN]',
	'\u2000': '[EN.QUAD]',
	'\u2001': '[EM.QUAD]',
	'\u2002': '[EN.SPACE]',
	'\u2003': '[EM.SPACE]',
	'\u2004': '[THREE.PER.EM.SPACE]',
	'\u2005': '[FOUR.PER.EM.SPACE]',
	'\u2006': '[SIX.PER.EM.SPACE]',
	'\u2007': '[FIGURE.SPACE]',
	'\u2008': '[PUNCT.SPACE]',
	'\u2009': '[THIN.SPACE]',
	'\u200A': '[HAIR.SPACE]',
	'\u200B': '[ZERO.SPACE]',
	'\u2010': '[HYPHEN]',
	'\u2011': '[NB.HYPHEN]',
	'\u2027': '[HYPHEN.POINT]',
	'\u202F': '[NARROW.NBSP]',
	'\u205F': '[MED.MATH.SPACE]',
	'\u3000': '[IDEOGRAPHIC.SPACE]',
	'\u303F': '[IDEOGRAPHIC.HALF.FILL.SPACE]',
	'\uFE63': '[SMALL.HYPHEN]',
	'\uFEFF': '[ZERO.NBSP]',
	'\uFF0D': '[FULL.WIDTH.HYPHEN]'
};

export const quotesMap = {
	angle   : '<>',
	brace   : '{}',
	bracket : '[]',
	dlcq    : '\u2760\u2760', // double low comma quotes

	dq      : '""', // double quotes

	gq      : '``', // grave quotes

	lrdaq   : '\xAB\xBB', // double angle quotes
	lrdcq   : '\u275D\u275E', // double comma quotes
	lrdlhq  : '\u201E\u201F', // double low high comma quotes

	lrdpq   : '\u2036\u2033', // double prime quotes
	lrdq    : '\u201C\u201D', // left right double quotes

	lrgq    : '`\xb4', // left right grave quotes

	lrlsaq  : '\u276E\u276F', // large single angle quotes

	lrpq    : '\u2035\u2032', // prime quotes

	lrsaq   : '\u2039\u203A', // single angle quotes

	lrscq   : '\u275B\u275C', // single comma quotes

	lrslhq  : '\u201A\u201B', // single low high comma quotes
	lrsq    : '\u2018\u2019', // left right single auotes

	lrtpq   : '\u2037\u2034', // triple prime quotes

	lrwdpq  : '\u2036\u2033', // wide double prime quotes
	lrwhldpq: '\u301D\u301F', // wide high low double prime quotes
	paren   : '()',
	slcq    : '\u275F\u275F', // single low comma quotes

	sq      : "''", // single quotes
	wdq     : '\uFF02\uFF02' // wide double quotes
}; // quotesMap

// Object.values shim does not exist in browser OneCompiler
function objValues(obj : any) : any[]
{
	const values = (Object as any).values
		? (Object as any).values(obj)
		: Object
			.keys(obj)
			.map((key) => obj[key]);
	return values;
}

const quotesClauses = Object
	.values(quotesMap)
	.map((vv) => `\\${vv[0]}\\${vv[1]}`)
	.join('|');

// shortenDump()
const reBracketedString = new RegExp(`^(${quotesClauses}|${LRDQ})$`, 'm');
// const reBracketedString = new RegExp(`^(${quotesClauses})$`, 'm'); using
// --runInBand for the tests on pipeline seems to have stabilised them let's see
// if we can stop skipping these ones now...
export const dskipIfJenkins = process.env.JENKINS_HOME
	? describe.skip
	: describe;
export const skipIfJenkins = process.env.JENKINS_HOME
	? test.skip
	: test;

export function noop() : void {}

let foundAt = "ELEMENT";

/**
 * get/set where the getEl() found its element at.
 * @param here {string} if provided, sets where element was found.
 * @returns {string} current value of foundAt.
 */
export function elementAt(here?: string) : string
{
	const where = foundAt;
	if (here) {
		foundAt = here;
	}
	return where;
} // elementAt()

/**
 * a console warning controlled by the TRACE= environment variable.
 * @param args warnings to show only when TRACE is defined in the environment.
 */
export function trace(...args : any[]) : void
{
	if (process.env.TRACE) {
		console.warn('TRACE', ...args);
		// Enable below if you get error: tsc requires _ spreadArray helper from a newer
		// version of tslib args.unshift('TRACE'); es lint-disable-next-line
		// prefer-spread console.warn.apply(console, args);
	}
}

/*
	Mock notImplementedMethod global functions.
	https://github.com/jsdom/jsdom/blob/main/lib/jsdom/browser/Window.js#L981
*/
export function mockWindowNotImplementedMethods(win?: Window) : Window
{
	win = win || typeof window === 'undefined'
		? global
		: window;
	Object.defineProperty(win, 'alert', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'blur', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'confirm', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'focus', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'moveBy', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'moveTo', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'open', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'print', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'prompt', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'resizeBy', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'resizeTo', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'scroll', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'scrollBy', {
		value   : noop,
		writable: true
	});
	Object.defineProperty(win, 'scrollTo', {
		value   : noop,
		writable: true
	});
	return win;
} // mockWindowNotImplementedMethods()

/**
 * mocks the window location based on site brand name.
 * @param brand {string} specifies to use the URL for specified brand.
 * @example
 * expect(window.location.href).toBe("ht tp://localhost.site:3000/#/")
 * window.location.replace('ht tp://google.com')
 * expect(window.location.href).toBe('ht tp://google.com/')
 * expect(window.location.hostname).toBe('google.com')
 * expect(window.location.replace).toHaveBeenCalledTimes(1)
 * expect(window.location.reload).toHaveBeenCalledTimes(0)
 * expect(window.location.assign).toHaveBeenCalledTimes(0)
 */
export const mockWindowLocation = (brand = 'site', win?: Window) : Window => {
	win = win || typeof window === 'undefined'
		? global
		: window;
	const host = `localhost.${brand}`;
	const url = `htt\p://${host}:3000/#/`;
	const urlobject = new URL(url);
	Object.defineProperty(win, 'location', {
		configurable: true,
		value       : urlobject,
		writable    : true
	});

	function change(url : string) : void
	{
		const urlobject = new URL(url);
		const loc = win.location;
		Object.defineProperty(win, 'location', {
			configurable: true,
			value       : urlobject,
			writable    : true
		});
		win.location.assign  = loc.assign;
		win.location.replace = loc.replace;
		win.location.reload  = loc.reload;
	}

	win.location.assign  = jest.fn(change);
	win.location.replace = jest.fn(change);
	win.location.reload  = jest.fn();
	return win;
};

// re-export everything
export * from '@testing-library/react';
export const userEvent = uev;

//==========================================================
// below, project specific utilities...
//==========================================================
// below, utils from original version...

/**
 * will freeze time using jest Fake Timers so that any dates rendered will be the same.
 * @param when {string} a specific system time to use for unit tests. default value provided is a leap year with different numbers in all time fields.
 */
export function freezeTime(when = '2024-07-04 01:02:03') : Date
{
	const date = new Date(when);
	jest
		.useFakeTimers()
		.setSystemTime(date);
	return date;
}

/**
 * will log a function by mock name or actual name.
 * @param where {string} unique string to locate a position within the tests
 * @param fn {function | jest.Mock} a function to log the mock name, if exists or function name if not.
 */
export function logMock(where = 'LOG MOCK', fn : ReturnType < typeof jest.fn >) : void
{
	if (fn.getMockName) {
		console.warn(`logMock(${where}) MOCKED: ${fn.getMockName()}`);
	} else {
		console.warn(`logMock(${where}) NOT MOCKED: ${fn.name}`);
	}
}

const regexMeta = [
	'^',
	'$',
	'/',
	'.',
	'*',
	'+',
	'?',
	'|',
	'(',
	')',
	'[',
	']',
	'{',
	'}',
	'\\'
].join('|\\');
const SRE = new RegExp('(\\' + regexMeta + ')', 'g');
/**
 * answers with a string which has all regular expression meta characters escaped correctly.
 * @param stringToRegex {string} a string to convert to a regular expression safely.
 * @returns {string} with all regular expression special characters escaped.
 * @note Equivalent to perl's quotemeta() function.
 * ht tps://simonwillison.net/2006/Jan/20/escape/
 */
export function quotemeta(stringToRegex : string) : string
{
	return stringToRegex.replace(SRE, '\\$1');
}

/**
 * assert a test that the element or document is empty of text (may contain elements though).
 * @param element (HTMLElement} the element to check for emptiness. defaults to the entire document.body.
 */
export function checkDocumentTextEmpty(element : HTMLElement = document.body,) : true
{
	expect(element.innerHTML.replace(reVersionNickname, '').replace(reDocTextEmpty, '')).toMatch(/^\s*$/);
	return true;
}

/**
 * assert that all id= attributes in the document contain the appId so they will be unique on the page.
 * @param element {HTMLElement|string} the element or raw HTML to check for id= attributes. defaults to the entire document.body.
 * @param prefix {string} the string to check for presence in all id= attributes. defaults to the app's appId.
 */
export function checkPageIds(element : HTMLElement | string = document.body, prefix = appId) : true
{
	const html = getHtml(element);
	html.replace(reElemWithId, function checkIds(openTag : string, name : string) {
		if (name.indexOf(prefix) < 0 && !reAllowId.test(name)) {
			expect(`Found in element: ${openTag}`).toBe(`Element with non-unique id="${name}" should contain our unique app id: ${prefix} for example: "${prefix}-${name}"`);
		}
		return '';
	});
	return true;
} // checkPageIds()

/**
 * assert that the rendered html does not contain any 'undefined' values like undefined, null, NaN or Infin ity that the user might see.
 * Will also check that currency markers like $ or pound are followed by actual amounts.
 * And will check that false and true have not been accidentally stringified into the text as well, by remo ving boolean HTML attributes before looking.
 * @param element {HTMLElement|string} the element to check for stringifying and other coding/render errors defaults to the entire document.body.
 * Alterative is to grep the snapshots for such values:
 * git grep -E 'false|true|undefined|null|\bNaN\b|Infinity|\[object Object\]|function ' `find src -type f | grep __snapshots__` | grep -vE '(focusable|aria-(invalid|hidden|expanded|checked|haspopup))='
 */
export function checkUndefined(element : HTMLElement | string = document.body) : true
{
	const html = (typeof element === 'string'
			? element
			: getHtmlNice(element, ' '))
		.replace(reAttrsBoolean, '')
		.split(/\n\n/);

	html.forEach((fragment) => {
		if (reMissingMoney.test(fragment)) {
			expect(`Have you missed rendering some monetary amount?\n${fragment}`)
				.not
				.toMatch(reMissingMoney);
		}
		if (reStringified.test(fragment)) {
			expect(`Did you stringify something by accident?\n${fragment}`)
				.not
				.toMatch(reStringified);
		}
		if (reBoolean.test(fragment)) {
			expect(`Should not be true or false, did you stringify a boolean by accident?\n${fragment}\n\nIf not, add the attribute name to the reAttrsBoolean regex to allow it to have boolean values.`)
				.not
				.toMatch(reBoolean);
		}
	});
	return true;
} // checkUndefined()

/**
 * answers with the identifying HTML attributes useful for getByTestId calls when testing the rendered output.
 * @param html {string} Some HTML from getHtml, getHtmlNice, or getTextNice or elsewhere.  defaults to getHtmlNice() output.
 * @returns a string listing of the relevant identifying attributes present across all elements.
 */
export function getIdentity(html : string = getHtmlNice()) : string
{
	const ids : string[] = [];

	html.replace(reAttrIdentity, function findIds(unused, one) : string {
		ids.push(TAB + one);
		return '';
	});

	return ids.join('\n');
} // getIdentity()

/**
 * used to write your content verification tests for your after rendering a test component.
 * @param where {IElementLocator} optional element locator. default is document.body
 * @param space {string} used to replace each non-newline space character surrounding each element's innerText. default is '[SPACE]'
 * @returns {string} of expect().toBeInTheDocument() code to verify all the rendered text.
 */
export function getExpectations(where?: IElementLocator, space = SPC) : string
{
	const titles : string[] = [];
	const labels : string[] = [];
	const values : string[] = [];
	const IND = '    ';
	const CW = 'con\sole.warn';

	const result = ('\n\n// render() your component...\n' + `${CW}('IDENTITY', getIdentity());\n` + `const before = getHtmlNice();\n` + `${CW}('RENDER', before);\n` + `expect(checkUndefined()).toBeTruthy();\n` + `expect(checkPageIds()).toBeTruthy();\n` + `expect(checkDocumentTextEmpty()).toBeTruthy();\n` + `expect(checkDialogOpen(dialog)).toBeTruthy();\n` + getHtml(where, space).replace(reLineBeforeElement, `$1\n<`) // extra lines around text and indent elements
		.replace(reLineBeforeText, '>\n$1') // extra lines around text
		.replace(reAttribute, function replaceAttr(match, name, value) {
		if (name === 'title') {
			titles.push(`expect(screen.queryByTitle(` + value + ')).toBeInTheDocument();\n');
		} else if (name === 'aria-label') {
			labels.push(`expect(screen.queryByLabelText(` + value + ')).toBeInTheDocument();\n');
		} else if (name === 'value') {
			values.push(`expect(screen.queryByDisplayValue(` + value + ')).toBeInTheDocument();\n');
		}
		return '';
	}) // remove all attributes in elements
		.replace(reElemNoAttr, '') // now remove all the elements
		.replace(reMultiSpaced, '\n') // and mult-line spacing
		.replace(reNicePreamble, '').replace(reInitialLineSpaces, 'expect(screen.queryByText(RE[').replace(reNewLines, ']ER)).toBeInTheDocument();\n').replace(reExpectStraggler, '').replace(reEmbeddedRE, function toRegex(full, string) {
		const quoted = quotemeta(string.replace(reSpaceMarker, ''));
		return quoted
			? `/^\\s*${quoted}\\s*$/m`
			: 'BLANKBLANK';
	}).replace(reRemoveBlankExpects, '') + [
		...titles,
		...labels,
		...values
	].join() + `// await userEvent.click()...\n` + `let after;\n` + `await waitFor(() => {\n` + `${IND}after = getHtmlNice();\n` + `${IND}expect(after).not.toBe(before);\n` + `});\n` + `// will show only what has changed in the HTML due to the user event.\n` + `expect(after).toBe(before);\n`);
	return result.replace(/\n/g, `\n${IND}`);
} // getExpectations()

/**
 * this will check if a constellation/core Dialog component is open.
 * @param dialog {HTMLElement} the dialog as returned by a getByTestId() or similar test matcher.
 * @returns boolean {true} so you can expect(checkDialogopen(...)).toBe(true)
 */
export function checkDialogOpen(dialog : HTMLElement) : true
{
	expect(dialog).toHaveAttribute('role', 'dialog');
	// depends on version of constellation
	expect(dialog).toHaveAttribute('aria-modal', 'true');
	expect(dialog).toHaveAttribute('aria-hidden', 'false');
	expect(dialog)
		.not
		.toHaveAttribute('hidden');
	expect(window.getComputedStyle(dialog).visibility).toBe('visible');
	return true;
} // checkDialogOpen()

/**
 * this will check if a constellation/core Dialog component is closed.
 * @param dialog {HTMLElement} the dialog as returned by a getByTestId() or similar test matcher.
 * @returns boolean {true} so you can expect(checkDialogClosed(...)).toBe(true)
 * @note closed dialogs are still in the DOM, just made not visible.
 */
export function checkDialogClosed(dialog : HTMLElement) : true
{
	expect(dialog).toHaveAttribute('role', 'dialog');
	// depends on version of constellation
	expect(dialog).toHaveAttribute('aria-modal', 'true');
	expect(dialog).toHaveAttribute('aria-hidden', 'true');
	expect(dialog).toHaveAttribute('hidden', '');
	expect(window.getComputedStyle(dialog).visibility).toBe('visible');
	return true;
} // checkDialogClosed()

/**
 * a document.getElementById() function that also works with jest/react-dom using document.querySelector() instead.
 * @param {string} id The id value for the element to locate in the DOM.
 * @returns {null | HTMLElement} The element with the id value specified or null.
 */
export function getElementById(id : string) : null | HTMLElement
{
	let found = null;
	try
	{
		try
		{
			found = document.getElementById(id);
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		} catch (ignore) {}
		found = found || document.querySelector < HTMLElement > (`#${id}`);
		// eslint-disable-next-line @typescript-eslint/no-unused-vars
	} catch (ignore) {}
	return found;
} // getElementById()

/**
 * Get the HTML from the page or DOM element with every element open/close on a new line.
 * Useful for diffing the component after a userEvent() to see what changed.
 * Can be compared with expect(getHtml()).toBe(previousHtml).
 * @param where {IElementLocator} optional element locator. default is document.body
 * @param space {string} used to replace each non-newline space character surrounding each element's innerText. default is '[SPACE]'.
 * @returns {string} rendered HTML with minimal formatting and surrounding spaces made visible.
 * @note see getEl() for 'where' string format to look up Nth item, parentElements and dumping the match list.
 */
export function getHtml(where?: IElementLocator, space = 'INDICATE') : string
{
	return (getEl(where).innerHTML.replace(reSplitAfterElement, function splitElementsAfter(unused, after) {
		return `>${NL}${showSpaces(after, space)}`;
	}).replace(reSplitBeforeElement, function splitElementsBefore(unused, before) {
		return `${showSpaces(before, space)}${NL}<`;
	}).replace(reSplitBetweenElement, function splitElementsBetween(unused, between) {
		return `>${NL}${showSpaces(between, space)}${NL}<`;
	})
	// .replace(/((up to parent no more up) -->)/g, `${NL}$1`)
		.replace(new RegExp(NL, 'g'), '\n').replace(/^/, elementAt() + '\n========== FOUND\n'));
} // getHtml()

/**
 * replace/remove all spaces in text for better testing visibility. Newlines are left alone.
 * @param text {string} the text to replace spaces within.
 * @param space {string} used to replace each non-newline space character. default is to remove spaces.
 * @returns {string} with all non-newline spaces replaced.
 */
export function replaceSpaces(text : string, space = '') : string
{
	return text.replace(/\s/g, function replacespace(match) {
		return match === '\n'
			? match
			: space;
	});
} // replaceSpaces()

/**
 * Show the leading and trailing spaces in some text for better testing visibility. Newlines are left alone.
 * @param text {string} the text to replace spaces within multiline text.
 * @param space {string} used to replace each non-newline space character. default is '[SPACE]'
 * if space is 'INDICATE' then indicateSpaces() and replaceCharsCodePt() functions will be used instead.
 * @returns {string} with all leading and trailing non-newline spaces replaced (or all spaces indicated by indicateSpaces()).
 */
export function showSpaces(text : string, space = SPC) : string
{
	if (space === 'INDICATE') {
		return replaceCharsCodePt(indicateSpaces(text));
	}
	return text.replace(reOuterSpaces, function replaceOuterSpaces(unused, leading, middle, trailing) {
		return (replaceSpaces(leading, space) + middle + replaceSpaces(trailing, space));
	});
} // showSpaces()

/**
 * answers with all character codes above 255 replaced by U+NNNN unicode markers.
 * @param text {string} the text to indicate unicode code points explicitly.
 * @returns {string} the text with unicode code points replaced with U+NNNN.
 */
function replaceCharsCodePt(text : string) : string
{
	return text.replace(/./g, function replaceCodePt(match : string) : string {
		const code = match.charCodeAt(0);
		return code > 255
			? `[U+${code
				.toString(16)
				.toUpperCase()}]`
			: match;
	});
} // replaceCharsCodePt()

/**
 * answers with string replacing all white space and hyphens with [TAB] [NBSP] markers for easier debugging.
 * single spaces are left alone but multple runs of spaces are shown as [SPx5].
 * @param text {string} the text to indicate where white spaces and hyphens are.
 * @returns {string} the text with spaces indicated throughout.
 * @note Newlines, form feeds and other characters will be replaced with a marker and a newline so that
 * they still break the string into multiple lines but you will be able to see end of line marker inconsistencies.
 */
function indicateSpaces(text : string) : string
{
	let out = text.replace(reSpacesHyphens, function myReplaceSpaceHyphen(match : string) : string {
		return match === ' '
			? ' '
			: (spaceMap[match] || `[MISSING U+${match.charCodeAt(0).toString(16)}]`);
	});
	return out.replace(/  +/g, function myReplaceSpaces(match : string) : string {return `[SPx${match.length}]`;});
} // indicateSpaces()

/**
 * Get the HTML from the page or DOM element with every element open/close on a new line as well as HTML el ements and style definitions.
 * Useful for seeing component render better than the debug() provided by the testing library.
 * Can also be compared with expect (getHtmlNice()).toBe(previousHtml).
 * @param where {IElementLocator} optional element locator. default is document.body
 * @param space {string} used to replace each non-newline space character surrounding each element's innerText. default is '[SPACE]'
 * @returns {string} rendered HTML with element/attribute/style formatting and surrounding spaces made visible.
 * @note see getEl() for 'where' string format to look up Nth item, parentElements and dumping the match list.
 */
export function getHtmlNice(where?: IElementLocator, space = 'INDICATE') : string
{
	return (getHtml(where, space)
	// indent element attributes on own line
		.replace(reIndentElemAttr, `\n${TAB}$2`)
	// indent element styles deeper on own line
		.replace(reStyleAttr, function replaceStyles(unused, styles) {
		return `styles="\n${TAB}${TAB}${styles
			.replace(reEndingSemi, '')
			.split(reSemiSpaces)
			.join(`;\n${TAB}${TAB}`)}\n${TAB}"`;
	}).replace(reBlankLines, '\n\n') // remove excess newlines
	);
} // getHtmlNice()

/**
 * Get the text of rendered HTML with identifiable HTML elements between.
 * Useful for writing getByText() getByLabelText() getByTitle() getByAltText() queries better than the debug() provided by the testing library.
 * @param where {IElementLocator} optional element locator. default is document.body.
 * @param space {string} used to replace each non-newline space character surrounding each element's innerText. default is '[SPACE]'
 * @returns {string} rendered HTML Text outdented with some HTML elements shown indented as identifiable landmarks.
 * @note see getEl() for 'where' string format to look up Nth item, parentElements and dumping the match list.
 */
export function getTextNice(where?: IElementLocator, space = 'INDICATE') : string
{
	return (getHtml(where, space).replace(reLineBeforeElement, `$1\n${TAB}<`) // extra lines around text and indent elements
		.replace(reLineBeforeText, '>\n$1') // extra lines around text
	// remove most element attributes except identifying ones...
		.replace(reAttribute, function replaceAttribute(unused, attr, value) {
		let show = reAttrsToShow.test(attr);
		show = FLIP
			? !show
			: show;
		return show
			? `\n${TAB}${TAB}${attr}=${value}`
			: '';
	}).replace(reExtraSpacesElem, '>') // <h > cuddle up the spaces in elements
		.replace(rePlainElem, '') // strip out simple <name> </name> elements with no attributes
		.replace(reBlankLines, '\n\n') // remove excess newlines
	);
} // getTextNice()

/**
 * interate through a collection or array(type C) of elements or attributes(type T) as the case may be.
 * @param collection {C} A colleciton or array of elements or attributes.
 * @param fn {(item: T, index: number) => void} A callback to process an element or attribute from the collection.
 * @note Handles error: Type 'NamedNodeMap' can only be iterated through when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.ts(2802)
 */
export function forOf < C,
T > (iterable : C, fn : (item : T, index : number) => void) : void
{
	let loop = 0;
	const collection = iterable as unknown as T[];
	try
	{
		// @ts-expect-error TS2802: Type 'IElementList' can only be iterated through
		// when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or
		// higher. @ts-expect-error TS2495: Type 'IElementList' is not an array type or
		// a string type.
		for (const item of collection) {
			++loop;
			fn(item, loop - 1);
		}
	} catch (exception) {
		if (loop) {
			throw exception;
		}
		for (let index = 0; index < collection.length; index++) {
			fn(collection[index], index);
		}
	}
} // forOf()

/**
 * gives some info about an element suitable for logging.
 * @param element {Element} will be examined for formatting nicely.
 * @returns {string} containing element tag name and attributes formatted as an HTMLElement.
 *@note borrowed from original in broadcast-messages-cwa repository.
 */
export function elementInfo(element : IElement) : string
{
	const attrs : string[] = [];
	// Type 'NamedNodeMap' can only be iterated through when using the
	// '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.ts
	// (2802)
	forOf < NamedNodeMap,
	Attr > (element.attributes, (attr) => {
		// console.warn(`forOf1 proto:, Object.getPrototypeOf(attr), `\n   attr:`,
		// attr);
		attrs.push(`${attr.name}="${attr.value}"`);
	});

	return `<${element
		.tagName} ${attrs
		.join(' ')} />`
		.replace(reExtraSpacesClosureElem, ' />');
} // elementInfo()

/**
 * answers with an Element directly or by matching against whatever is rendered on the page.
 * @param element {IElementLocator} number|string|RegExp or Element itself. defaults to document.body.
 * A number will return the Nth div or span in the document accordingly.
 * A string which contains raw HTML will be returned as an object with .innerHTMLL value in it.
 * A RegExp or string will be matched against every query type: id, test-id, text, label, etc to find elements.
 * The string can be suffixed with [nnn]^^@LIST for more control. See the suffix parameter for explanation.
 * @param suffix {string?} optional suffix string for when element is a RegExp or other non-string.
 * [nnn] specifies which item in the matches list to return counting from beginning or end(negative)
 * each ^ indicates to go up to the parent element after getting the Nth item.
 * \@LIST if preesent will log the whole match list giving match method, element type and attributes.
 * @returns {IElement} will always be returned, defaulting to document.body if no matches are found.
 */
export function getEl(element?: IElementLocator, suffix?: string) : IElement
{
	const isRegex = element instanceof RegExp;
	const elements : ElementWithType[] = [];
	let found = document.body as Element;
	let where = 'GET EL ELEMENT ';
	elementAt('ELEMENT');
	if (typeof element === 'number') {
		element = `div,span [${element}]`; // for querySelectorAll()
	}

	let elAsString = (element || '').toString();
	if (reRawHtml.test(elAsString)) {
		where = 'GET EL RAW HTML STRING';
		elementAt(where);
		// @ts-expect-error TS2740 Type '{innerHTML: string; }' is missing the following
		// properties from type 'Element': attributes, class List, className,
		// clientHeight
		return {innerHTML: elAsString} as IElement;
	}

	// Add found Elements to list with a type value telling how it was found and
	// what type of element it is.
	function accumulate(elsFound : IElementList, type : string) : void
	{
		if (elsFound.length) {
			// Type 'IElementList' can only be iterated through when using the
			// '--downlevelIteration' flag or with a '--target' of 'es2015' or
			// higher.ts(2802)
			forOf < IElementList,
			HTMLElement > (elsFound, (elThis, index) => {
				// console.warn(`forof2 proto:, Object.getPrototypeOf(elThis), `\n   elThis:`,
				// elThis);
				const attrs : string[] = [];
				// Type 'NamedNodeMap' can only be iterated through when using the
				// '--downlevelIteration' flag or with a '--target' of 'es2015' or
				// higher.ts(2802)
				forOf < NamedNodeMap,
				Attr > (elThis.attributes, (attr) => {
					// console.warn(`forof3 proto:`, Object.getPrototypeOf(attr), `\n   attr: `,
					// attr);
					attrs.push(`${attr.name}="${attr.value}"`);
				});
				elements.push({element: elThis, type: `${type}#${index} ${elementInfo(elThis)}`});
			});
		}
	} // accumulate()

	type Suffixes = [number, number, boolean, string];
	// parse the [nnn]^^^@LIST values from the suffix.
	function getSuffix(suffix : string) : Suffixes
	{
		let index = 0;
		let up = 0;
		let dumpList = false;

		suffix = suffix.replace(reIndexUp, function replaceIndexing(unused, idx, levels, list) {
			if (idx) {
				index = parseInt(idx, 10);
			}
			if (levels) {
				up = levels.length;
			}
			if (list) {
				dumpList = true;
			}
			return '';
		});

		return [index, up, dumpList, suffix];
	}

	// Use an Element query function to get matching Elements and add them to the
	// list.
	function getMatches(name : string, getter : (where : IElementMatcher) => IElementList, getme : IElementMatcher) : IElementList
	{
		let elSelector : IElementList = [];
		try
		{
			elSelector = getter(getme);
			accumulate(elSelector, name);
		} catch (exception) {
			trace(`EXCEPTION getEl(${elAsString}) ${name}`, exception);
		}
		return elSelector;
	} // getMatches()

	if (!isRegex && typeof element !== 'string') {
		// a given element will be used or fall back to entire document
		found = (element as IElement) || document.body;
		// console.warn(`getEl found`, found);
		elementAt(where + elementInfo(found));
	} else {
		// String or Regex will look for matching Elements using any query function.
		let query : IElementMatcher = element as IElementMatcher;
		elAsString = query.toString();

		// handle [nnn] indexing of the result at end of string or in suffix parameter.
		// handle ^ at end of string to go to parentElement. trace(`getEl parse
		// ${elAsString} for index ${reIndexUp.toString()}`);
		let index = 0;
		let up = 0;
		let dumpList = false;

		if (isRegex) {
			where = `GET EL REGEX ANY MATCH FOR ${elAsString}`;
			if (suffix) {
				[index, up, dumpList] = getSuffix(suffix);
				where                 += ` [${index}] go up ${up}`;
			}
		} else {
			let query;
			[index, up, dumpList, query] = getSuffix(elAsString);
			if (query === elAsString && suffix) {
				[index, up, dumpList] = getSuffix(suffix);
			}
			elAsString = query;
			where      = `GET EL FIND ANY MATCH FOR "${elAsString}" [${index}] go up ${up}`;
		} // !isRegex

		// Match the String or RegExp using every matcher possible...
		const elTestId = getMatches('ByTestId', screen.queryAllByTestId, query);
		let elId : null | HTMLElement | HTMLElement[] = getElementById(elAsString);
		elId = elId
			? [elId]
			: [];
		accumulate(elId as HTMLElement[], 'ById');

		const elLabel = getMatches('ByLabelText', screen.queryAllByLabelText, query);
		const elText = getMatches('ByText', screen.queryAllByText, query);
		const elTitle = getMatches('ByTitle', screen.queryAllByTitle, query);
		const elAlt = getMatches('ByAltText', screen.queryAllByAltText, query);
		const elPlace = getMatches('ByPlaceholderText', screen.queryAllByPlaceholderText, query);
		const elValue = getMatches('ByDisplayValue', screen.queryAllByDisplayValue, query);
		const elRole = getMatches('ByRole', screen.queryAllByRole, query);

		const elSelector = getMatches('ByQuerySelector', document.querySelectorAll.bind(document), elAsString);

		const elClass = document.getElementsByClassName(elAsString);
		accumulate(elClass, 'ByClassName');

		trace(`getEl(${where}) label:${elLabel.length} value:${elValue.length} placeholder:${elPlace.length} role:${elRole.length} text:${elText.length} title:${elTitle.length} alt:${elAlt.length} testid:${elTestId.length} id:${elId.length} sel:${elSelector.length} class:${elClass.length}`);
		if (dumpList) {
			console.warn(`GET ELEMENT @LIST MATCHES: ${elements.length}`, elements.map((found, index) => {
				return `#${index}: ${found.type}`;
			}));
		}

		// look up Nth item from beginning/end and wrap around
		const length = elements.length;
		const idx = (length + (index > 0
			? index
			: -(-index % length))) % length;

		// trace(`getEl lookup [${index}] #${idx} of ${length}`, elements[idx]);
		if (elements[idx]) {
			const elFirst = elements[idx]as ElementWithType;
			found = elFirst.element;
			where += `\nlookup @[${idx}] of ${length} matched ==> [[${elFirst.type}]]`;
		} else {
			where += `\nNOTHING FOUND, using <BODY />`;
			found = document.body;
		}

		// process each ^ for parent element
		while (up) {
			if (found.parentElement) {
				found = found.parentElement;
				where += `\nup to parent --> ${elementInfo(found)} `;
				up--;
			} else {
				where += `\nno more up --> `;
				up    = 0;
			}
		} // while up

		// remember where we found the element
		elementAt(where);
	} // isRegex || string

	return found;
} // getEl()

//==========================================================
// Event / Element dumping tools

/**
 * answers with the type name of the Object given.
 * [object MouseEvent] will show as 'MouseEvent ' note the trailing space.
 * @param thing {unknown} some constant or variable you wish to know the type name of.
 * @returns {string} primitives will return an empty string.  Objects return their type name with a trailing space.
 */
export function getTypeName(thing : unknown) : string
{
	try
	{
		const type = typeof thing;
		if (Array.isArray(thing)) {
			return 'Array ';
		} else if (thing === null) {
			return 'Object ';
		} else if (thing instanceof RegExp) {
			return 'RegExp ';
		} else if (thing instanceof Boolean) {
			return 'Boolean ';
		} else if (thing instanceof Number) {
			return 'Number ';
		} else if (thing instanceof String) {
			return 'String ';
		} else if (thing instanceof Date) {
			return 'Date ';
		} else if (type === 'function') {
			return 'Function ';
		} else if (/^(boolean|number|string|undefined)$/.test(type)) {
			return '';
		}
		const proto = Object.getPrototypeOf(thing);
		const name = proto.name
			? proto.name
			: proto;
		// stringifying like this works better to get the type name.
		return [name, '']
			.join(' ')
			.replace(/\[object ([^\]]+)\]/, '$1');
	} catch (exception) {
		return `EXCEPTION getTypeName[${exception}]`;
	}
	return '';
} // getTypeName()

/**
 * answer with the text surrounded by quotes of a specific type.
 * @param text {string} the text which needs to be surrounded by quotes.
 * @param quotes {string} a name from quotesMap or a 1-2 character long string indicating which quote characters to use to surround the text.
 */
export function enquote(text : string, quotes = 'lrdq') {
	quotes = quotesMap[quotes] || quotes;
	return quotes[0] + text + quotes[quotes.length - 1];
}

/**
 * answers with a shortened string when it exceeds the given length. Ellipsis will be added to show omitted characters.
 * @param dump {string}
 * @param MAX_LENGTH {number} the maximum number of relevant characters to show from the dump string.
 * @param quotes {string} quote characters to use to surround the dump string, if provided. ie '""'
 * @returns {string} the string with an ellipisis to show missing characters if needed.
 * @note when shortened, the ellipsis will be at the end of the string, but inside any brackets or existing quotes.
 */
export function shortenDump(dump : string, MAX_LENGTH = MAX_THING, quotes = '') : string
{
	const ELLIPSIS = EL;
	if (quotes && quotes.length < 2) {
		quotes += quotes;
	}
	let wrap : string | [string, string] = (dump.length < 2 || quotes)
		? ''
		: dump[0] + dump[dump.length - 1];
	// console.warn(`shortenDump0 q:${quotes} w:[${wrap}] ${reBracketedString}
	// [${dump}]`)
	if (!reBracketedString.test(wrap)) {
		wrap = '';
	}
	// console.warn(`shortenDump1 q:${quotes} w:[${wrap}] [${dump}]`)
	const reFunctionBracket = /^function .+\}$/m;
	if (reFunctionBracket.test(dump)) {
		wrap = ['function ', '}'];
		dump = dump.substring(9, dump.length - 1);
	} else if (wrap) {
		dump = dump.length <= 2
			? ''
			: dump.substring(1, dump.length - 1);
	}
	// console.warn(`shortenDump2 q:${quotes} w:[${wrap}] [${dump}]`)
	if (dump.length > MAX_LENGTH) {
		dump = dump.substring(0, MAX_LENGTH) + ELLIPSIS;
	}
	// console.warn(`shortenDump3 q:${quotes} w:[${wrap}] [${dump}]`)
	if (wrap) {
		dump = wrap[0] + dump + wrap[1];
	}
	// console.warn(`shortenDump4 q:${quotes} w:[${wrap}] [${dump}]`)
	return quotes
		? `${quotes[0]}${dump}${quotes[1]}`
		: dump;
} // shortenDump()

/**
 * answer with a shortened version of some value/object so console logs aren't overwhelmed.
 * An ellipsis \u{2026} will show that some text has been omitted if the output is too long.
 * @param thing {unknown} the thing that you want to log or show, with a maximum length.
 * @param MAX_LENGTH {number} the maximum number of relevant characters to show from the thing.
 * @note the acttual length of string returned may slightly exceed the MAX_LENGTH provided as in the examples below.
 * For big objects or ones that cannot be stringified, shows the top level key names instead.
 * @example
 * \u{201c}a string\u{201d}
 * \u{201c}a very long str\u{2026}\u{201d}
 * /regex is lo\u{2026}/gi
 * [1,3,"array \u{2026}]
 * [[object global],3,array\u{2026}]
 * {"a":234,"b":66}
 * keys: [a, b]  (for objects that are too long when dumped or cannot be stringified)
 * keys: [atob, btoa, \u{2026}]
 * function sho\u{2026}
 * TypeError: bologna\u{2026}
 */
export function showThing(thing?: unknown, MAX_LENGTH = MAX_THING, notElem = false) : string
{
	const ELLIPSIS = EL;
	const type = typeof thing;
	const typeOf = getTypeName(thing);
	let out = `${thing}`;
	let showkeys = false;
	let isArray = Array.isArray(thing);
	const isObject = !!typeOf && !/^(NaN|-?Infinity|null)$/.test(out) && !/^(Boolean|Number|String|Date|RegExp) $/.test(typeOf) && !(thing instanceof Error);
	const isElement = /^(HTML\w+)?Element $/.test(typeOf) || (!notElem && isObject && ('__reactInternalInstance1234' in(thing as object)));

	// 	console.warn(`showThing ${type}/${typeOf} obj:${isObject} el:${isElement}
	// arr:${isArray} [${out}]`);
	try
	{
		if (isElement) {
			out = getElementInfo(thing);
		} else if (/^(Weak)?Map $/.test(typeOf)) {
			const map = {};
			for (const entry of(thing as Map | WeakMap).entries()) {
				map[entry[0]] = entry[1];
			}
			thing = map;
		} else if (/^(Weak)?Set $/.test(typeOf)) {
			isArray = true;
			const set = [];
			for (const key of(thing as Set | WeakSet).keys()) {
				set.push(key);
			}
			thing = set;
		}

		if (isArray || (isObject && !isElement && !(thing instanceof Function))) {
			try
			{
				out = JSON.stringify(thing);
				// eslint-disable-next-line @typescript-eslint/no-unused-vars
			} catch (ignore) {
				if (isArray) {
					out = `[${out}]`;
				} else {
					showkeys = true;
				}
			}
		}

		// console.warn(`showThing2 ${type}/${typeOf} l:${out.length} sk:${showkeys}
		// obj:${isObject} arr:${isArray} [${out}]`)
		if (typeOf === 'RegExp ' && out.length > MAX_LENGTH) {
			const reShorten = new RegExp(`^(/.{${MAX_LENGTH - 1}}).*(/[^/]*)$`, 'g');
			out = out.replace(reShorten, `$1${ELLIPSIS}$2`);
			return out;
		}

		if ((showkeys || out.length > MAX_LENGTH) && isObject && !isElement && !isArray && !(thing instanceof Function) && !(thing instanceof Error)) {
			out = Object
				.keys(thing as object)
				.sort()
				.join(', ');
			return `keys: [${shortenDump(out, MAX_LENGTH)}]`;
		}
		// eslint-disable-next-line @typescript-eslint/no-unused-vars
	} catch (exception) {
		return `EXCEPTION showThing[${exception}]`;
	}

	return shortenDump(out, MAX_LENGTH, type === 'string' || typeOf === 'String '
		? `${LDQ}${RDQ}`
		: '');
} // showThing()

const firstDump = {
	elementSources: `getElementInfo: Element properties shown are sourced from: [attr="pendingProps/memoizedProps/index"]`
};

/**
 * answers with the value if if it's not undefined or null.
 * @param value {any} the variable to check if it has a value.
 * @returns {string|boolean|number|array|object} empty string returned if value is undefined or null.
 * undefined, null, '' => ''
 * NaN, Infinity, 0, false, everything else => returned as is
 */
export function has(value?: any) : string | boolean | number | object
{
	if (value || /^(boolean|number)$/.test(typeof value)) {
		return value;
	}
	return '';
}

/**
 * answers with a stringified value unless undefined or null which returns empty string.
 * @param value {any} the variable to stringify.
 * @returns {string} empty string returned if value is undefined or null.
 * undefined, null, '' => ''
 * NaN, Infinity, 0, false, everything else => stringified
 */
export function str(value?: unknown) : string
{
	if (value || /^(boolean|number)$/.test(typeof value)) {
		return Array.isArray(value)
			? `[${value}]`
			: `${value}`
		// return [value, ''].join('');
	}
	return '';
}

// Show identifying info about a React DOM element in a shorthand form.
// <span.sc-gEvEer.gxLIef.csl-typography.csl-text-s2. HTMLSpanElement />
// <button#this-button[data-testid="TESTID"][type="submit"][tabIndex="4"].sc-jxbUNg.kqWmzg.csl-button.my-silly.class.names.csl-button--primary. HTMLButtonElement />
// or, if not an element:
// NOT ELEM??? object Object  keys: [Buffer, CSS, CSSImportRule, CSSMediaRule, CSSRule, CSSStyleDeclaration CSSStyleRule, CSSStyleSheet, Category-error, Date range-\u{2026}]
// MUSTDO change any to Element | ReactSimulatedElement
export function getElementInfo(element?: any, prefix = '') : string
{
	const bits = [];

	interface IRElem
	{
		elementType : string;
		pendingProps : Record < string,
		string >;
		memoizedProps : Record < string,
		string >;
	}
	let target : IRElem;

	// return property value by looking in a few places for the first or all found.
	function prop(key : string) : string | boolean | number | object
	{
		const bits = [
			has(element[key]),
			has(target
				?.pendingProps && target.pendingProps[key]),
			has(target
				?.memoizedProps && target.memoizedProps[key])
		];
		if (firstDump.elementSources) {
			console.warn(firstDump.elementSources);
			firstDump.elementSources = '';
		}
		if (showAllPropSources) {
			const joined = bits.join('/');
			return joined !== '//'
				? joined
				: '';
		}
		return str(bits[0]) || str(bits[1]) || str(bits[2]);
	}
	// prop(key): undefined, '' => '' string => gets quotes added NaN, Infinity, 0,
	// false, everything else => stringified with prefix/suffix added
	function attr(key : string, prefix = '', suffix = '', quote = '') : string
	{
		let value = prop(key);
		if (value !== '' && typeof value !== 'undefined') {
			value = typeof value === 'string'
				? `${quote}${value}${quote}`
				: value;
			return `${prefix}${value}${suffix}`;
		}
		return '';
	}
	function attrVal(key : string) : string
	{
		return attr(key, `[${key}=`, `]`, '"');
	};

	try
	{
		// MUSTDO remove the 'as any' here...
		const targetKey = (Object.keys(element || {})as any).find((key) => /^__reactInternalInstance/.test(key));
		// console.warn(`getElementInfo1 tk:${targetKey}`, element)
		target = targetKey
			? element[targetKey]
			: undefined;
		const tagName = target
			? target.elementType
			: element
				?.tagName;

		if (tagName) {
			bits.push(`<${tagName}${attr('id', '#')}`);
			attrsToShow.forEach((attr) => {
				bits.push(attrVal(attr));
			});
			bits.push(`${attr('className', '.', ' ').replace(/\s+/g, '.')} `, getTypeName(element), '/>');
		}
		// eslint-disable-next-line @typescript-eslint/no-unused-vars
	} catch (exception) {
		console.warn(`Exception getElementInfo[${exception}]`)
	}

	if (!bits.length) {
		bits.push(`NOT ELEM??? ${typeof element} ${getTypeName(element)} ${showThing(element, void 0, true)}`);
	}
	if (prefix) {
		bits.unshift(prefix);
	}

	return bits.join('');
} // getElementInfo()

/**
 * answers with a summary of event properties and related DOM elements.
 * @param event {Event} the Event object to dump.
 * @param prefix {string} some text to prefix the dumped output with.
 * @returns {string} the summary of event properties and related DOM elements.
 * @example:
 * EVENT MouseEvent click/@1719410356201 onclick onclickCapture eventPhase (3) bubbles defaultPrevented isDe faultPrevented isPropagationStopped
 * target: <button#[data-testid="update-button"][name=""][type="submit"][role=""][target=""][rel=""][disabled="][focusable=""][width=""][height=""][hidden=""][tabindex=""][for=""][title=""][placeholder=""][alt=""][href=""].sc-jxbUNg.kqwmzg.csl-button.cs1-button--primary. />
 * currentTarget: <div#[data-testid="applyChangesContainer"][name=""][type=""][role=""][target=""][re]=""][ disabled=""][focusable=""][width=""][height=""][hidden=""][tabIndex=""][for=""][title=""][placeholder=""][a]t=""][href=""].. HTMLDivElement />
 * or, if not an event:
 * NOT EVENT??? object TypeError TypeError: some error is not an event
 */
export function showEvent(event?: any, prefix = '') : string
{
	let result;
	const bits = [];

	/**
	 * answer with the event key name if the value is truthy. calls the value first if it's a function.
	 */
	function show(key: string): string
	{
		let out = '';
		let value;
		try
		{
			value = event[key];
			if (typeof value === 'function') {
				value = value();
			}
			out = value
				? `${key} `
				: '';
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		} catch (exception) {
			console.warn(`EXCEPTION showEvent#show[${exception}]`);
		}
		return out;
	} // show()
	/**
	 * answers with the key(value) pair calling the value first if it's a function.
	 */
	function showVal(key : string) : string
	{
		let value = event[key];
		if (typeof value === 'function') {
			value = value();
		}
		return value
			? `${key}(${value}) `
			: '';
	} // showVal()
	/**
	 * answers with value of keyX,keyY as keyXY(xxx,yyy) or empty string if they are both zero.
	 */
	function showXY(key: string): string
	{
		const x = event[`${key}X`];
		const y = event[`${key}Y`];
		return x || y
			? `${key}XY(${x || 0},${y || 0})`
			: '';
	} // showXY()

	try
	{
		if (event.dispatchConfig) {
			bits.push(
				`EVENT `,
				getTypeName(event.nativeEvent),
				`${event.type}/@${event.timestamp} `,
				Object.values(event.dispatchConfig.phasedRegistrationNames).join(' '),
				' ',
				showVal('eventPhase'),
				show('isTrusted'),
				show('bubbles'),
				show('cancellable'),
				show('defaultPrevented'),
				show('isPersistent'),
				show('isDefaultPrevented'),
				show('isPropagationStopped'),
				'\n',
				showVal('details'), // TODO details???
				show('metaKey'),
				show('ctrlKey'),
				show('shiftKey'),
				show('altKey'),
				// show('getModifierState'), // TODO getModifierState???
				'\n',
				show('button'),
				show('buttons'),
				showXY('screen'),
				showXY('client'),
				showXY('page'),
				showXY('movement')
			);
		} // if event.dispatchConfig
		if (event.target) {
			bits.push('\ntarget: ', getElementInfo(event.target));
		}
		if (event.currentTarget) {
			bits.push('\ncurrentTarget: ', getElementInfo(event.currentTarget));
		}
		if (event.relatedTarget) {
			bits.push('\nrelatedTarget: ', getElementInfo(event.relatedTarget));
		}
		if (event.view) {
			// TODO view(null)
			bits.push(`\nview: ${typeof event.view} ${getTypeName(event.view)} ${showThing(event.view)}`);
		} // if event.view
		// eslint-disable-next-line @typescript-eslint/no-unused-vars
	} catch (ignore) {
		// console.warn(`EXCEPTION2 showEvent[${exception}]`)
	} finally
	{
		result = bits.filter((item) => !!item);
		if (result.length) {
			if (prefix) {
				result.unshift(prefix);
			}
			result = result
				.join('')
				.replace(/\n *\n/g, '\n')
				.replace(/\n+/g, '\n');
		} else {
			result = `${prefix}NOT EVENT??? ${typeof event} ${getTypeName(event)} ${showThing(event)}`;
		} // if length
	} // finally
	return result;
} // showEvent()
