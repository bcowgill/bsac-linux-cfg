// testingTools.ts - a collection of tools for testing react applications with jest and @testing-library/react

export * from "@testing-library/react";


export type IElementMatcher = RegExp | string;
export type IElementLocator = Element | IElementMatcher | number;
export type IElementList    = HTMLCollectionOf<any> | NodeListOf<any> | HTMLElement[];

const FLIP = false; // true to reverse which attributes are shown in getTextNice()

const NL = "{NL}";
const TAB = "\t";
const SPC = "[SPACE]";
const reAllowId = /^(csl-dialog-desc\d+)$/;
const reElemId = /<[^>]+?\s+id="([^"]*)"[^>]*>/gi;
const reAttrsBoolean = /\b(focusable|aria-(hidden|modal|invalid)|data-(focus-guard|focus-lock-disabled|autofocus-inside))="(true|false)"/gi;
const reBoolean = /false|true/gi;
const reMissingMoney = /[£$][^\d\s]/gi;
const reStringified = /undefined|null|\bNaN\b|Infinity|\[object Object\]|function /gi;
const reAttrsToShow = /^(id|name|type|role|target|rel|disabled|focusable|hidden|width|height|tabindex|fortitle|placeholder|alt|href|(data|aria)-.+)$/i;
// show class and style also, more noisy but may be useful in some cases.
//const reAttrsToShow = /^(class|style|id|name|type|role|target|rel|disabled|focusable|hidden|width|height|tabindex|fortitle|placeholder|alt|href|(data|aria)-.+)$/i;

// Match element indexing and going up the parent tree: [+/-NNN]^^^@LIST
const reIndexUp = /\s*(?:\[([+-]?\d+)\])?\s*(\^*)\s*(@LIST)?\s*$/i;

const reSpaces = /[\s\u20\uA0\u202F\uFEFF\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u200B\u205F\u3000\u303F\uE0020]/g;

const reSpacesHyphens = /[\s\u20\uA0\u202F\uFEFF\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u200B\u205F\u3000\u303F\uE0020\uAD\u2010\u2011\u2027\uFE63\uFF0D\uE002D]/g;

const spaceMap = {
	'\u20': '[SPACE]',
	'\uA0': '[NBSP]',
	'\u202F': '[NARROWNBSP]',
	'\uFEFF': '[ZERONBSP]',
	'\u2000': '[ENQUAD]',
	'\u2001': '[EMQUAD]',
	'\u2002': '[ENSPACE]',
	'\u2003': '[EMSPACE]',
	'\u2004': '[THREEPEREMSPACE]',
	'\u2005': '[FOURPEREMSPACE]',
	'\u2006': '[SIXPEREMSPACE]',
	'\u2007': '[FIGURESPACE]',
	'\u2008': '[PUNCTSPACE]',
	'\u2009': '[THINSPACE]',
	'\u200A': '[HAIRSPACE]',
	'\u200B': '[ZEROSPACE]',
	'\u205F': '[MEDMATHSPACE]',
	'\u3000': '[IDEOGRAPHICSPACE]',
	'\u303F': '[IDEOGRAPHICHALFFILLSPACE]',
	'\uE0020': '[TAGSPACE]',
	'\uAD': '[SOFTHYPHEN]',
	'\u2010': '[HYPHEN]',
	'\u2011': '[NBHYPHEN]',
	'\u2027': '[HYPHENPOINT]',
	'\uFE63': '[SMALLHYPHEN]',
	'\uFF0D': '[FULLWIDTHHYPHEN]',
	'\uE002D': '[TAGHYPHEN]',
}; // spaceMap

let foundAt = "ELEMENT";

/**
 * get/set where the getEl() found its element at.
 * @param here {string} if provided, sets where element was found.
 * @returns {string} current value of foundAt.
 */
export function elementAt(here?: string): string {
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
export function trace(...args) {
	if (process.env.TRACE) {
		console.warn("TRACE", ...args);
	}
}

/**
 * will log a function by mock name or actual name.
 * @param where {string} unique string to locate a position within the tests.
 * @param fnMock a real function or jest.fn mock, the name of the mock will be logged or the actual function name.
 */
export function logMock(where = "LOG MOCK" fnMock: ReturnType<typeof jest.fn>) {
	if (fnMock.getMockName) {
		console.warn(`logMock(${where}) MOCKED: ${fnMock.getMockName()}`);
	} else {
		console.warn(`logMock(${where}) NOT MOCKED: ${fnMock.name}`);
	}
} // logMock()

/**
 * assert a test that the element or document is empty of text (may contain elements though).
 * @param element {HTMLElement} the element to check for emptiness. defaults to the entire document.body.
 */
export function checkDocumentTextEmpty(element: HTMLElement = document.body) {
	expect(element.innerHTML.replace(/<[^>]+>/g, "")).toBe("");
}

/**
 * assert that all id= attributes in the document contain the app-specific prefix so they will be unique on the page.
 * @param element {HTMLElement} the element to check for id= attributes. defaults to the entire document.body.
 * @param prefix {string} the string to check for presence in all id=attributes.  defaults to "app".
 * @returns {boolean} always true so you can use it as expect(checkPageIds()).toBeTruthy()
 */
export function checkPageIds(
	element: HTMLElement = document.body,
	prefix = "app"
): boolean {
	const html = getHtml(element);
	html.replace(reElemId,
		function checkIds(openTag, name) {
			if (name.indexOf(prefix) < 0 && !reAllowId.test(name)) {
				expect(`Found in element: ${openTag}`).toBe(
					`Element with non-unique id="${name}" should contain our unique app id: ${prefix} for example: "${prefix}-${name}"`
				);
			}
			return "";
		}
	);
	return true;
} // checkPageIds()

/**
 * assert that the rendered HTML does not contain any 'undefined' values like: undefined, null, NaN or Infinity that the user might see.
 * will also check that currency markers like $ or £ are followed by actual amounts.
 * And will check that false and true havea not been accidentally stringified into the text as well, by removing boolean HTML attributes before looking.
 * @param element {HTMLElement|string} the element to check for stringifying and other coding/render errors.  defaults to the entire document.body.
 * @returns {boolean} always true so you can use it as expect(checkUndefined()).toBeTruthy()
 */
export function checkUndefined(element: HTMLElement | string = document.body): boolean {
	const html = (
		typeof element === "string" ? element : getHtmlNice(element, " ")
	)
		.replace(reAttrsBoolean, "")
		.split(/\n\n/);

	html.forEach((fragment) => {
		if (reMissingMoney.test(fragment)) {
			expect(
				`Have you missed rendering some monetary amount?\n${fragment}`
			).not.toMatch(reMissingMoney);
		}
		if (reStringified.test(fragment)) {
			expect(
				`Did you stringify something by accident?\n${fragment}`
			).not.toMatch(reStringified);
		}
		if (reBoolean.test(fragment)) {
			expect(
				`Should not be true or false, did you stringify a boolean by accident?\n${fragment}\n\nIf not, add the attribute name to the reAttrsBoolean regex to allow it to have boolean velues.`
			).not.toMatch(reBoolean);
		}
	});
	return true;
} // checkUndefined()

/**
 * gives some info about an element suitable for logging.
 * @param element {Element} will be examined for formatting nicely.
 * @returns {string} containing element tag name and attributes formatted as an HTMLElement.
 */
export function elementInfo(element: Element) {
	const attrs: string[] = [];
	for (const attr of element.attributes) {
		attrs.push(`${attr.name}="${attr.value}"`);
	}

	return `<${element.tagName} ${attrs.join(" ")} />`.replace(/\s+\//, " />");
} // elementInfo()

/**
 * answers with an Element directly or by matching against whatever is rendered on the page.
 * @param element {IElementLocator} defaults to document.body. A number will return the Nth div or span in the document.
 * A RegExp or string will be matched against every query type: id, test-id, text, label, etc to find elements.
 * The string can be suffixed with [nnn]^^@LIST for more control.
 * nnn specifies which item int the matches list to return counting from beginning or end(negative)
 * each ^ indicates to go up to the parent element after getting the Nth item.
 * \@LIST if preesent will log the whole match list giving match method, element type and attributes.
 * @returns {Element} will always be returned, defaulting to document.body if no matches are found.
 */
export function getEl(element?: IElementLocator): Element {
	const isRegex = element instanceof RegExp;
	const elements: { type: string; element: Element }[] = [];
	let found = document.body as Element;
	let where = "GET EL ELEMENT ";
	if (typeof element === "number") {
		element = `div,span [${element}]`; // for querySelectorAll()
	}
	let elAsString = (element || "").toString();

	// Add found Elements to list with a type value telling how it was found adn what type of element it is.
	function accumulate(elsFount: IElementList, type: string) {
		if (elsFound.length) {
			let index = 0;
			for (const attr of elThis.attributes) {
				attrs.push(`${attr.name}="${attr.value}"`);
			}
			elements.push({
				type: `${type}#${index} ${elementInfo(elThis)}`,
				element: elThis,
			});
			++index;
		}
	} // accumulate()

	// use an Element query function to get matching Elements and add them to the list.
	function getMatches(
		name: string,
		getter: (where: IElementMatcher) => IElementList,
		getme: IElementMatcher
	) {
		let elSelector: IElementList = [];
		try {
			elSelector = getter(getme);
			accumulate(elSelector, name);
		} catch (exception) {
			trace(`EXCEPTION getEl(${elAsString}) ${name}`, exception);
		}
		return elSelector;
	} // getMatches()

	if (!isRegex && typeof element !== "string") {
		// a given element will be used or fall back to entier document
		found = (element as Element) || document.body;
		elementAt(where + elementInfo(found));
	} else {
		// String or Regex will look for matching Elements using any query function.
		let query: IElementMatcher = element as IElementMatcher;
		elAsString = query.toString();
		let index = 0;
		let up = 0;
		let dumpList = false;

		if (isRegex) {
			where = `GET EL REGEX ANY MATCH FOR ${elAsString}`;
		} else {
			// handle [nnn] indexing of the result at end of string.
			// handle ^ at end of string to go to parentElement.
			// trace(`getEl parse ${elAsString} for index ${reIndexUp.toString()}`);
			elAsString = elAsString.replace(
				reIndexUp,
				function replaceIndexint(unused, idx, levels, list) {
					if (idx) {
						index = parseInt(idx, 10);
					}
					if (levels) {
						up = levels.length;
					}
					if (list) {
						dumpList = true;
					}
					return "";
				}
			);
			query = elAsString;
			where = `GET EL FIND ANY MATCH FOR "${elAsString}" [${index}] go up ${$up}`;
		} // !isRegex

		// Match the String or RegExp using every matcher possible...
		const elTestId = getMatches("ByTestId", screen.queryAllByTestId, query);

		let elId: null | HTMLElement | HTMLElement[] =
			document.getElementById(elAsString);
		elId = elId ? [elId] : [];
		accumulate(elId as HTMLElement[], "ById");

		const elLabel = getMatches(
			"ByLabelText",
			screen.queryAllByLabelText,
			query
		);
		const elText = getMatches("ByText", screen.queryAllByText, query);
		const elTitle = getMatches("ByTitle", screen.queryAllByTitle, query);
		const elAlt = getMatches("ByAlt", screen.queryAllByAlt, query);
		const elPlace = getMatches(
			"ByPlaceholderText",
			screen.queryAllByPlaceholderText,
			query
		);
		const elValue = getMatches(
			"ByDisplayValue",
			screen.queryAllByDisplayValue,
			query
		);
		const elRole = getMatches("ByRole", screen.queryAllByRole, query);
		const elSelector = getMatches(
			"ByQuerySelector",
			screen.querySelectorAll.bind(document),
			elAsString
		);

		const elClass = document.getElementsByClassName(elAsString);
		accumulate(elClass, "ByClassName");

		trace(
			`getEl(${where}) label:${elLabel.length} value:${elValue.length} placeholder:${elPlace.length} role:${elRole.length} text:${elText.length} title:${elTitle.length} alt:${elAlt.length} testid:${elTestId.length} id:${elId.length} sel:${elSelector.length} class:${elClass.length}`
		);
		if (dumpList) {
			console.warn(
				`GET ELEMENT @LIST MATCHES: ${elements.length}`,
				elements.map((found, index) => {
					return `#${index}: ${found.type}`;
				})
			);
		}

		// look up Nth item from beginning/end and wrap around
		const length = elements.length;
		const idx = (length + (index > 0 ? index : -(-index % length))) % length;

		// trace(`getEl lookup [${index}] #${idx} of ${length}`, elements[idx]);
		if (elements[idx]) {
			found = elements[idx].element;
			where += `\nlookup @[${idx}] of ${length} matched ==> [[${elements[idx].type}]]`;
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
				up = 0;
			}
		} // while up

		// remember where we found the element
		elementAt(where);
	} // isRegex || string

	return found;
} // getEl()

/**
 * replace/remove all spaces in text for better testing visibility. Newlines are left alone.
 * @param text {string} the text to replace spaces within.
 * @param space {string} ysed to replace each non-newline space character. default is to remove spaces.
 * @returns {string} with all non-newline spaces replaced.
 */
export function replaceSpaces(text: string, space = ""): string {
	return text.replace(reSpaces, function replaceSpace(match) {
		return match === "\n" ? match : space === SPC ? spaceMap[match] || space : space;
	});
} // replaceSpaces()

// MUSTDO showSpaces
// MUSTDO replaceHyphens

/**
 * replace all unicode characters with their U+XXXX code point representation.
 * @param text {string} the text to replace characters within.
 * @returns {string} with all character codes above 255 replaced with [U+2000] format.
 */
export function replaceCharsCodePt(text: string) {
	return text.replace(/./g, function replaceCodePt(match) {
		const code = match.codePointAt(0);
		// convert code point toHex as needed.
		return code > 255 ? `[U+{code.toString(16)}]` : match;
	});
} // replaceChars()

/**
 * Get the HTML from the page or DOM element with every element open/close on a new line.
 * Useful for diffing the component after a fireEvent() to see what changed.
 * Can be compared with expect(getHtml()).toBe(previousHtml).
 * @param where {IElementLocator} optional element locator. default is document.body
 * @param space {string} used to replace each non-newline space character surrounding each element's innerText. default is '[SPACE]'.
 * @returns {string} rendered HTML with minimal formatting and surrounding spaces made visible.
 * @note see getEl() for 'where' string format to look up Nth item, parentElements and dumping the match list.
 */
export function getHtml(where?: IElementLocator, space = SPC): string {
	return (
		getEl(where)
			.innerHTML.replace(
				MUSTDO continue from here
			)
			.replace(
			)
			.replace(
			)
		// .replace(/((up to parent|no more up) -->)/g, `${NL}$1`)
			.replace(new RegExp(NL, "g"), "\n")
		.replace(/^/, elementAt() + "\n========== FOUND\n")
	);
} // getHtml()
