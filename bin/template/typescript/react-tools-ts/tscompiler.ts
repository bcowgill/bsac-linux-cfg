   // Paste this into the online typescript compiler to see if it compiles
   // ht tps://onecompiler.com/typescript/437w2qxdt
   // ht tps://onecompiler.com/typescript/438ks2z8c
   // ht tps://onecompiler.com/typescript/438rcpzk7
   // ht tps://onecompiler.com/typescript/4392uvhkz
   // ht tps://onecompiler.com/typescript/439fhhrgj
   // Global setup to simulate a browser window like environment.
   const win: any = {
	  name: "",
	  status: "",
	  defaultstatus: "",
	  defaultStatus: "",
	  origin: "htt\p://localhost",
	  closed: false,
	  isSecureContext: true,
	  originAgentCluster: false,
	  crossOriginIsolated: false,
	  length: 0,
	  devicePixelRatio: 1,
	  innerWidth: 1024,
	  innerHeight: 768,
	  outerWidth: 1024,
	  outerHeight: 768,
	  pageXOffset: 0,
	  pageYOffset: 0,
	  screenX: 0,
	  screenLeft: 0,
	  screenY: 0,
	  screenTop: 0,
	  scrollX: 0,
	  scrollY: 0,
	  screen: { // Screen
		 width: 1024,
		 height: 768,
		 availWidth: 1024,
		 availHeight: 768,
		 availLeft: 0,
		 availTop: 0,
		 colorDepth: 24,
		 pixelDepth: 24,
		 orientation: { // ScreenOrientation
			type: "landscape-primary",
			angle: 0,
			// onchange: null
		 },
	  },
	  visualViewport: { // VisualViewport
		 width: 1204,
		 height: 634,
		 offsetLeft: 0,
		 offsetTop: 0,
		 pageLeft: 0,
		 pageTop: 0,
		 scale: 1,
		 // onresize: null,
		 // onscroll: null,
	  },
	  // location: Location
	  // navigator: Navigator
	  // clientInformation: Navigator
   };

   export const NOISY = false;
   export const LET_FAIL_TESTS = false;
   export const UTF_OK = false;

   const global = win;

   function mockDocument( inner = '' ): Document
   {
	  // regex matches <a ...> </a> <hr/> <hr />
	  const text = inner.replace( /<\/?\w+[^>]*\/?>/g, ' ' );
	  const document = {
		 body: {
			tagName: 'body',
			attributes: [],
			outerHTML: `<body>${inner}</body>`,
			outerText: text,
			innerHTML: inner,
			innerText: text,
		 }
	  };
	  // console.warn(`doc`, document);
	  return document as unknown as Document;
   } // mockDocument()

   // Simulate the node/jenkins/jest testing environment.
   export const process = { env: { JENKINS_HOME: '/home/me', TRACE: Math.random() < 0.25 } };
   export const describe = () => { };
   describe.skip = () => { };
   export const test = () => { };
   test.skip = () => { };

   interface Jfnvoid extends Function
   {
	  fnuid?: number;
	  getMockName?: () => string;
   };

   export const jest: any = {};
   jest.fn = function jestMockFn( fn: Jfnvoid = () => { } ): Jfnvoid
   {
	  fn.getMockName = () => 'jest.fn.MOCKNAME';
	  return fn;
   }
   jest.useFakeTimers = function jestUseFakeTimers(): typeof jest
   {
	  return jest;
   }
   jest.setSystemTime = function jestSetSystemTime( when: Date ): typeof jest
   {
	  return jest;
   }

   export const uev: any = {};

   // react-testing-library screen mock
   function mockScreen()
   {
	  const screen = {
		 queryAllByTestId: () => [],
		 queryAllByLabelText: () => [],
		 queryAllByText: () => [],
		 queryAllByTitle: () => [],
		 queryAllByAltText: () => [],
		 queryAllByPlaceholderText: () => [],
		 queryAllByDisplayValue: () => [],
		 queryAllByRole: () => [],
	  };
	  return screen;
   } // mockScreen()
   let screen = mockScreen();

   //console.warn('this', win)

   // Define types needed
   interface Map
   {
	  entries: () => [ [ any, any ] ];
   }
   interface WeakMap
   {
	  entries: () => [ [ any, any ] ];
   }
   interface Set
   {
	  keys: () => any[];
   }
   interface WeakSet
   {
	  keys: () => any[];
   }
   namespace React
   {
	  export type ReactElement = any;
	  export type ReactNode = any;
	  export type Dispatch<T> = ( value: T ) => void;
	  export type SetStateAction<T> = ( value: T ) => void;
   }
   export type ReactElement = any;
   export type ReactNode = any;

   // A minimal unit testing library inside the tscompiler browser

   let EX_SHOW_SPACES = false;
   let EX_AS_JS = false;
   function show( what: string )
   {
	  if ( EX_AS_JS )
	  {
		 return what.replace( /\n/g, '\\n' )
			.replace( /`/g, '\`' )
			.replace( /^(.*)$/, '`$1`' );
	  }
	  return !EX_SHOW_SPACES ? what
		 : what.replace( /\n/g, '\\n' )
			.replace( /\t/g, '\\t' )
			.replace( /\f/g, '\\f' )
			.replace( /\r/g, '\\r' )
			.replace( /\v/g, '\\v' )
			.replace( /\x0d/g, '\\x0d' )
			.replace( /\x0a/g, '\\x0a' )
			.replace( /\s/g, '~' );
   } // show()

   function sameNaN( got: any, expected: any ): boolean
   {
	  if ( typeof got === 'number' && typeof expected === 'number' )
	  {
		 if ( isNaN( got ) && isNaN( expected ) )
		 {
			return true;
		 }
	  }
	  return false;
   } // sameNaN()

   const EX_QUIET = true;
   let EX_TESTED = 0;
   let EX_FAILED = 0;

   function expectToBe( got: any, expected: any, desc = 'expectToBe' ): void
   {
	  // return expect(got).toBe(expected);
	  EX_TESTED++;
	  if ( got === expected || sameNaN( got, expected ) )
	  {
		 if ( !EX_QUIET )
		 {
			console.warn( `OK ${desc}` );
		 }
	  } else
	  {
		 EX_FAILED++;
		 console.warn( `NOT OK ${desc}` );
		 console.warn( `# expected:`, show( expected ) );
		 console.warn( `#      got:`, show( got ) );
	  }
   } // expectToBe()

   function expectNotToBe( got: any, expected: any, desc = 'expectNotToBe' ): void
   {
	  // return expect(got).not.toBe(expected);
	  EX_TESTED++;
	  if ( got !== expected && !sameNaN( got, expected ) )
	  {
		 if ( !EX_QUIET )
		 {
			console.warn( `OK ${desc}` );
		 }
	  } else
	  {
		 EX_FAILED++;
		 console.warn( `NOT OK ${desc}` );
		 console.warn( `# expected different:`, got );
	  }
   } // expectNotToBe()

   function strJ( thing: any )
   {
	  return JSON.stringify( thing, void 0, 2 );
   }

   function expectToEqual( got: any, expected: any, desc = 'expectToEqual' ): void
   {
	  // return expect(got).toEqual(expected);
	  EX_TESTED++;
	  const gotStr = strJ( got );
	  const expectStr = strJ( expected );
	  if ( gotStr === expectStr )
	  {
		 if ( !EX_QUIET )
		 {
			console.warn( `OK ${desc}` );
		 }
	  } else
	  {
		 EX_FAILED++;
		 console.warn( `NOT OK ${desc}` );
		 console.warn( `# expected:`, expected );
		 console.warn( `#      got:`, got );
	  }
   } // expectToEqual()

   function expectToMatch( re: RegExp, text: string, desc = 'expectToMatch', times = 1, matchArray?: any ): void
   {
	  // return expect(text).toMatch(re);
	  EX_TESTED++;
	  const gotMatches = text.match( re );
	  const matches = ( gotMatches || [] ).length;
	  const got = strJ( gotMatches );
	  const expected = strJ( matchArray );
	  let failed = true;

	  if ( matches === times )
	  {
		 if ( matchArray )
		 {
			if ( got === expected )
			{
			   failed = false;
			}
		 } else
		 {
			failed = false;
		 }
		 if ( !failed && !EX_QUIET )
		 {
			console.warn( `OK ${desc} matches: ${times}` );
			console.warn( `#    the regex:`, re );
			console.warn( `# matched text: [${text}]` );
			if ( matchArray )
			{
			   console.warn( `#  match array:`, gotMatches );
			}
		 }
	  } // if matches === times
	  if ( failed )
	  {
		 EX_FAILED++;
		 console.warn( `NOT OK ${desc}` );
		 console.warn( `#            the regex:`, re );
		 console.warn( `#   did not match text: [${text}]` );
		 console.warn( `#     expected matches:`, times );
		 console.warn( `#          got matches:`, matches, gotMatches );
		 if ( matchArray )
		 {
			console.warn( `# expected match array:`, matchArray.length, expected );
			console.warn( `  index: ${matchArray.index},` );
			console.warn( `  input: '${matchArray.input}',` );
			console.warn( `  groups: ${matchArray.groups},` );
		 } // if matchArray
	  } // if failed
   } // expectToMatch()

   function expectNotToMatch( re: RegExp, text: string, desc = 'expectNotToMatch', times = 0 ): void
   {
	  // return expect(text).not.toMatch(re);
	  EX_TESTED++;
	  const matches = ( text.match( re ) || [] ).length;
	  if ( matches === times )
	  {
		 if ( !EX_QUIET )
		 {
			console.warn( `OK ${desc} matches: ${times}` );
			console.warn( `#          the regex:`, re );
			console.warn( `# did not match text: [${text}]` );
		 }
	  } else
	  {
		 EX_FAILED++;
		 console.warn( `NOT OK ${desc}` );
		 console.warn( `#        the regex:`, re );
		 console.warn( `#     matched text: [${text}]` );
		 console.warn( `# expected matches:`, times );
		 console.warn( `#      got matches:`, matches, text.match( re ) );
	  }
   } // expectNotToMatch()

   function expectToReplace( re: RegExp, text: string, expected: string, desc = 'expectToReplace', pattern = '1:[$1] 2:[$2] 3:[$3]' ): void
   {
	  expectToBe(
		 text.replace( re, pattern ),
		 expected,
		 desc
	  );
   } // expectToReplace()

   function expectToSplit( re: RegExp, text: string, expected: string[], desc = 'expectToSplit' ): void
   {
	  // return expect(text.split(re)).toEqual(expected);
	  const gotSplit = text.split( re );
	  const got = strJ( gotSplit );
	  const split = strJ( expected );
	  EX_TESTED++;
	  if ( got === split )
	  {
		 if ( !EX_QUIET )
		 {
			console.warn( `OK ${desc}` );
			console.warn( `#      the regex:`, re );
			console.warn( `# splil the text: [${text}]` );
		 }
	  } else
	  {
		 EX_FAILED++;
		 console.warn( `NOT OK ${desc}` );
		 console.warn( `#     the regex:`, re );
		 console.warn( `# did not split: [${text}]` );
		 console.warn( `#      expected:`, split );
		 console.warn( `#           got:`, got );
	  }
   } // expectToSplit()

   function testSummary(): void
   {
	  // return
	  const passed = EX_TESTED - EX_FAILED;
	  if ( EX_FAILED )
	  {
		 console.warn( `${EX_FAILED} failed, ${passed} passed, ${EX_TESTED} total` )
	  } else
	  {
		 console.warn( `All passed, ${EX_TESTED} total` )
	  }
   } // testSummary()

   function expect( got: any )
   {
	  return {
		 toBe: ( expected: any ) =>
		 {
			expectToBe( got, expected, `expect(${got}).toBe(${expected})` );
		 },
		 toMatch: ( expected: any ) =>
		 {
			expectToMatch( expected, got, `expect(${got}).toMatch(${expected})` );
		 },
		 toHaveAttribute: ( name: string, value: string ) =>
		 {
			const attr = got.attributes.find(( attr: any ) =>
			{
			   return attr.name === name;
			} );
			if ( attr )
			{
			   expectToBe( attr.value, value, `expect(${got}).toHaveAttribute(${name}, '${value})'` );
			} else
			{
			   expectToBe( undefined, value, `expect(${got}).toHaveAttribute(${name}, '${value}') -- attribute ${name} does not exist` );
			}
		 }, // .toHaveAttribute()
		 not: {
			toBe: ( expected: any ) =>
			{
			   expectNotToBe( got, expected, `expect(${got}).not.toBe(${expected})` );
			},
			toMatch: ( expected: any ) =>
			{
			   expectNotToMatch( expected, got, `expect(${got}).not.toMatch(${expected})` );
			},
			toHaveAttribute: ( name: string ) =>
			{
			   const attr = got.attributes.find(( attr: any ) =>
			   {
				  return attr.name === name;
			   } );
			   if ( attr )
			   {
				  expectToBe( attr.value === undefined ? 'not present' : undefined, attr.value, `expect(${got}).not.toHaveAttribute(${name}) -- attribute ${name} exists` );
			   } else
			   {
				  expectToBe( undefined, undefined, `expect(${got}).not.toHaveAttribute(${name})` );
			   }
			}, // .not.toHaveAttribute()
		 }, // .not.
	  }; // return
   } // expect()

   //==========================================================
   // testingUtils.tsx - borrowed from original in broadcast-messages-cwa repository.
   /* istanbul ignore file */
   // @ts-ignore-file
   //MUSTDO import uev from '@testing-library/user-event';
   //MUSTDO import React, { ReactNode, ReactElement } from 'react';
   //MUSTDO import {render, screen } from '@testing-library/react';

   const appId = 'app-name';

   export type FNVoid = () => void;
   export type KeyMap = Record<string, unknown>;
   export type AliasMap = Record<string, string>;
   export type MessagesMap = Record<string, string[]>;
   export type FlagMap = Record<string, boolean>;
   export type SetStateBoolean = React.Dispatch<React.SetStateAction<boolean>>;
   export type SetFlagState = ( key: string, value: boolean ) => void;

   export interface ElementWrapper
   {
	  children: ReactElement;
   }
   export interface Wrapper
   {
	  children: ReactNode;
   }

   type IElement = Element;
   export type IElementMatcher = RegExp | string;
   export type IElementLocator = IElement | IElementMatcher | number;
   export type IElementList =
	  | HTMLCollectionOf<any>
	  | NodeListOf<any>
	  | HTMLElement[];

   export interface ElementWithType
   {
	  type: string;
	  element: IElement;
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
   // let _LDQ = '"('; // “ left quote (double) UTF8
   // let _RDQ = ')"'; // ” right quote (double) UTF8
   if ( UTF_OK )
   {
	  _LS = '\xa3'; // £ pound sterling UTF8
	  _EL = '\u2026'; // … ellipsis UTF8
	  _LDQ = '\u201c'; // “ left quote (double) UTF8
	  _RDQ = '\u201d'; // ” right quote (double) UTF8
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
   const reMissingMoney = new RegExp( `[${LS}\\$][^\\d\\s]`, 'gi' ); // /[\xa3$][^\d\s]/gi;
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
	  '\u202F': '[NARROW.NBSP]',
	  '\uFEFF': '[ZERO.NBSP]',
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
	  '\u205F': '[MED.MATH.SPACE]',
	  '\u3000': '[IDEOGRAPHIC.SPACE]',
	  '\u303F': '[IDEOGRAPHIC.HALF.FILL.SPACE]',
	  //	  '\uE0020': '[TAG.SPACE]',
	  '\u00AD': '[SOFT.HYPHEN]',
	  '\u2010': '[HYPHEN]',
	  '\u2011': '[NB.HYPHEN]',
	  '\u2027': '[HYPHEN.POINT]',
	  '\uFE63': '[SMALL.HYPHEN]',
	  '\uFF0D': '[FULL.WIDTH.HYPHEN]',
   };

   export const quotesMap = {
	  paren: '()',
	  bracket: '[]',
	  brace: '{}',
	  angle: '<>',

	  sq: "''", // single quotes
	  lrsq: '\u2018\u2019', // left right single auotes

	  gq: '``', // grave quotes
	  lrgq: '`\xb4', // left right grave quotes

	  lrscq: '\u275B\u275C', // single comma quotes
	  slcq: '\u275F\u275F', // single low comma quotes
	  lrdcq: '\u275D\u275E', // double comma quotes
	  dlcq: '\u2760\u2760', // double low comma quotes

	  lrslhq: '\u201A\u201B', // single low high comma quotes
	  lrdlhq: '\u201E\u201F', // double low high comma quotes

	  lrpq: '\u2035\u2032', // prime quotes
	  lrdpq: '\u2036\u2033', // double prime quotes
	  lrwdpq: '\u2036\u2033', // wide double prime quotes
	  lrwhldpq: '\u301D\u301F', // wide high low double prime quotes
	  lrtpq: '\u2037\u2034', // triple prime quotes

	  dq: '""', // double quotes
	  wdq: '\uFF02\uFF02', // wide double quotes
	  lrdq: '\u201C\u201D', // left right double quotes

	  lrsaq: '\u2039\u203A', // single angle quotes
	  lrlsaq: '\u276E\u276F', // large single angle quotes

	  lrdaq: '\xAB\xBB', // double angle quotes
   }; // quotesMap

   // Object.values shim does not exist in browser OneCompiler
   function objValues( obj: any ): any[]
   {
	  const values = ( Object as any ).values ? ( Object as any ).values( obj ) : Object.keys( obj ).map(( key ) => obj[ key ] );
	  return values;
   }


   // MUSTDO if ES6 supported...
   //const quotesClauses = Object.values(quotesMap).map((vv) => `\\${vv[0]}\\${vv[1]}`).join('|');
   const quotesClauses = objValues( quotesMap ).map(( vv ) => `\\${vv[ 0 ]}\\${vv[ 1 ]}` ).join( '|' );

   // shortenDump()
   const reBracketedString = new RegExp( `^(${quotesClauses}|${LRDQ})$`, 'm' );
   //const reBracketedString = new RegExp(`^(${quotesClauses})$`, 'm');

   // using --runInBand for the tests on pipeline seems to have stabilised them
   // let's see if we can stop skipping these ones now...
   export const dskipIfJenkins = process.env.JENKINS_HOME
	  ? describe.skip
	  : describe;
   export const skipIfJenkins = process.env.JENKINS_HOME ? test.skip : test;

   export function noop(): void { }

   let foundAt = "ELEMENT";

   /**
	* get/set where the getEl() found its element at.
	* @param here {string} if provided, sets where element was found.
	* @returns {string} current value of foundAt.
	*/
   export function elementAt( here?: string ): string
   {
	  const where = foundAt;
	  if ( here )
	  {
		 foundAt = here;
	  }
	  return where;
   } // elementAt()

   /**
	* a console warning controlled by the TRACE= environment variable.
	* @param args warnings to show only when TRACE is defined in the environment.
	*/
   export function trace( ...args: any[] ): void
   {
	  if ( process.env.TRACE )
	  {
		 console.warn( 'TRACE', ...args );
		 // Enable below if you get error:
		 // tsc requires _ spreadArray helper from a newer version of tslib
		 // args.unshift('TRACE');
		 // es lint-disable-next-line prefer-spread
		 // console.warn.apply(console, args);
	  }
   }

   /*
	   Mock notImplementedMethod global functions.
	   ht tps://github.com/jsdom/jsdom/blob/main/lib/jsdom/browser/Window.js#L981
   */
   export function mockWindowNotImplementedMethods( win?: Window ): Window
   {
	  win = win || typeof window === 'undefined' ? global : window;
	  Object.defineProperty( win, 'alert', { value: noop, writable: true } );
	  Object.defineProperty( win, 'blur', { value: noop, writable: true } );
	  Object.defineProperty( win, 'confirm', { value: noop, writable: true } );
	  Object.defineProperty( win, 'focus', { value: noop, writable: true } );
	  Object.defineProperty( win, 'moveBy', { value: noop, writable: true } );
	  Object.defineProperty( win, 'moveTo', { value: noop, writable: true } );
	  Object.defineProperty( win, 'open', { value: noop, writable: true } );
	  Object.defineProperty( win, 'print', { value: noop, writable: true } );
	  Object.defineProperty( win, 'prompt', { value: noop, writable: true } );
	  Object.defineProperty( win, 'resizeBy', { value: noop, writable: true } );
	  Object.defineProperty( win, 'resizeTo', { value: noop, writable: true } );
	  Object.defineProperty( win, 'scroll', { value: noop, writable: true } );
	  Object.defineProperty( win, 'scrollBy', { value: noop, writable: true } );
	  Object.defineProperty( win, 'scrollTo', { value: noop, writable: true } );
	  return win;
   } // mockWindowNotImplementedMethods()

   /**
	* mocks the window location based on site brand name.
	* @param brand {string} specifies to use the URL for specified brand.
	* @example
	  expect(window.location.href).toBe("ht tp://localhost.site:3000/#/")
	  window.location.replace('ht tp://google.com')
	  expect(window.location.href).toBe('ht tp://google.com/')
	  expect(window.location.hostname).toBe('google.com')
	  expect(window.location.replace).toHaveBeenCalledTimes(1)
	  expect(window.location.reload).toHaveBeenCalledTimes(0)
	  expect(window.location.assign).toHaveBeenCalledTimes(0)
	*/
   export const mockWindowLocation = ( brand = 'site', win?: Window ): Window =>
   {
	  win = win || typeof window === 'undefined' ? global : window;
	  const host = `localhost.${brand}`;
	  const url = `htt\p://${host}:3000/#/`;
	  const urlobject = new URL( url );
	  Object.defineProperty( win, 'location', {
		 value: urlobject,
		 configurable: true,
		 writable: true,
	  } );

	  function change( url: string ): void
	  {
		 const urlobject = new URL( url );
		 const loc = win.location;
		 Object.defineProperty( win, 'location', {
			value: urlobject,
			configurable: true,
			writable: true,
		 } );
		 win.location.assign = loc.assign;
		 win.location.replace = loc.replace;
		 win.location.reload = loc.reload;
	  }

	  win.location.assign = jest.fn( change );
	  win.location.replace = jest.fn( change );
	  win.location.reload = jest.fn();
	  return win;
   };

   // re-export everything
   //MUSTDO export * from '@testing-library/react';
   export const userEvent = uev;

   //==========================================================
   // below, project specific utilities...

   //==========================================================
   // below, utils from original version...


   /**
	* will freeze time using jest Fake Timers so that any dates rendered will be the same.
	* @param when {string} a specific system time to use for unit tests. default value provided is a leap year with different numbers in all time fields.
	*/
   export function freezeTime( when = '2024-07-04 01:02:03' ): Date
   {
	  const date = new Date( when );
	  jest.useFakeTimers().setSystemTime( date );
	  return date;
   }

   /**
	* will log a function by mock name or actual name.
	* @param where {string} unique string to locate a position within the tests
	* @param fn {function | jest.Mock} a function to log the mock name, if exists or function name if not.
	*/
   export function logMock(
	  where = 'LOG MOCK',
	  fn: ReturnType<typeof jest.fn>
   ): void
   {
	  if ( fn.getMockName )
	  {
		 console.warn( `logMock(${where}) MOCKED: ${fn.getMockName()}` );
	  } else
	  {
		 console.warn( `logMock(${where}) NOT MOCKED: ${fn.name}` );
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
	  '\\',
   ].join( '|\\' );
   const SRE = new RegExp( '(\\' + regexMeta + ')', 'g' );
   /**
	* answers with a string which has all regular expression meta characters escaped correctly.
	* @param stringToRegex {string} a string to convert to a regular expression safely.
	* @returns {string} with all regular expression special characters escaped.
	* @note Equivalent to perl's quotemeta() function.
	* ht tps://simonwillison.net/2006/Jan/20/escape/
	*/
   export function quotemeta( stringToRegex: string ): string
   {
	  return stringToRegex.replace( SRE, '\\$1' );
   }

   /**
	* assert a test that the element or document is empty of text (may contain elements though).
	* @param element (HTMLElement} the element to check for emptiness. defaults to the entire document.body.
	*/
   export function checkDocumentTextEmpty(
	  element: HTMLElement = document.body,
   ): true
   {
	  expect(
		 element.innerHTML.replace( reVersionNickname, '' ).replace( reDocTextEmpty, '' )
	  ).toMatch( /^\s*$/ );
	  return true;
   }

   /**
	* assert that all id= attributes in the document contain the appId so they will be unique on the page.
	* @param element {HTMLElement|string} the element or raw HTML to check for id= attributes. defaults to the entire document.body.
	* @param prefix {string} the string to check for presence in all id= attributes. defaults to the app's appId.
   */
   export function checkPageIds(
	  element: HTMLElement | string = document.body,
	  prefix = appId
   ): true
   {
	  const html = getHtml( element );
	  html.replace( reElemWithId, function checkIds( openTag: string, name: string )
	  {
		 if ( name.indexOf( prefix ) < 0 && !reAllowId.test( name ) )
		 {
			expect( `Found in element: ${openTag}` ).toBe(
			   `Element with non-unique id="${name}" should contain our unique app id: ${prefix} for example: "${prefix}-${name}"`
			);
		 }
		 return '';
	  } );
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
   export function checkUndefined(
	  element: HTMLElement | string = document.body
   ): true
   {
	  const html = (
		 typeof element === 'string' ? element : getHtmlNice( element, ' ' )
	  )
		 .replace( reAttrsBoolean, '' )
		 .split( /\n\n/ );

	  html.forEach(( fragment ) =>
	  {
		 if ( reMissingMoney.test( fragment ) )
		 {
			expect(
			   `Have you missed rendering some monetary amount?\n${fragment}`
			).not.toMatch( reMissingMoney );
		 }
		 if ( reStringified.test( fragment ) )
		 {
			expect(
			   `Did you stringify something by accident?\n${fragment}`
			).not.toMatch( reStringified );
		 }
		 if ( reBoolean.test( fragment ) )
		 {
			expect(
			   `Should not be true or false, did you stringify a boolean by accident?\n${fragment}\n\nIf not, add the attribute name to the reAttrsBoolean regex to allow it to have boolean values.`
			).not.toMatch( reBoolean );
		 }
	  } );
	  return true;
   } // checkUndefined()

   /**
	* answers with the identifying HTML attributes useful for getByTestId calls when testing the rendered output.
	* @param html {string} Some HTML from getHtml, getHtmlNice, or getTextNice or elsewhere.  defaults to getHtmlNice() output.
	* @returns a string listing of the relevant identifying attributes present across all elements.
	*/
   export function getIdentity( html: string = getHtmlNice() ): string
   {
	  const ids: string[] = [];

	  html.replace( reAttrIdentity, function findIds( unused, one ): string
	  {
		 ids.push( TAB + one );
		 return '';
	  } );

	  return ids.join( '\n' );
   } // getIdentity()

   /**
	* used to write your content verification tests for your after rendering a test component.
	* @param where {IElementLocator} optional element locator. default is document.body
	* @param space {string} used to replace each non-newline space character surrounding each element's innerText. default is '[SPACE]'
	* @returns {string} of expect().toBeInTheDocument() code to verify all the rendered text.
	*/
   export function getExpectations( where?: IElementLocator, space = SPC ): string
   {
	  const titles: string[] = [];
	  const labels: string[] = [];
	  const values: string[] = [];
	  const IND = '    ';
	  const CW = 'con\sole.warn';

	  const result = ( '\n\n// render() your component...\n' +
		 `${CW}('IDENTITY', getIdentity());\n` +
		 `const before = getHtmlNice();\n` +
		 `${CW}('RENDER', before);\n` +
		 `expect(checkUndefined()).toBeTruthy();\n` +
		 `expect(checkPageIds()).toBeTruthy();\n` +
		 `expect(checkDocumentTextEmpty()).toBeTruthy();\n` +
		 `expect(checkDialogOpen(dialog)).toBeTruthy();\n` +
		 getHtml( where, space )
			.replace( reLineBeforeElement, `$1\n<` ) // extra lines around text and indent elements
			.replace( reLineBeforeText, '>\n$1' ) // extra lines around text
			.replace( reAttribute, function replaceAttr( match, name, value )
			{
			   if ( name === 'title' )
			   {
				  titles.push(
					 `expect(screen.queryByTitle(` + value + ')).toBeInTheDocument();\n'
				  );
			   } else if ( name === 'aria-label' )
			   {
				  labels.push(
					 `expect(screen.queryByLabelText(` +
					 value +
					 ')).toBeInTheDocument();\n'
				  );
			   } else if ( name === 'value' )
			   {
				  values.push(
					 `expect(screen.queryByDisplayValue(` +
					 value +
					 ')).toBeInTheDocument();\n'
				  );
			   }
			   return '';
			} ) // remove all attributes in elements
			.replace( reElemNoAttr, '' ) // now remove all the elements
			.replace( reMultiSpaced, '\n' ) // and mult-line spacing
			.replace( reNicePreamble, '' )
			.replace( reInitialLineSpaces, 'expect(screen.queryByText(RE[' )
			.replace( reNewLines, ']ER)).toBeInTheDocument();\n' )
			.replace( reExpectStraggler, '' )
			.replace( reEmbeddedRE, function toRegex( full, string )
			{
			   const quoted = quotemeta( string.replace( reSpaceMarker, '' ) );
			   return quoted ? `/^\\s*${quoted}\\s*$/m` : 'BLANKBLANK';
			} ).replace( reRemoveBlankExpects, '' ) +
		 [ ...titles, ...labels, ...values ].join() +
		 `// await userEvent.click()...\n` +
		 `let after;\n` +
		 `await waitFor(() => {\n` +
		 `${IND}after = getHtmlNice();\n` +
		 `${IND}expect(after).not.toBe(before);\n` +
		 `});\n` +
		 `// will show only what has changed in the HTML due to the user event.\n` +
		 `expect(after).toBe(before);\n`
	  );
	  return result.replace( /\n/g, `\n${IND}` );
   } // getExpectations()

   /**
	* this will check if a constellation/core Dialog component is open.
	* @param dialog {HTMLElement} the dialog as returned by a getByTestId() or similar test matcher.
	* @returns boolean {true} so you can expect(checkDialogopen(...)).toBe(true)
	*/
   export function checkDialogOpen( dialog: HTMLElement ): true
   {
	  expect( dialog ).toHaveAttribute( 'role', 'dialog' );
	  // depends on version of constellation
	  expect( dialog ).toHaveAttribute( 'aria-modal', 'true' );
	  expect( dialog ).toHaveAttribute( 'aria-hidden', 'false' );
	  expect( dialog ).not.toHaveAttribute( 'hidden' );
	  expect( window.getComputedStyle( dialog ).visibility ).toBe( 'visible' );
	  return true;
   } // checkDialogOpen()

   /**
	* this will check if a constellation/core Dialog component is closed.
	* @param dialog {HTMLElement} the dialog as returned by a getByTestId() or similar test matcher.
	* @returns boolean {true} so you can expect(checkDialogClosed(...)).toBe(true)
	* @note closed dialogs are still in the DOM, just made not visible.
	*/
   export function checkDialogClosed( dialog: HTMLElement ): true
   {
	  expect( dialog ).toHaveAttribute( 'role', 'dialog' );
	  // depends on version of constellation
	  expect( dialog ).toHaveAttribute( 'aria-modal', 'true' );
	  expect( dialog ).toHaveAttribute( 'aria-hidden', 'true' );
	  expect( dialog ).toHaveAttribute( 'hidden', '' );
	  expect( window.getComputedStyle( dialog ).visibility ).toBe( 'visible' );
	  return true;
   } // checkDialogClosed()


   /**
	* a document.getElementById() function that also works with jest/react-dom using document.querySelector() instead.
	* @param {string} id The id value for the element to locate in the DOM.
	* @returns {null | HTMLElement} The element with the id value specified or null.
	*/
   export function getElementById( id: string ): null | HTMLElement
   {
	  let found = null;
	  try
	  {
		 try
		 {
			found = document.getElementById( id );
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		 } catch ( ignore ) { }
		 found = found || document.querySelector<HTMLElement>( `#${id}` );
		 // eslint-disable-next-line @typescript-eslint/no-unused-vars
	  } catch ( ignore ) { }
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
   export function getHtml( where?: IElementLocator, space = 'INDICATE' ): string
   {
	  return (
		 getEl( where )
			.innerHTML.replace(
			reSplitAfterElement,
			function splitElementsAfter( unused, after )
			{
			   return `>${NL}${showSpaces( after, space )}`;
			}
			)
			.replace(
			reSplitBeforeElement,
			function splitElementsBefore( unused, before )
			{
			   return `${showSpaces( before, space )}${NL}<`;
			}
			)
			.replace(
			reSplitBetweenElement,
			function splitElementsBetween( unused, between )
			{
			   return `>${NL}${showSpaces( between, space )}${NL}<`;
			}
			)
			// .replace(/((up to parent no more up) -->)/g, `${NL}$1`)
			.replace( new RegExp( NL, 'g' ), '\n' )
			.replace( /^/, elementAt() + '\n========== FOUND\n' )
	  );
   } // getHtml()

   /**
	* replace/remove all spaces in text for better testing visibility. Newlines are left alone.
	* @param text {string} the text to replace spaces within.
	* @param space {string} used to replace each non-newline space character. default is to remove spaces.
	* @returns {string} with all non-newline spaces replaced.
	*/
   export function replaceSpaces( text: string, space = '' ): string
   {
	  return text.replace( /\s/g, function replacespace( match )
	  {
		 return match === '\n' ? match : space;
	  } );
   } // replaceSpaces()

   /**
	* Show the leading and trailing spaces in some text for better testing visibility. Newlines are left alone.
	* @param text {string} the text to replace spaces within multiline text.
	* @param space {string} used to replace each non-newline space character. default is '[SPACE]'
	* if space is 'INDICATE' then indicateSpaces() and replaceCharsCodePt() functions will be used instead.
	* @returns {string} with all leading and trailing non-newline spaces replaced (or all spaces indicated by indicateSpaces()).
	*/
   export function showSpaces( text: string, space = SPC ): string
   {
	  if ( space === 'INDICATE' )
	  {
		 return replaceCharsCodePt( indicateSpaces( text ) );
	  }
	  return text.replace(
		 reOuterSpaces,
		 function replaceOuterSpaces( unused, leading, middle, trailing )
		 {
			return (
			   replaceSpaces( leading, space ) + middle + replaceSpaces( trailing, space )
			);
		 }
	  );
   } // showSpaces()

   /**
	* answers with all character codes above 255 replaced by U+NNNN unicode markers.
	* @param text {string} the text to indicate unicode code points explicitly.
	* @returns {string} the text with unicode code points replaced with U+NNNN.
	*/
   function replaceCharsCodePt( text: string ): string
   {
	  return text.replace( /./g,
		 function replaceCodePt( match: string ): string
		 {
			const code = match.charCodeAt( 0 );
			return code > 255 ?
			   `[U+${code.toString( 16 ).toUpperCase()}]` : match;
		 }
	  );
   } // replaceCharsCodePt()

   /**
	* answers with string replacing all white space and hyphens with [TAB] [NBSP] markers for easier debugging.
	* single spaces are left alone but multple runs of spaces are shown as [SPx5].
	* @param text {string} the text to indicate where white spaces and hyphens are.
	* @returns {string} the text with spaces indicated throughout.
	* @note Newlines, form feeds and other characters will be replaced with a marker and a newline so that
	* they still break the string into multiple lines but you will be able to see end of line marker inconsistencies.
	*/
   function indicateSpaces( text: string ): string
   {
	  let out = text.replace(
		 reSpacesHyphens,
		 function myReplaceSpaceHyphen( match: string ): string
		 {
			return match === ' ' ? ' '
			   : ( spaceMap[ match ] || `[MISSING U+${match.charCodeAt( 0 ).toString( 16 )}]` );
		 }
	  );
	  return out.replace( /  +/g, function myReplaceSpaces( match: string ): string
	  {
		 return `[SPx${match.length}]`;
	  } );
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
   export function getHtmlNice( where?: IElementLocator, space = 'INDICATE' ): string
   {
	  return (
		 getHtml( where, space )
			// indent element attributes on own line
			.replace( reIndentElemAttr, `\n${TAB}$2` )
			// indent element styles deeper on own line
			.replace( reStyleAttr, function replaceStyles( unused, styles )
			{
			   return `styles="\n${TAB}${TAB}${styles.replace( reEndingSemi, '' ).split( reSemiSpaces ).join( `;\n${TAB}${TAB}` )}\n${TAB}"`;
			} )
			.replace( reBlankLines, '\n\n' ) // remove excess newlines
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
   export function getTextNice( where?: IElementLocator, space = 'INDICATE' ): string
   {
	  return (
		 getHtml( where, space )
			.replace( reLineBeforeElement, `$1\n${TAB}<` ) // extra lines around text and indent elements
			.replace( reLineBeforeText, '>\n$1' ) // extra lines around text
			// remove most element attributes except identifying ones...
			.replace( reAttribute, function replaceAttribute( unused, attr, value )
			{
			   let show = reAttrsToShow.test( attr );
			   show = FLIP ? !show : show;
			   return show ? `\n${TAB}${TAB}${attr}=${value}` : '';
			} )
			.replace( reExtraSpacesElem, '>' ) // <h > cuddle up the spaces in elements
			.replace( rePlainElem, '' ) // strip out simple <name> </name> elements with no attributes
			.replace( reBlankLines, '\n\n' ) // remove excess newlines
	  );
   } // getTextNice()

   /**
	* interate through a collection or array(type C) of elements or attributes(type T) as the case may be.
	* @param collection {C} A colleciton or array of elements or attributes.
	* @param fn {(item: T, index: number) => void} A callback to process an element or attribute from the collection.
	* @note Handles error: Type 'NamedNodeMap' can only be iterated through when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.ts(2802)
	*/
   export function forOf<C, T>(
	  iterable: C,
	  fn: ( item: T, index: number ) => void
   ): void
   {
	  let loop = 0;
	  const collection = iterable as unknown as T[];
	  try
	  {
		 // @ts-expect-error TS2802: Type 'IElementList' can only be iterated through when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.
		 // @ts-expect-error TS2495: Type 'IElementList' is not an array type or a string type.
		 for ( const item of collection )
		 {
			++loop;
			fn( item, loop - 1 );
		 }
	  } catch ( exception )
	  {
		 if ( loop )
		 {
			throw exception;
		 }
		 for ( let index = 0; index < collection.length; index++ )
		 {
			fn( collection[ index ], index );
		 }
	  }
   } // forOf()

   /**
	* gives some info about an element suitable for logging.
	* @param element {Element} will be examined for formatting nicely.
	* @returns {string} containing element tag name and attributes formatted as an HTMLElement.
	*@note borrowed from original in broadcast-messages-cwa repository.
	*/
   export function elementInfo( element: IElement ): string
   {
	  const attrs: string[] = [];
	  // Type 'NamedNodeMap' can only be iterated through when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.ts (2802)
	  forOf<NamedNodeMap, Attr>( element.attributes, ( attr ) =>
	  {
		 // console.warn(`forOf1 proto:, Object.getPrototypeOf(attr), `\n   attr:`, attr);
		 attrs.push( `${attr.name}="${attr.value}"` );
	  } );

	  return `<${element.tagName} ${attrs.join( ' ' )} />`.replace(
		 reExtraSpacesClosureElem,
		 ' />'
	  );
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
   export function getEl( element?: IElementLocator, suffix?: string ): IElement
   {
	  const isRegex = element instanceof RegExp;
	  const elements: ElementWithType[] = [];
	  let found = document.body as Element;
	  let where = 'GET EL ELEMENT ';
	  elementAt( 'ELEMENT' );
	  if ( typeof element === 'number' )
	  {
		 element = `div,span [${element}]`; // for querySelectorAll()
	  }

	  let elAsString = ( element || '' ).toString();
	  if ( reRawHtml.test( elAsString ) )
	  {
		 where = 'GET EL RAW HTML STRING';
		 elementAt( where );
		 // @ts-expect-error TS2740 Type '{innerHTML: string; }' is missing the following properties from type 'Element': attributes, class List, className, clientHeight
		 return { innerHTML: elAsString } as IElement;
	  }

	  // Add found Elements to list with a type value telling how it was found and what type of element it is.
	  function accumulate( elsFound: IElementList, type: string ): void
	  {
		 if ( elsFound.length )
		 {
			// Type 'IElementList' can only be iterated through when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.ts(2802)
			forOf<IElementList, HTMLElement>( elsFound, ( elThis, index ) =>
			{
			   // console.warn(`forof2 proto:, Object.getPrototypeOf(elThis), `\n   elThis:`, elThis);
			   const attrs: string[] = [];
			   // Type 'NamedNodeMap' can only be iterated through when using the '--downlevelIteration' flag or with a '--target' of 'es2015' or higher.ts(2802)
			   forOf<NamedNodeMap, Attr>( elThis.attributes, ( attr ) =>
			   {
				  // console.warn(`forof3 proto:`, Object.getPrototypeOf(attr), `\n   attr: `, attr);
				  attrs.push( `${attr.name}="${attr.value}"` );
			   } );
			   elements.push( {
				  type: `${type}#${index} ${elementInfo( elThis )}`,
				  element: elThis,
			   } );
			} );
		 }
	  } // accumulate()

	  type Suffixes = [ number, number, boolean, string ];
	  // parse the [nnn]^^^@LIST values from the suffix.
	  function getSuffix( suffix: string ): Suffixes
	  {
		 let index = 0;
		 let up = 0;
		 let dumpList = false;

		 suffix = suffix.replace(
			reIndexUp,
			function replaceIndexing( unused, idx, levels, list )
			{
			   if ( idx )
			   {
				  index = parseInt( idx, 10 );
			   }
			   if ( levels )
			   {
				  up = levels.length;
			   }
			   if ( list )
			   {
				  dumpList = true;
			   }
			   return '';
			}
		 );

		 return [ index, up, dumpList, suffix ];
	  }

	  // Use an Element query function to get matching Elements and add them to the list.
	  function getMatches(
		 name: string,
		 getter: ( where: IElementMatcher ) => IElementList,
		 getme: IElementMatcher
	  ): IElementList
	  {
		 let elSelector: IElementList = [];
		 try
		 {
			elSelector = getter( getme );
			accumulate( elSelector, name );
		 } catch ( exception )
		 {
			trace( `EXCEPTION getEl(${elAsString}) ${name}`, exception );
		 }
		 return elSelector;
	  } // getMatches()

	  if ( !isRegex && typeof element !== 'string' )
	  {
		 // a given element will be used or fall back to entire document
		 found = ( element as IElement ) || document.body;
		 // console.warn(`getEl found`, found);
		 elementAt( where + elementInfo( found ) );
	  } else
	  {
		 // String or Regex will look for matching Elements using any query function.
		 let query: IElementMatcher = element as IElementMatcher;
		 elAsString = query.toString();

		 // handle [nnn] indexing of the result at end of string or in suffix parameter.
		 // handle ^ at end of string to go to parentElement.
		 // trace(`getEl parse ${elAsString} for index ${reIndexUp.toString()}`);
		 let index = 0;
		 let up = 0;
		 let dumpList = false;

		 if ( isRegex )
		 {
			where = `GET EL REGEX ANY MATCH FOR ${elAsString}`;
			if ( suffix )
			{
			   [ index, up, dumpList ] = getSuffix( suffix );
			   where += ` [${index}] go up ${up}`;
			}
		 } else
		 {
			let query;
			[ index, up, dumpList, query ] = getSuffix( elAsString );
			if ( query === elAsString && suffix )
			{
			   [ index, up, dumpList ] = getSuffix( suffix );
			}
			elAsString = query;
			where = `GET EL FIND ANY MATCH FOR "${elAsString}" [${index}] go up ${up}`;
		 } // !isRegex

		 // Match the String or RegExp using every matcher possible...
		 const elTestId = getMatches( 'ByTestId', screen.queryAllByTestId, query );
		 let elId: null | HTMLElement | HTMLElement[] = getElementById( elAsString );
		 elId = elId ? [ elId ] : [];
		 accumulate( elId as HTMLElement[], 'ById' );

		 const elLabel = getMatches(
			'ByLabelText',
			screen.queryAllByLabelText,
			query
		 );
		 const elText = getMatches( 'ByText', screen.queryAllByText, query );
		 const elTitle = getMatches( 'ByTitle', screen.queryAllByTitle, query );
		 const elAlt = getMatches( 'ByAltText', screen.queryAllByAltText, query );
		 const elPlace = getMatches(
			'ByPlaceholderText',
			screen.queryAllByPlaceholderText,
			query
		 );
		 const elValue = getMatches(
			'ByDisplayValue',
			screen.queryAllByDisplayValue,
			query
		 );
		 const elRole = getMatches( 'ByRole', screen.queryAllByRole, query );

		 const elSelector = getMatches(
			'ByQuerySelector',
			document.querySelectorAll.bind( document ),
			elAsString
		 );

		 const elClass = document.getElementsByClassName( elAsString );
		 accumulate( elClass, 'ByClassName' );

		 trace(
			`getEl(${where}) label:${elLabel.length} value:${elValue.length} placeholder:${elPlace.length} role:${elRole.length} text:${elText.length} title:${elTitle.length} alt:${elAlt.length} testid:${elTestId.length} id:${elId.length} sel:${elSelector.length} class:${elClass.length}`
		 );
		 if ( dumpList )
		 {
			console.warn(
			   `GET ELEMENT @LIST MATCHES: ${elements.length}`,
			   elements.map(( found, index ) =>
			   {
				  return `#${index}: ${found.type}`;
			   } )
			);
		 }

		 // look up Nth item from beginning/end and wrap around
		 const length = elements.length;
		 const idx = ( length + ( index > 0 ? index : -( -index % length ) ) ) % length;

		 // trace(`getEl lookup [${index}] #${idx} of ${length}`, elements[idx]);
		 if ( elements[ idx ] )
		 {
			const elFirst = elements[ idx ] as ElementWithType;
			found = elFirst.element;
			where += `\nlookup @[${idx}] of ${length} matched ==> [[${elFirst.type}]]`;
		 } else
		 {
			where += `\nNOTHING FOUND, using <BODY />`;
			found = document.body;
		 }

		 // process each ^ for parent element
		 while ( up )
		 {
			if ( found.parentElement )
			{
			   found = found.parentElement;
			   where += `\nup to parent --> ${elementInfo( found )} `;
			   up--;
			} else
			{
			   where += `\nno more up --> `;
			   up = 0;
			}
		 } // while up

		 // remember where we found the element
		 elementAt( where );
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
   export function getTypeName( thing: unknown ): string
   {
	  try
	  {
		 const type = typeof thing;
		 if ( Array.isArray( thing ) )
		 {
			return 'Array ';
		 } else if ( thing === null )
		 {
			return 'Object ';
		 } else if ( thing instanceof RegExp )
		 {
			return 'RegExp ';
		 } else if ( thing instanceof Boolean )
		 {
			return 'Boolean ';
		 } else if ( thing instanceof Number )
		 {
			return 'Number ';
		 } else if ( thing instanceof String )
		 {
			return 'String ';
		 } else if ( thing instanceof Date )
		 {
			return 'Date ';
		 } else if ( type === 'function' )
		 {
			return 'Function ';
		 } else if ( /^(boolean|number|string|undefined)$/.test( type ) )
		 {
			return '';
		 }
		 const proto = Object.getPrototypeOf( thing );
		 const name = proto.name ? proto.name : proto;
		 // stringifying like this works better to get the type name.
		 return [ name, '' ].join( ' ' ).replace( /\[object ([^\]]+)\]/, '$1' );
	  } catch ( exception )
	  {
		 return `EXCEPTION getTypeName[${exception}]`;
	  }
	  return '';
   } // getTypeName()

   /*
		   MUSTDO
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

   /**
	* answer with the text surrounded by quotes of a specific type.
	* @param text {string} the text which needs to be surrounded by quotes.
	* @param quotes {string} a name from quotesMap or a 1-2 character long string indicating which quote characters to use to surround the text.
	*/
   export function enquote( text: string, quotes = 'lrdq' )
   {
	  quotes = quotesMap[ quotes ] || quotes;
	  return quotes[ 0 ] + text + quotes[ quotes.length - 1 ];
   }

   /**
	   * answers with a shortened string when it exceeds the given length. Ellipsis will be added to show omitted characters.
	   * @param dump {string}
	   * @param MAX_LENGTH {number} the maximum number of relevant characters to show from the dump string.
	   * @param quotes {string} quote characters to use to surround the dump string, if provided. ie '""'
	   * @returns {string} the string with an ellipisis to show missing characters if needed.
	   * @note when shortened, the ellipsis will be at the end of the string, but inside any brackets or existing quotes.
	   */
   export function shortenDump( dump: string, MAX_LENGTH = MAX_THING, quotes = '' ): string
   {
	  const ELLIPSIS = EL;
	  if ( quotes && quotes.length < 2 )
	  {
		 quotes += quotes;
	  }
	  let wrap: string | [ string, string ] = ( dump.length < 2 || quotes ) ? '' : dump[ 0 ] + dump[ dump.length - 1 ];
	  // console.warn(`shortenDump0 q:${quotes} w:[${wrap}] ${reBracketedString} [${dump}]`)
	  if ( !reBracketedString.test( wrap ) )
	  {
		 wrap = '';
	  }
	  // console.warn(`shortenDump1 q:${quotes} w:[${wrap}] [${dump}]`)
	  const reFunctionBracket = /^function .+\}$/m;
	  if ( reFunctionBracket.test( dump ) )
	  {
		 wrap = [ 'function ', '}' ];
		 dump = dump.substring( 9, dump.length - 1 );
	  } else if ( wrap )
	  {
		 dump = dump.length <= 2 ? '' : dump.substring( 1, dump.length - 1 );
	  }
	  // console.warn(`shortenDump2 q:${quotes} w:[${wrap}] [${dump}]`)
	  if ( dump.length > MAX_LENGTH )
	  {
		 dump = dump.substring( 0, MAX_LENGTH ) + ELLIPSIS;
	  }
	  // console.warn(`shortenDump3 q:${quotes} w:[${wrap}] [${dump}]`)
	  if ( wrap )
	  {
		 dump = wrap[ 0 ] + dump + wrap[ 1 ];
	  }
	  // console.warn(`shortenDump4 q:${quotes} w:[${wrap}] [${dump}]`)
	  return quotes ? `${quotes[ 0 ]}${dump}${quotes[ 1 ]}` : dump;
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
   export function showThing( thing?: unknown, MAX_LENGTH = MAX_THING, notElem = false ): string
   {
	  const ELLIPSIS = EL;
	  const type = typeof thing;
	  const typeOf = getTypeName( thing );
	  let out = `${thing}`;
	  let showkeys = false;
	  let isArray = Array.isArray( thing );
	  const isObject = !!typeOf
		 && !/^(NaN|-?Infinity|null)$/.test( out )
		 && !/^(Boolean|Number|String|Date|RegExp) $/.test( typeOf )
		 && !( thing instanceof Error );
	  const isElement = /^(HTML\w+)?Element $/.test( typeOf ) || ( !notElem && isObject && ( '__reactInternalInstance1234' in ( thing as object ) ) );

	  // 	console.warn(`showThing ${type}/${typeOf} obj:${isObject} el:${isElement} arr:${isArray} [${out}]`);
	  try
	  {
		 if ( isElement )
		 {
			out = getElementInfo( thing );
		 } else if ( /^(Weak)?Map $/.test( typeOf ) )
		 {
			const map = {};
			for ( const entry of ( thing as Map | WeakMap ).entries() )
			{
			   map[ entry[ 0 ] ] = entry[ 1 ];
			}
			thing = map;
		 } else if ( /^(Weak)?Set $/.test( typeOf ) )
		 {
			isArray = true;
			const set = [];
			for ( const key of ( thing as Set | WeakSet ).keys() )
			{
			   set.push( key );
			}
			thing = set;
		 }

		 if ( isArray || ( isObject && !isElement && !( thing instanceof Function ) ) )
		 {
			try
			{
			   out = JSON.stringify( thing );
			   // eslint-disable-next-line @typescript-eslint/no-unused-vars
			} catch ( ignore )
			{
			   if ( isArray )
			   {
				  out = `[${out}]`;
			   } else
			   {
				  showkeys = true;
			   }
			}
		 }

		 // console.warn(`showThing2 ${type}/${typeOf} l:${out.length} sk:${showkeys} obj:${isObject} arr:${isArray} [${out}]`)
		 if ( typeOf === 'RegExp ' && out.length > MAX_LENGTH )
		 {
			const reShorten = new RegExp(
			   `^(/.{${MAX_LENGTH - 1}}).*(/[^/]*)$`,
			   'g'
			);
			out = out.replace( reShorten, `$1${ELLIPSIS}$2` );
			return out;
		 }

		 if (
			( showkeys || out.length > MAX_LENGTH ) &&
			isObject &&
			!isElement &&
			!isArray &&
			!( thing instanceof Function ) &&
			!( thing instanceof Error )
		 )
		 {
			out = Object.keys( thing as object )
			   .sort()
			   .join( ', ' );
			return `keys: [${shortenDump( out, MAX_LENGTH )}]`;
		 }
		 // eslint-disable-next-line @typescript-eslint/no-unused-vars
	  } catch ( exception )
	  {
		 return `EXCEPTION showThing[${exception}]`;
	  }

	  return shortenDump( out, MAX_LENGTH, type === 'string' || typeOf === 'String ' ? `${LDQ}${RDQ}` : '' );
   } // showThing()

   const firstDump = {
	  elementSources: `getElementInfo: Element properties shown are sourced from: [attr="pendingProps/memoizedProps/index"]`,
   };

   /**
	* answers with the value if if it's not undefined or null.
	* @param value {any} the variable to check if it has a value.
	* @returns {string|boolean|number|array|object} empty string returned if value is undefined or null.
	* undefined, null, '' => ''
	* NaN, Infinity, 0, false, everything else => returned as is
	*/
   export function has( value?: any ): string | boolean | number | object
   {
	  if ( value || /^(boolean|number)$/.test( typeof value ) )
	  {
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
   export function str( value?: unknown ): string
   {
	  if ( value || /^(boolean|number)$/.test( typeof value ) )
	  {
		 return Array.isArray( value ) ? `[${value}]` : `${value}`
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
   export function getElementInfo( element?: any, prefix = '' ): string
   {
	  const bits = [];

	  interface IRElem
	  {
		 elementType: string;
		 pendingProps: Record<string, string>;
		 memoizedProps: Record<string, string>;
	  }
	  let target: IRElem;

	  // return property value by looking in a few places for the first or all found.
	  function prop( key: string ): string | boolean | number | object
	  {
		 const bits = [
			has( element[ key ] ),
			has( target ?.pendingProps && target.pendingProps[ key ]),
			has( target ?.memoizedProps && target.memoizedProps[ key ]),
		 ];
		 if ( firstDump.elementSources )
		 {
			console.warn( firstDump.elementSources );
			firstDump.elementSources = '';
		 }
		 if ( showAllPropSources )
		 {
			const joined = bits.join( '/' );
			return joined !== '//' ? joined : '';
		 }
		 return str( bits[ 0 ] ) || str( bits[ 1 ] ) || str( bits[ 2 ] );
	  }
	  // prop(key): undefined, '' => ''
	  // string => gets quotes added
	  // NaN, Infinity, 0, false, everything else => stringified with prefix/suffix added
	  function attr( key: string, prefix = '', suffix = '', quote = '' ): string
	  {
		 let value = prop( key );
		 if ( value !== '' && typeof value !== 'undefined' )
		 {
			value = typeof value === 'string' ? `${quote}${value}${quote}` : value;
			return `${prefix}${value}${suffix}`;
		 }
		 return '';
	  }
	  function attrVal( key: string ): string
	  {
		 return attr( key, `[${key}=`, `]`, '"' );
	  };

	  try
	  {
		 // MUSTDO remove the 'as any' here...
		 const targetKey = ( Object.keys( element || {} ) as any ).find(( key ) =>
			/^__reactInternalInstance/.test( key )
		 );
		 // console.warn(`getElementInfo1 tk:${targetKey}`, element)
		 target = targetKey ? element[ targetKey ] : undefined;
		 const tagName = target ? target.elementType : element ?.tagName;

		 if ( tagName )
		 {
			bits.push( `<${tagName}${attr( 'id', '#' )}` );
			attrsToShow.forEach(( attr ) =>
			{
			   bits.push( attrVal( attr ) );
			} );
			bits.push(
			   `${attr( 'className', '.', ' ' ).replace( /\s+/g, '.' )} `,
			   getTypeName( element ),
			   '/>'
			);
		 }
		 // eslint-disable-next-line @typescript-eslint/no-unused-vars
	  } catch ( exception )
	  {
		 console.warn( `Exception getElementInfo[${exception}]` )
	  }

	  if ( !bits.length )
	  {
		 bits.push(
			`NOT ELEM??? ${typeof element} ${getTypeName( element )} ${showThing(
			   element, void 0, true
			)}`
		 );
	  }
	  if ( prefix )
	  {
		 bits.unshift( prefix );
	  }

	  return bits.join( '' );
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
   export function showEvent( event?: any, prefix = '' ): string
   {
	  let result;
	  const bits = [];

	  /**
	   * answer with the event key name if the value is truthy. calls the value first if it's a function.
	   */
	  function show( key: string ): string
	  {
		 let out = '';
		 let value;
		 try
		 {
			value = event[ key ];
			if ( typeof value === 'function' )
			{
			   value = value();
			}
			out = value ? `${key} ` : '';
			// eslint-disable-next-line @typescript-eslint/no-unused-vars
		 } catch ( exception )
		 {
			console.warn( `EXCEPTION showEvent#show[${exception}]` );
		 }
		 return out;
	  } // show()
	  /**
	   * answers with the key(value) pair calling the value first if it's a function.
		*/
	  function showVal( key: string ): string
	  {
		 let value = event[ key ];
		 if ( typeof value === 'function' )
		 {
			value = value();
		 }
		 return value ? `${key}(${value}) ` : '';
	  } // showVal()
	  /**
	   * answers with value of keyX,keyY as keyXY(xxx,yyy) or empty string if they are both zero.
		*/
	  function showXY( key: string ): string
	  {
		 const x = event[ `${key}X` ];
		 const y = event[ `${key}Y` ];
		 return x || y ? `${key}XY(${x || 0},${y || 0})` : '';
	  } // showXY()

	  try
	  {
		 if ( event.dispatchConfig )
		 {
			bits.push(
			   `EVENT `,
			   getTypeName( event.nativeEvent ),
			   `${event.type}/@${event.timestamp} `,
			   // MUSTDO for ES6 enable this line...
			   // Object.values(event.dispatchConfig.phasedRegistrationNames).join(' '),
			   objValues( event.dispatchConfig.phasedRegistrationNames ).join( ' ' ),
			   ' ',
			   showVal( 'eventPhase' ),
			   show( 'isTrusted' ),
			   show( 'bubbles' ),
			   show( 'cancellable' ),
			   show( 'defaultPrevented' ),
			   show( 'isPersistent' ),
			   show( 'isDefaultPrevented' ),
			   show( 'isPropagationStopped' ),
			   '\n',
			   showVal( 'details' ), // TODO details???
			   show( 'metaKey' ),
			   show( 'ctrlKey' ),
			   show( 'shiftKey' ),
			   show( 'altKey' ),
			   // show('getModifierState'), // TODO getModifierState???
			   '\n',
			   show( 'button' ),
			   show( 'buttons' ),
			   showXY( 'screen' ),
			   showXY( 'client' ),
			   showXY( 'page' ),
			   showXY( 'movement' )
			);
		 } // if event.dispatchConfig
		 if ( event.target )
		 {
			bits.push( '\ntarget: ', getElementInfo( event.target ) );
		 }
		 if ( event.currentTarget )
		 {
			bits.push( '\ncurrentTarget: ', getElementInfo( event.currentTarget ) );
		 }
		 if ( event.relatedTarget )
		 {
			bits.push( '\nrelatedTarget: ', getElementInfo( event.relatedTarget ) );
		 }
		 if ( event.view )
		 {
			// TODO view(null)
			bits.push(
			   `\nview: ${typeof event.view} ${getTypeName( event.view )} ${showThing(
				  event.view
			   )}`
			);
		 } // if event.view
		 // eslint-disable-next-line @typescript-eslint/no-unused-vars
	  } catch ( ignore )
	  {
		 // console.warn(`EXCEPTION2 showEvent[${exception}]`)
	  } finally
	  {
		 result = bits.filter(( item ) => !!item );
		 if ( result.length )
		 {
			if ( prefix )
			{
			   result.unshift( prefix );
			}
			result = result
			   .join( '' )
			   .replace( /\n *\n/g, '\n' )
			   .replace( /\n+/g, '\n' );
		 } else
		 {
			result = `${prefix}NOT EVENT??? ${typeof event} ${getTypeName(
			   event
			)} ${showThing( event )}`;
		 } // if length
	  } // finally
	  return result;
   } // showEvent()

   // HEREIAM

   //==========================================================
   // Regex tests to validate it's working...

   expectToMatch( reVersionNickname, '<span>  version.nickname: blah blah </span>', 'reVersionNickname should match the nickname text' );
   expectNotToMatch( reVersionNickname, '<span>  version.Nickname: blah blah </span>', 'reVersionNickname should NOT match wrong case' );
   expectNotToMatch( reVersionNickname, '<span>  version not nickname blah blah </span>', 'breVersionNickname should NOT match non-nickname text' );

   expectToMatch( reAllowId, 'csl-dialog-desc12', 'reAllowId should match allowed id value', 2 );
   expectNotToMatch( reAllowId, 'csl-dialog-desc', 'reAllowId should NOT match other id values' );

   expectToMatch( reAttrsBoolean, 'xx  focusable="false"', 'reAttrsBoolean should match allowed boolean attr false value' );
   expectToMatch( reAttrsBoolean, '  FOCUSABLE="false"', 'reAttrsBoolean should match allowed boolean attr false value ignore case' );
   expectToMatch( reAttrsBoolean, '  focusable="true"', 'reAttrsBoolean should match allowed boolean attr true value' );
   expectNotToMatch( reAttrsBoolean, `  focusable='true'`, 'reAttrsBoolean should NOT match allowed boolean attr true value single quoted' );
   expectNotToMatch( reAttrsBoolean, `  focusable=true`, 'reAttrsBoolean should NOT match allowed boolean attr true value unquoted' );
   expectNotToMatch( reAttrsBoolean, '  focusable="nope"', 'reAttrsBoolean should NOT match allowed boolean attr non true/false value' );
   expectNotToMatch( reAttrsBoolean, '  focusable=""', 'reAttrsBoolean should NOT match allowed boolean attr empty value' );
   expectNotToMatch( reAttrsBoolean, 'unfocusable="true"', 'reAttrsBoolean should NOT match embedded allowed boolean attr' );
   expectNotToMatch( reAttrsBoolean, '  Width="true"', 'reAttrsBoolean should NOT match non-allowed boolean attr value' );
   expectToMatch( reAttrsBoolean, '  aria-hidden="false"', 'reAttrsBoolean should match allowed aria-hidden value' );
   expectToMatch( reAttrsBoolean, '  aria-modal="false"', 'reAttrsBoolean should match allowed aria-modal value' );
   expectToMatch( reAttrsBoolean, '  aria-invalid="false"', 'reAttrsBoolean should match allowed aria-invalid value' );
   expectToMatch( reAttrsBoolean, '  aria-checked="false"', 'reAttrsBoolean should match allowed aria-checked value' );
   expectToMatch( reAttrsBoolean, '  aria-expanded="false"', 'reAttrsBoolean should match allowed aria-expanded value' );
   expectNotToMatch( reAttrsBoolean, '  aria-other="false"', 'reAttrsBoolean should NON match non-allowed aria-other value' );
   expectNotToMatch( reAttrsBoolean, '  value="false"', 'reAttrsBoolean should NON match non-allowed value value' );
   expectNotToMatch( reAttrsBoolean, '  data-focus-guard="false"', 'reAttrsBoolean should NON match non-allowed data-focus-guard value' );

   expectToMatch( reAttrsToShow, 'id', 'reAttrsToShow should match allowed attr name id', 3 );
   expectToMatch( reAttrsToShow, 'Id', 'reAttrsToShow should match allowed attr name ignore case', 3 );
   expectNotToMatch( reAttrsToShow, 'pid', 'reAttrsToShow should NOT match embedded allowed attr name' );
   expectNotToMatch( reAttrsToShow, '  id  ', 'reAttrsToShow should NOT match spaces around allowed attr name' );
   expectToMatch( reAttrsToShow, 'name', 'reAttrsToShow should match allowed attr named name', 3 );
   expectToMatch( reAttrsToShow, 'type', 'reAttrsToShow should match allowed attr type', 3 );
   expectToMatch( reAttrsToShow, 'role', 'reAttrsToShow should match allowed attr role', 3 );
   expectToMatch( reAttrsToShow, 'target', 'reAttrsToShow should match allowed attr target', 3 );
   expectToMatch( reAttrsToShow, 'rel', 'reAttrsToShow should match allowed attr rel', 3 );
   expectToMatch( reAttrsToShow, 'disabled', 'reAttrsToShow should match allowed attr disabled', 3 );
   expectToMatch( reAttrsToShow, 'focusable', 'reAttrsToShow should match allowed attr focusable', 3 );
   expectToMatch( reAttrsToShow, 'hidden', 'reAttrsToShow should match allowed attr hidden', 3 );
   expectToMatch( reAttrsToShow, 'width', 'reAttrsToShow should match allowed attr width', 3 );
   expectToMatch( reAttrsToShow, 'height', 'reAttrsToShow should match allowed attr height', 3 );
   expectToMatch( reAttrsToShow, 'tabindex', 'reAttrsToShow should match allowed attr tabindex', 3 );
   expectToMatch( reAttrsToShow, 'for', 'reAttrsToShow should match allowed attr for', 3 );
   expectToMatch( reAttrsToShow, 'title', 'reAttrsToShow should match allowed attr title', 3 );
   expectToMatch( reAttrsToShow, 'placeholder', 'reAttrsToShow should match allowed attr placeholder', 3 );
   expectToMatch( reAttrsToShow, 'alt', 'reAttrsToShow should match allowed attr alt', 3 );
   expectToMatch( reAttrsToShow, 'href', 'reAttrsToShow should match allowed attr href', 3 );
   expectToMatch( reAttrsToShow, 'aria-any-thin-at-all', 'reAttrsToShow should match allowed attr aria-any-thin-at-all', 3 );
   expectToMatch( reAttrsToShow, 'data-what-ever', 'reAttrsToShow should match allowed attr data-what-ever', 3 );
   expectNotToMatch( reAttrsToShow, 'class', 'reAttrsToShow should NOT match allowed attr class' );
   expectNotToMatch( reAttrsToShow, 'className', 'reAttrsToShow should NOT match allowed attr className' );
   expectNotToMatch( reAttrsToShow, 'style', 'reAttrsToShow should NOT match allowed attr style' );

   expectToMatch( reRawHtml, '    <p stuff="ha">   ', 'reRawHtml should match HTML whitespaced' );
   expectToMatch( reRawHtml, '    <p stuff="ha">what</p><a>link</a>   ', 'reRawHtml should match multiple HTML whitespaced' );
   expectNotToMatch( reRawHtml, '    p stuff = ha   ', 'reRawHtml should NOT match non-HTML' );
   expectNotToMatch( reRawHtml, '    p stuff = ha   <p stuff="ha">', 'reRawHtml should NOT match non-HTML then HTML' );

   expectToMatch( reDocTextEmpty, '<p stuff="ha">', 'reDocTextEmpty should match element open' );
   expectToMatch( reDocTextEmpty, '</p>', 'reDocTextEmpty should match element close' );
   expectToMatch( reDocTextEmpty, '<p stuff="ha">HEY</P>', 'reDocTextEmpty should match multiple elements', 2 );
   expectNotToMatch( reDocTextEmpty, 'HEY', 'reDocTextEmpty should NOT match non-element text' );

   expectToMatch( reElemWithId, 'some<p x="2" id="34">text</p>', 'reElemWithId should match HTML element with an id' );
   expectToMatch( reElemWithId, 'some<p x="2" iD="34">text</p><a id="55">', 'reElemWithId should match two HTML elements with id', 2 );
   expectNotToMatch( reElemWithId, 'some<p x="2" sid="34">text</p>', 'reElemWithId should NOT match HTML element with no id' );
   expectNotToMatch( reElemWithId, `some<p x="2" id='34'>text</p>`, 'reElemWithId should NOT match HTML element with a single quoted id' );
   expectToMatch( reElemWithId, `some<p x="2" id="">text</p>`, 'reElemWithId should match HTML element with an empty id' );
   expectNotToMatch( reElemWithId, 'some<p x="2" id=34>text</p>', 'reElemWithId should NOT match HTML element with an unquoted id' );

   expectToMatch( reBoolean, 'false', 'reBoolean should match false' );
   expectToMatch( reBoolean, 'FALSE', 'reBoolean should match FALSE' );
   expectToMatch( reBoolean, 'falsefalse', 'reBoolean should match false twice', 2 );
   expectToMatch( reBoolean, 'unfalseifiable', 'reBoolean should match embedded false' );
   expectToMatch( reBoolean, 'true', 'reBoolean should match true' );
   expectToMatch( reBoolean, 'untruethful', 'reBoolean should match embedded true' );

   expectToMatch( reMissingMoney, `${LS};`, 'reMissingMoney should match missing pounds' );
   expectToMatch( reMissingMoney, 'price $not', 'reMissingMoney should match missing dollars' );
   expectToMatch( reMissingMoney, 'price $not$not', 'reMissingMoney should match missing dollars twice', 2 );
   expectNotToMatch( reMissingMoney, 'price $', 'reMissingMoney should NOT match dollars sign alone' );
   expectNotToMatch( reMissingMoney, 'price $ ', 'reMissingMoney should NOT match dollars space' );
   expectNotToMatch( reMissingMoney, 'price $42.32', 'reMissingMoney should NOT match dollar amount' );

   expectToMatch( reStringified, 'this is undefined text', 'reStringified should match literal undefined' );
   expectToMatch( reStringified, 'this is undefinedundefined text', 'reStringified should match literal undefined twice', 2 );
   expectToMatch( reStringified, 'this is UNDEFINED text', 'reStringified should match literal UNDEFINED' );
   expectToMatch( reStringified, 'this isundefinedtext', 'reStringified should match embedded isundefinedtext' );
   expectToMatch( reStringified, 'this is null text', 'reStringified should match literal null' );
   expectToMatch( reStringified, 'this isnulltext', 'reStringified should match embedded null' );
   expectToMatch( reStringified, 'this is NaN text', 'reStringified should match literal NaN' );
   expectNotToMatch( reStringified, 'this is BaNaNa text', 'reStringified should NOT match BANANA' );
   expectToMatch( reStringified, 'this is Infinity text', 'reStringified should match literal Infinity' );
   expectToMatch( reStringified, 'this isInfinitytext', 'reStringified should match embedded Infinity' );
   expectToMatch( reStringified, 'this is [object Object] text', 'reStringified should match stringified object' );
   expectToMatch( reStringified, 'this is[object Object]text', 'reStringified should match embedded stringified object' );
   expectToMatch( reStringified, 'this is function text', 'reStringified should match stringified function' );
   expectToMatch( reStringified, 'this isfunction text', 'reStringified should match embedded stringified function' );

   expectToMatch( reIndexUp, '[10]', 'reIndexUp should match indexing', 4 );
   expectToMatch( reIndexUp, '  [0]   ', 'reIndexUp should match indexing with spacing', 4 );
   expectToMatch( reIndexUp, '  [-12]   ', 'reIndexUp should match negative index', 4 );
   expectToMatch( reIndexUp, '   ', 'reIndexUp should match empty', 4 );
   expectToMatch( reIndexUp, '^^^', 'reIndexUp should match up the tree', 4 );
   expectToMatch( reIndexUp, ' ^^^  ', 'reIndexUp should match up the tree with spacing', 4 );
   expectToMatch( reIndexUp, '@LIST', 'reIndexUp should match list marker', 4 );
   expectToMatch( reIndexUp, '[5]^^@LIST', 'reIndexUp should match all syntax', 4 );
   expectToMatch( reIndexUp, '  [5] ^^ @LIST ', 'reIndexUp should match all syntax with spacing', 4 );

   const expectMatches: any = [
	  "   [5] @LIST ",
	  "5",
	  "",
	  "@LIST"
   ];
   expectMatches.index = 3;
   expectMatches.input = ' ^^   [5] @LIST ';
   expectToMatch( reIndexUp, ' ^^   [5] @LIST ', 'reIndexUp should parially match all syntax in wrong order', expectMatches.length, expectMatches );

   expectToMatch( reExtraSpacesClosureElem, 'blah />', 'reExtraSpacesClosureElem should match single space on closure of element' );
   expectToMatch( reExtraSpacesClosureElem, 'blah   />', 'reExtraSpacesClosureElem should match excess space on closure of element' );
   expectNotToMatch( reExtraSpacesClosureElem, 'blah/>', 'reExtraSpacesClosureElem should NOT match no spaces on closure of element' );
   expectNotToMatch( reExtraSpacesClosureElem, 'blah >', 'reExtraSpacesClosureElem should NOT match single space on end of element' );

   expectToMatch( reOuterSpaces, '', 'reOuterSpaces should match empty string' );
   expectToMatch( reOuterSpaces, '    ', 'reOuterSpaces should match spaces only' );
   expectToMatch( reOuterSpaces, '    blah blah   ', 'reOuterSpaces should match spaces around text' );
   expectToMatch( reOuterSpaces, 'blah blah', 'reOuterSpaces should match text without spacing' );
   expectToReplace( reOuterSpaces, '    blah blah   \n  blah   blah\n   blah blah\n\n', '@\n@\n@@', 'reOuterSpaces should replace spaces around text with multiple lines', '@' );
   expectToReplace( reOuterSpaces, '    blah blah   ', '1:[    ] 2:[blah blah] 3:[   ]', 'reOuterSpaces should match and replace groups' );

   expectToSplit( /,/, ',a,e,i,o,u', [ '', 'a', 'e', 'i', 'o', 'u' ], 'should split correctly' );
   expectToMatch( reSplitAfterElement, '<p>', 'reSplitAfterElement should match element at end of string' );
   expectToMatch( reSplitAfterElement, '<p>more stuff', 'reSplitAfterElement should match element and stuff at end of string' );
   expectNotToMatch( reSplitAfterElement, '<p>more stuff<', 'reSplitAfterElement should NOT match element with < at end of string' );
   expectNotToMatch( reSplitAfterElement, '<p>more stuff<p', 'reSplitAfterElement should NOT match element with < before end of string' );
   expectToMatch( reSplitAfterElement, '<p>more stuff<p>', 'reSplitAfterElement should match element with <p> at end of string' );
   expectNotToMatch( reSplitAfterElement, '', 'reSplitAfterElement should NOT match empty string' );
   expectToReplace( reSplitAfterElement, '<p>more stuff', '<p1:[more stuff] 2:[$2] 3:[$3]', 'reSplitAfterElement should replace groups' );
   expectToReplace( reSplitAfterElement, '<p>more stuff<p>', '<p>more stuff<p1:[] 2:[$2] 3:[$3]', 'reSplitAfterElement should replace groups' );

   expectToMatch( reSplitBeforeElement, '<p>', 'reSplitBeforeElement should match element at start of string' );
   expectToMatch( reSplitBeforeElement, 'bunch of text<p>', 'reSplitBeforeElement should match stuff before element at start of string' );
   expectToMatch( reSplitBeforeElement, '<p>bunch of text</p>', 'reSplitBeforeElement should match stuff before element at start of string' );
   expectToMatch( reSplitBeforeElement, 'more<p>bunch of text</p>', 'reSplitBeforeElement should match double stuff before element at start of string' );
   expectNotToMatch( reSplitBeforeElement, '', 'reSplitBeforeElement should NOT match empty string' );
   expectToReplace( reSplitBeforeElement, 'bunch of text</p>', '1:[bunch of text] 2:[$2] 3:[$3]/p>', 'reSplitBeforeElement should replace groups' );
   expectToReplace( reSplitBeforeElement, 'more<p>bunch of text</p>', '1:[more] 2:[$2] 3:[$3]p>bunch of text</p>', 'reSplitBeforeElement should replace groups' );

   expectToMatch( reSplitBetweenElement, '<p>what</p><a>the</a>', 'reSplitBetweenElement should match element boundaries', 3, );
   expectToReplace( reSplitBetweenElement, '<p>what</p><a>the</a>', '<p1:[what] 2:[$2] 3:[$3]/p1:[] 2:[$2] 3:[$3]a1:[the] 2:[$2] 3:[$3]/a>', 'reSplitBetweenElement should replace groups' );
   expectNotToMatch( reSplitBetweenElement, '<p what=the/>', 'reSplitBetweenElement should NOT match single element' );

   expectToMatch( reIndentElemAttr, 'width="42"', 'reIndentElemAttr should match an attribute' );
   expectToMatch( reIndentElemAttr, 'aria-WIDTH="42"', 'reIndentElemAttr should match a hyphenated attribute' );
   expectToMatch( reIndentElemAttr, '       width=""    ', 'reIndentElemAttr should match an empty attribute with leading space' );
   expectToMatch( reIndentElemAttr, 'width="42"  height="12"', 'reIndentElemAttr should match multiple attributes', 2 );
   expectToReplace( reIndentElemAttr, 'width="42"  height="12"', '1:[] 2:[width="42"] 3:[$3]1:[] 2:[height="12"] 3:[$3]', 'reIndentElemAttr should replace multiple attributes' );
   expectNotToMatch( reIndentElemAttr, `width='42'`, 'reIndentElemAttr should NOT match a single quoted attribute' );
   expectNotToMatch( reIndentElemAttr, `width=42`, 'reIndentElemAttr should NOT match an unquoted attribute' );

   expectToMatch( reStyleAttr, 'style="blah: blah;"', 'reStyleAttr should match style attribute value' );
   expectToMatch( reStyleAttr, '   style="blah: blah;"   ', 'reStyleAttr should match style attribute value with spacing' );
   expectToMatch( reStyleAttr, '<p   style="blah: blah;"  > <a style="what: what;">', 'reStyleAttr should match multiple style attribute values with spacing', 2 );
   expectNotToMatch( reStyleAttr, 'style=""', 'reStyleAttr should NOT match empty style attribute value' );
   expectNotToMatch( reStyleAttr, "style='blah: blah;'", 'reStyleAttr should NOT match single quoted style attribute value' );
   expectNotToMatch( reStyleAttr, "mystyle='blah: blah;'", 'reStyleAttr should NOT match single quoted embedded style attribute value' );

   expectToMatch( reEndingSemi, ';', 'reEndingSemi should match semicolon only' );
   expectToMatch( reEndingSemi, 'blah;', 'reEndingSemi should match semicolon at end of string' );
   expectNotToMatch( reEndingSemi, ':', 'reEndingSemi should NOT match colon only' );
   expectNotToMatch( reEndingSemi, '  ;  ', 'reEndingSemi should NOT match semicolon with spaces' );
   expectNotToMatch( reEndingSemi, 'blah; end', 'reEndingSemi should NOT match semicolon at middle of string' );
   expectNotToMatch( reEndingSemi, ';blah', 'reEndingSemi should match semicolon at start of string' );

   expectToMatch( reSemiSpaces, ';', 'reSemiSpaces should match semicolon only' );
   expectToMatch( reSemiSpaces, 'blah;', 'reSemiSpaces should match semicolon at end of string' );
   expectToMatch( reSemiSpaces, '  ;  ', 'reSemiSpaces should match semicolon with spaces' );
   expectToMatch( reSemiSpaces, 'blah; end', 'reSemiSpaces should match semicolon at middle of string' );
   expectToMatch( reSemiSpaces, ';blah', 'reSemiSpaces should NOT match semicolon at start of string' );
   expectNotToMatch( reSemiSpaces, ':', 'reSemiSpaces should NOT match colon only' );

   expectToMatch( reLineBeforeElement, '<p>', 'reLineBeforeElement should match start of string before element' );
   expectToMatch( reLineBeforeElement, '\n<p>', 'reLineBeforeElement should match newline before element' );
   expectToMatch( reLineBeforeElement, 'blah blah\n<p>', 'reLineBeforeElement should match extra stuff then newline before element' );
   expectNotToMatch( reLineBeforeElement, '  <p>', 'reLineBeforeElement should NOT match space before element' );
   expectNotToMatch( reLineBeforeElement, 'blah blah<p>', 'reLineBeforeElement should NOT match extra stuff before element' );

   expectToMatch( reLineBeforeText, 'blah</p>', 'reLineBeforeText should match end of line' );
   expectToMatch( reLineBeforeText, 'blah</p>\n', 'reLineBeforeText should match new line' );
   expectToMatch( reLineBeforeText, '<h1>head</h1>   <b>bold</b>\n\n<p>blah</p>\n<i>italic</i>', 'reLineBeforeText should match multiple', 3 );
   expectNotToMatch( reLineBeforeText, 'blah</p>  \n', 'reLineBeforeText should NOT match spaces' );

   expectToMatch( reAttribute, 'width="42"', 'reAttribute should match an attribute' );
   expectToMatch( reAttribute, 'aria-WIDTH="42"', 'reAttribute should match a hyphenated attribute' );
   expectToMatch( reAttribute, '       width=""    ', 'reAttribute should match an empty attribute with leading space' );
   expectToMatch( reAttribute, 'width="42"  height="12"', 'reAttribute should match multiple attributes', 2 );
   expectToReplace( reAttribute, 'width="42"  height="12"', '1:[width] 2:["42"] 3:[$3]1:[height] 2:["12"] 3:[$3]', 'reAttribute should replace multiple attributes' );
   expectNotToMatch( reAttribute, `width='42'`, 'reAttribute should NOT match a single quoted attribute' );
   expectNotToMatch( reAttribute, `width=42`, 'reAttribute should NOT match an unquoted attribute' );

   expectToMatch( reExtraSpacesElem, 'blah >', 'reExtraSpacesElem should match single space on end of element' );
   expectToMatch( reExtraSpacesElem, 'blah   >', 'reExtraSpacesElem should match excess space on end of element' );
   expectNotToMatch( reExtraSpacesElem, 'blah>', 'reExtraSpacesElem should NOT match no spaces on end of element' );
   expectNotToMatch( reExtraSpacesElem, 'blah />', 'reExtraSpacesElem should NOT match single space on closure of element' );

   expectToMatch( rePlainElem, '<span>', 'rePlainElem should match opening element' );
   expectToMatch( rePlainElem, '</spAN>', 'rePlainElem should match closing element' );
   expectToMatch( rePlainElem, 'text<span> embedded', 'rePlainElem should match embedded opening element' );
   expectToMatch( rePlainElem, '<span>text</span> <em>embedded</em>', 'rePlainElem should match multiple elements', 4 );
   expectNotToMatch( rePlainElem, '<span >', 'rePlainElem should NOT match opening element with internal spaces' );
   expectNotToMatch( rePlainElem, '<span id=32>', 'rePlainElem should NOT match opening element with attributes' );

   expectToMatch( reBlankLines, '\n\n', 'reBlankLines should match two newlines' );
   expectToMatch( reBlankLines, 'what\n\n   ', 'reBlankLines should match embedded newlines' );
   expectToMatch( reBlankLines, '\n  \t \n', 'reBlankLines should match two newlines and spaces between' );
   expectToMatch( reBlankLines, '\n\n\n\n\n', 'reBlankLines should match multiple newlines' );
   expectNotToMatch( reBlankLines, '\n', 'reBlankLines should NOT match single newline' );
   expectToMatch( reBlankLines, 'this\n  \ndouble\n  \n  \n  spaced', 'reBlankLines should match multiple newlines and text breaks', 2 );
   expectToReplace( reBlankLines, '\n \n \t \n\n\n\n', 'BRK', 'reBlankLines should replace multiple newlines', 'BRK' );

   expectToMatch( reAttrIdentity, 'xx  id="false"', 'reAttrIdentity should match id attribute' );
   expectToMatch( reAttrIdentity, 'name="Fred"', 'reAttrIdentity should match name attribute' );
   expectToMatch( reAttrIdentity, 'role="Fred"', 'reAttrIdentity should match role attribute' );
   expectToMatch( reAttrIdentity, 'data-anything="Fred"', 'reAttrIdentity should match data-* attribute' );
   expectToMatch( reAttrIdentity, 'aria-label="Fred"', 'reAttrIdentity should match aria-label attribute' );
   expectToMatch( reAttrIdentity, 'aria-labelledby="Fred"', 'reAttrIdentity should match aria-label* attribute' );
   expectToMatch( reAttrIdentity, 'aria-desc="Fred"', 'reAttrIdentity should match aria-desc attribute' );
   expectToMatch( reAttrIdentity, 'aria-description="Fred"', 'reAttrIdentity should match aria-desc attribute' );
   expectToMatch( reAttrIdentity, 'aria-desctibedby="Fred"', 'reAttrIdentity should match aria-desc* attribute' );
   expectToMatch( reAttrIdentity, 'aria-role="Fred"', 'reAttrIdentity should match aria-role attribute' );
   expectToMatch( reAttrIdentity, 'aria-roledescription="Fred"', 'reAttrIdentity should match aria-role* attribute' );
   expectNotToMatch( reAttrIdentity, 'ploughname="Fred"', 'reAttrIdentity should NOT match embedded name attribute' );
   expectToMatch( reAttrIdentity, 'name="Fred" id="1234" role="checkbox"', 'reAttrIdentity should match multiple attributes', 3 );
   expectToMatch( reAttrIdentity, 'width="42" name="Fred" id="1234" yes="23" role="checkbox"', 'reAttrIdentity should match multiple identity attributes only', 3 );
   expectNotToMatch( reAttrIdentity, 'width="Fred"', 'reAttrIdentity should NOT match non-identity attribute' );
   expectNotToMatch( reAttrIdentity, 'namE="fred"', 'reAttrIdentity should NOT match upper case' );
   expectNotToMatch( reAttrIdentity, 'name=""', 'reAttrIdentity should NOT match empty name attribute' );
   expectNotToMatch( reAttrIdentity, 'aria-anything="Fred"', 'reAttrIdentity should NOT match aria-* attribute' );

   expectToMatch( reElemNoAttr, '<span>', 'reElemNoAttr should match opening element' );
   expectToMatch( reElemNoAttr, '</spAN>', 'reElemNoAttr should match closing element' );
   expectToMatch( reElemNoAttr, 'text<span> embedded', 'reElemNoAttr should match embedded opening element' );
   expectToMatch( reElemNoAttr, '<span>text</span> <em>embedded</em>', 'reElemNoAttr should match multiple elements', 4 );
   expectToMatch( reElemNoAttr, '<span   >', 'reElemNoAttr should match opening element with internal spaces' );
   expectNotToMatch( reElemNoAttr, '<span id="32">', 'reElemNoAttr should NOT match opening element with attributes' );

   expectToMatch( reMultiSpaced, '\n\n', 'reMultiSpaced should match two newlines' );
   expectToMatch( reMultiSpaced, 'what\n\n   ', 'reMultiSpaced should match embedded newlines' );
   expectToMatch( reMultiSpaced, '\n  \t \n', 'reMultiSpaced should match two newlines and spaces between' );
   expectToMatch( reMultiSpaced, '\n\n\n\n\n', 'reMultiSpaced should match multiple newlines' );
   expectNotToMatch( reMultiSpaced, '\n', 'reMultiSpaced should NOT match single newline' );
   expectToMatch( reMultiSpaced, 'this\n  \ndouble\n  \n  \n  spaced', 'reMultiSpaced should match multiple newlines and text breaks', 2 );
   expectToReplace( reMultiSpaced, '\n \n \t \n\n\n\n', 'BRK', 'reMultiSpaced should replace multiple newlines', 'BRK' );

   expectToMatch( reNicePreamble, '\n========== S\n', 'reNicePreamble should match minimally at new line' );
   expectToMatch( reNicePreamble, '\n\n\n========== blah blah\n', 'reNicePreamble should match at new line' );
   expectToMatch( reNicePreamble, 'blah blah\n\n========== blah blah\n', 'reNicePreamble should match within text' );
   expectToMatch( reNicePreamble, '\n============== S\n', 'reNicePreamble should match more equal signs' );
   expectNotToMatch( reNicePreamble, '========== \n', 'reNicePreamble should NOT match if no newline' );
   expectNotToMatch( reNicePreamble, '\n========= S\n', 'reNicePreamble should NOT match too few equal signs' );
   expectToMatch( reNicePreamble, '\n============== HTML\nblah blah blah\n========== HEY\n', 'reNicePreamble should greedy match multiple banners' );

   expectToMatch( reInitialLineSpaces, '  \t  what', 'reInitialLineSpaces should match with initial line spaces' );
   expectToMatch( reInitialLineSpaces, '\n  \t  what', 'reInitialLineSpaces should match with newline and line spaces' );
   expectToMatch( reInitialLineSpaces, 'what', 'reInitialLineSpaces should match with no initial line spaces' );

   expectToMatch( reNewLines, '\n', 'reNewLines should match single newline' );
   expectToMatch( reNewLines, '\n\n', 'reNewLines should match two newlines', 2 );
   expectToMatch( reNewLines, 'what\n\n   ', 'reNewLines should match embedded newlines', 2 );
   expectToMatch( reNewLines, '\n  \t \n', 'reNewLines should match two newlines and spaces between', 2 );
   expectToMatch( reNewLines, '\n\n\n\n\n', 'reNewLines should match multiple newlines', 5 );
   expectToMatch( reNewLines, 'this\n  \ndouble\n  \n  \n  spaced', 'reNewLines should match multiple newlines and text breaks', 5 );
   expectToReplace( reNewLines, '\n \n \t \n\n\n\n', 'BRK BRK \t BRKBRKBRKBRK', 'reNewLines should replace multiple newlines', 'BRK' );
   expectNotToMatch( reNewLines, 'what   ', 'reNewLines should NOT match no newlines' );

   expectToMatch( reExpectStraggler, '\n\n  expect(screen.queryByText(RE[   ', 'reExpectStraggler should match expect test leftovers' );
   expectToMatch( reExpectStraggler, 'blah blah\n\n  expect(screen.queryByText(RE[   ', 'reExpectStraggler should match expect test leftovers multiline' );
   expectNotToMatch( reExpectStraggler, '\n\n  expect(screen.getByText(RE[   ', 'reExpectStraggler should NOT match expect test leftovers' );
   expectToReplace( reExpectStraggler, 'blah blah\n\n  expect(screen.queryByText(RE[   ', 'blah blah\n1:[$1] 2:[$2] 3:[$3]', 'reExpectStraggler should replace expect test leftovers multiline' );

   expectToMatch( reEmbeddedRE, 'RE[/>([^<]*)$/g]ER', 'reEmbeddedRE should match a quoted regular expression' );
   expectToMatch( reEmbeddedRE, 'RE[/RE\[(.+?)\]ER/g]ER', 'reEmbeddedRE should match a quoted regular expression of similar structure' );
   expectToMatch( reEmbeddedRE, 'RE[/>([^<]*)$/g]ER    RE[/RE\\[(.+?)\\]ER/g]ER', 'reEmbeddedRE should match multiple quoted regular expression', 2 );
   expectNotToMatch( reEmbeddedRE, 'RE[/>([^<]*)$/g]', 'reEmbeddedRE should NOT match an incomplete quoted regular expression' );
   expectToReplace( reEmbeddedRE, 'RE[/>([^<]*)$/g]ER    RE[/RE\\[(.+?)\\]\\ER/g]ER', '1:[/>([^<]*)$/g] 2:[$2] 3:[$3]    1:[/RE\\[(.+?)\\]\\ER/g] 2:[$2] 3:[$3]', 'reEmbeddedRE should replace quoted regular expression' );

   expectToMatch( reSpaceMarker, '[SPACE]', 'reSpaceMarker should match a space character marker' );
   expectToMatch( reSpaceMarker, '[SPACE][SPACE][SPACE]', 'reSpaceMarker should match multiple space character markers' );
   expectToMatch( reSpaceMarker, '[SPACE]\t[SPACE]\t[SPACE]', 'reSpaceMarker should match multiple space character markers', 3 );
   expectNotToMatch( reSpaceMarker, '[space]', 'reSpaceMarker should NOT match a space character marker lower case' );

   expectToMatch( reRemoveBlankExpects, '    expect(screen.queryByText(BLANKBLANK)).toBeInTheDocument();\n', 'reRemoveBlankExpects should match expect ... BLANKBLANK' );

   //==========================================================
   // tests to validate it's working...

   expectToBe( NaN, NaN, `should pass for NaN comparison` );
   expectToBe( Infinity, Infinity, `should pass for Infinity comparison` );
   if ( LET_FAIL_TESTS )
   {
	  expectNotToBe( NaN, NaN, `should fail for NaN comparison` );
   }

   EX_SHOW_SPACES = true;
   expectToBe( show(
	  ' \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u0020\v\w\x0a\y\z ' ),
	  '~a\bcde\\fghijklm\\nopq\\rs\\t~\\vw\\nyz~', 'show() should requote white space characters' );
   expectToBe( show(
	  '  \x0d \f \n \r \t \u0020 \x0d\x0a \v \x0a  ' ),
	  '~~\\r~\\f~\\n~\\r~\\t~~~\\r\\n~\\v~\\n~~', 'show() should requote white space characters handling newlines' );
   EX_SHOW_SPACES = false;

   expectToBe( replaceSpaces(
	  '\a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u0020\v\w\x0a\y\z' ),
	  'a\bcdeghijklm\nopqsw\x0ayz', 'replaceSpaces() should remove white space characters' );
   expectToBe( replaceSpaces(
	  '  \x0d \f \n \r \t \u0020 \x0d\x0a \v \x0a  ' ),
	  '\n\x0a\x0a', 'replaceSpaces() should remove white space characters except newlines' );

   expectToBe( showSpaces( ' initial  medial final  \n\n' ), '[SPACE]initial  medial final[SPACE][SPACE]\n\n', 'showSpaces() should make white spaces visible' )
   expectToBe( showSpaces( '   initial   internal  final  spaces     ', '@' ), '@@@initial   internal  final  spaces@@@@@', 'showSpaces() should make white spaces visible with @ sign' )
   expectToBe( showSpaces( ' initial\n  med\t ial\  \nfinal\  \n\n', '@' ), '@initial\n@@med\t ial@@\nfinal@@\n\n', 'showSpaces() should work across multiple lines of text' )

   expectToBe( dskipIfJenkins, describe.skip, 'should have describe skip function activated for jenkins' );
   expectToBe( skipIfJenkins, test.skip, 'should have skip function activated for jenkins' );

   if ( NOISY )
   {
	  trace( `this is my trace message`, [ 42, 12 ] );
	  trace( `this is another trace function`, { list: [ 42, 12 ] } );
   }

   win.document = mockDocument( '<main><span>version.nickname: JIRA-NNNN XYZY</span><h1>heading</h1><hr/><p id="mypara">this is the text</p><hr /></main>' );

   const window = win;
   mockWindowLocation( void 0, window );
   // trace(`window`, window);
   expectToBe( window.location.href, 'htt\p://localhost.site:3000/#/', 'should set window href' );
   expectToBe( window.location.origin, 'htt\p://localhost.site:3000', 'should set window origin' );
   expectToBe( window.location.protocol, 'htt\p:', 'should set window protocol' );
   expectToBe( window.location.username, '', 'should set window username' );
   expectToBe( window.location.password, '', 'should set window password' );
   expectToBe( window.location.host, 'localhost.site:3000', 'should set window host' );
   expectToBe( window.location.hostname, 'localhost.site', 'should set window hostname' );
   expectToBe( window.location.port, '3000', 'should set window port' );
   expectToBe( window.location.pathname, '/', 'should set window pathname' );
   expectToBe( window.location.search, '', 'should set window search' );
   expectToBe( window.location.hash, '#/', 'should set window hash' );
   expectToEqual( window.location.searchParams, {}, 'should set window search' );
   window.location.assign( 'ft\p://john:doe@go.com:3333/path/name?param=34&that=this#hashpath' );
   // trace(`window.location`, window.location);
   expectToBe( window.location.href, 'ft\p://john:doe@go.com:3333/path/name?param=34&that=this#hashpath', 'should set window href as ftp' );
   expectToBe( window.location.origin, 'ft\p://go.com:3333', 'should set window origin' );
   expectToBe( window.location.protocol, 'ft\p:', 'should set window protocol' );
   expectToBe( window.location.username, 'john', 'should set window username' );
   expectToBe( window.location.password, 'doe', 'should set window password' );
   expectToBe( window.location.host, 'go.com:3333', 'should set window host' );
   expectToBe( window.location.hostname, 'go.com', 'should set window hostname' );
   expectToBe( window.location.port, '3333', 'should set window port' );
   expectToBe( window.location.pathname, '/path/name', 'should set window pathname' );
   expectToBe( window.location.search, '?param=34&that=this', 'should set window search' );
   expectToBe( window.location.hash, '#hashpath', 'should set window hash' );
   expectToEqual( window.location.searchParams, {}, 'should set window search' );
   window.location.replace( 'fil\e:/path' );
   window.location.reload();
   expectToBe( window.location.href, 'fil\e:///path', 'should set window href as a file' );
   expectToBe( window.location.origin, 'null', 'should set window origin' );
   expectToBe( window.location.protocol, 'file:', 'should set window protocol' );
   expectToBe( window.location.pathname, '/path', 'should set window pathname' );
   //  trace(`window.location`, window.location);

   var document = mockDocument( '<main><span>version.nickname: JIRA-NNNN XYZY</span><hr/><p id="mypara" uuid="uuid" parole="parole" title="tooltip text">  </p><hr /></main>' );
   EX_SHOW_SPACES = true;
   checkDocumentTextEmpty();
   if ( LET_FAIL_TESTS )
   {
	  checkDocumentTextEmpty( win.document.body );
   }
   EX_SHOW_SPACES = false;

   expectToBe( elementAt(), 'ELEMENT', 'elementAt() should return current value' );
   expectToBe( elementAt( 'NEWVALUE' ), 'ELEMENT', 'elementAt() should not have changed' );
   expectToBe( elementAt(), 'NEWVALUE', 'elementAt() should return changed value' );

   expectToBe( getElementById( 'missingId' ), null, 'getElementById() should return null' );

   document.getElementById = () => 'FOUND' as unknown as HTMLElement;
   expectToBe( getElementById( 'myid' ), 'FOUND', 'getElementById() should return an element using document.getElementById' );

   document.getElementById = null;
   document.querySelector = () => 'FOUNDED' as unknown as HTMLElement;
   expectToBe( getElementById( 'myid' ), 'FOUNDED', 'getElementById() should return an element using document.querySelector' );
   document.querySelector = null;

   let looped = '';
   forOf<string[], string>( [ 'the', 'brown', 'fox' ], ( item: string, index: number ) =>
   {
	  looped += `${index}:${item} `;
   } );
   expectToBe( looped, '0:the 1:brown 2:fox ', 'forOf() should loop through an array' );

   looped = '';
   forOf( { the: 'bloody', fox: 'died' }, ( item: string, index: number ) =>
   {
	  looped += `${index}:${item} `;
   } );
   // cannot loop through an object with for of in this version...
   if ( LET_FAIL_TESTS )
   {
	  expectToBe( looped, '0:the 1:bloody 2:fox 3:died ', 'forOf() should iterate through an iterable' );
   }

   const el = {
	  tagName: 'main',
	  attributes: [ {
		 name: 'id',
		 value: 'ID',
	  }, {
		 name: 'width',
		 value: 32,
	  }]
   } as unknown as IElement;
   expectToBe( elementInfo( el ), '<main id="ID" width="32" />', 'should show element and attributes' );
   el.outerHTML = elementInfo( el );
   el.innerHTML = '';

   document.getElementById = () => null;
   document.querySelector = () => null;
   document.querySelectorAll = () => [] as any;
   document.getElementsByClassName = () => [] as any;

   elementAt( 'NIL' );
   expectToEqual( getEl( '<h1>HEADING</h1>' ), { innerHTML: '<h1>HEADING</h1>' }, 'getEl(raw html) should return the html as .innerHTML' );
   expectToBe( elementAt(), 'GET EL RAW HTML STRING', 'elementAt() should be set to raw html message' );
   expectToBe( getEl( el ), el, 'getEl(element) should return the element itself' );
   expectToBe( elementAt(), 'GET EL ELEMENT <main id="ID" width="32" />', 'elementAt() should be set to ELEMENT dump ' );
   expectToBe( getEl(), document.body, 'getEl() should return the document.body' );
   expectToBe( elementAt(), 'GET EL ELEMENT <body />', 'elementAt() should return element body message' );

   const div = {
	  tagName: 'div',
	  attributes: [ {
		 name: 'id',
		 value: 'ID',
	  }, {
		 name: 'width',
		 value: 32,
	  }]
   } as unknown as IElement;
   const span = {
	  tagName: 'span',
	  attributes: [ {
		 name: 'id',
		 value: 'SPN',
	  }, {
		 name: 'width',
		 value: 12,
	  }],
	  parentElement: div,
   } as unknown as IElement;

   document.querySelectorAll = () => [ div, div, span ] as any;
   // trace(`document`, document);
   expectToBe( getEl( 2 ), span, 'getEl(2) should return the 3rd div/span in the document' );
   expectToBe( elementAt(), 'GET EL FIND ANY MATCH FOR "div,span" [2] go up 0\nlookup @[2] of 3 matched ==> [[ByQuerySelector#2 <span id="SPN" width="12" />]]', 'elementAt() should return find message' );
   expectToBe( getEl( 'div,span [1]' ), div, 'getEl(div,span [1]) should return the 2nd div/span in the document' );
   expectToBe( elementAt(), 'GET EL FIND ANY MATCH FOR "div,span" [1] go up 0\nlookup @[1] of 3 matched ==> [[ByQuerySelector#1 <div id="ID" width="32" />]]', 'elementAt() should return find message with index value' );
   expectToBe( getEl( 'div,span [2]^' ), div, 'getEl(div,span [2]^) should return the parent element of the 3rd div/span in the document' );
   expectToBe( getEl( 'div,span', '[-1]^' ), div, 'getEl(div,span, [-1]^) should return the parent element of the last div/span in the document' );
   EX_SHOW_SPACES = true;
   expectToBe( elementAt(), 'GET EL FIND ANY MATCH FOR "div,span" [-1] go up 1\nlookup @[2] of 3 matched ==> [[ByQuerySelector#2 <span id="SPN" width="12" />]]\nup to parent --> <div id="ID" width="32" /> ', 'elementAt() should return find message with negative index and go up 1' );
   EX_SHOW_SPACES = false;
   expectToBe( getEl( 'div,span @LIST' ), div, 'getEl(div,span @LIST) should return first div and log the full list' );

   const openTestId = {
	  tagName: 'span',
	  attributes: [ {
		 name: 'data-testid',
		 value: 'accordion-open',
	  }, {
		 name: 'class',
		 value: 'open',
	  }],
	  innerHTML: 'Open the door',
	  innerText: 'Open the door',
   } as unknown as IElement;
   const openId = {
	  tagName: 'button',
	  attributes: [ {
		 name: 'id',
		 value: 'accordion-open',
	  }],
	  innerHTML: 'Open',
	  innerText: 'Open',
	  parentElement: openTestId,
   } as unknown as IElement;
   const openLabel = {
	  tagName: 'label',
	  attributes: [ {
		 name: 'for',
		 value: 'account-open',
		 title: 'This will allow you to open a current or savings account',
	  }],
	  innerHTML: 'Open an account',
	  innerText: 'Open an account',
   } as unknown as IElement;
   const openAlt = {
	  tagName: 'img',
	  attributes: [ {
		 name: 'alt',
		 value: 'An opening in a wall with flowers growing within it.',
	  }, {
		 name: 'src',
		 value: 'data@13552aCe',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as IElement;
   const openPlace = {
	  tagName: 'input',
	  attributes: [ {
		 name: 'name',
		 value: 'opening-balance',
	  }, {
		 name: 'placeholder',
		 value: 'opening balance...',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as IElement;
   const openInput = {
	  tagName: 'input',
	  attributes: [ {
		 name: 'name',
		 value: 'transaction-state',
	  }, {
		 name: 'value',
		 value: 'open',
	  }, {
		 name: 'role',
		 value: 'dropdown',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as IElement;

   document.querySelectorAll = () => [] as any;
   document.getElementById = () => openId as any;
   document.getElementsByClassName = () => [ openId ] as any;
   screen.queryAllByTestId = () => [ openTestId ];
   screen.queryAllByLabelText = () => [ openLabel ];
   screen.queryAllByText = () => [ openLabel, openId, openTestId ];
   screen.queryAllByTitle = () => [ openLabel ];
   screen.queryAllByAltText = () => [ openAlt ];
   screen.queryAllByPlaceholderText = () => [ openPlace ];
   screen.queryAllByDisplayValue = () => [ openInput ];
   screen.queryAllByRole = () => [];
   expectToBe( getEl( /open/i ), openTestId, 'getEl(/open/i) should return the first match of regex /open/' );
   expectToBe( elementAt(), 'GET EL REGEX ANY MATCH FOR /open/i\nlookup @[0] of 11 matched ==> [[ByTestId#0 <span data-testid="accordion-open" class="open" />]]', 'elementAt() should return by testid message' );
   expectToBe( getEl( /open/i, '[4]^@LIST' ), openTestId, 'getEl(/open/i,[4]^@LIST) should return the fifth match of regex /open/ and go up 1, logging the full list' );
   expectToBe( elementAt(), 'GET EL REGEX ANY MATCH FOR /open/i [4] go up 1\nlookup @[4] of 11 matched ==> [[ByText#1 <button id="accordion-open" />]]\nup to parent --> <span data-testid="accordion-open" class="open" /> ', 'elementAt() should return regex match, index and up message' );

   const stylesheet = `
display: none;
width: 100%;
height: 30vh;
  `.trim().replace( /\n/g, '' );

   const rawHtml = `
<h1>HEADING</h1>
<main>
<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />
<article>  This   is an \narticle\n in the document  </article>
<hr />
<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="${stylesheet}" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">footer</footer>
</main>
  `.trim().replace( />\n/g, '>' );
   const rawHtmlNoNL = rawHtml.replace( /\n/g, '' );
   //console.warn(`rawHtml: `, rawHtml);

   const expectHtmlNoNLOld = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />\n\n<article>\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n</article>\n\n<hr />\n\n<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="display: none;width: 100%;height: 30vh;" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlNoNL = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />\n\n<article>\n[SPx2]This[SPx3]is an article in the document[SPx2]\n</article>\n\n<hr />\n\n<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="display: none;width: 100%;height: 30vh;" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlSpc = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img alt="icon plus" src="./icon-plus.svg" width="32" height="32" />\n\n<article>\n\\s\\sThis   is an article in the document\\s\\s\n</article>\n\n<hr />\n\n<footer id="FOOTER" name="NAME" role="ROLE" data-testid="DATA-TESTID" aria-label="LABEL" aria-description="ADESC" aria-role="AROLE" aria-rolel="AROLEL" value="false" focusable="true" aria-hidden="false" aria-modal="true" aria-invalid="false" aria-checked="true" aria-expanded="false" data-focus-guard="true" data-focus-lock-disabled="false" data-autofocus-inside="true" data-popper-arrow="false" data-oranges="true" class="CLASS" style="display: none;width: 100%;height: 30vh;" type="TYPE" target="TARGET" rel="REL" disabled="true" focusable="false" hidden="true" width="WIDTH" height="HEIGHT" tabindex="TABINDEX" for="FOR" title="TITLE" placeholder="PLACEHOLDER" alt="ALT" href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlNiceOld = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img\n	alt="icon plus"\n	src="./icon-plus.svg"\n	width="32"\n	height="32"/>\n\n<article>\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n</article>\n\n<hr />\n\n<footer\n	id="FOOTER"\n	name="NAME"\n	role="ROLE"\n	data-testid="DATA-TESTID"\n	aria-label="LABEL"\n	aria-description="ADESC"\n	aria-role="AROLE"\n	aria-rolel="AROLEL"\n	value="false"\n	focusable="true"\n	aria-hidden="false"\n	aria-modal="true"\n	aria-invalid="false"\n	aria-checked="true"\n	aria-expanded="false"\n	data-focus-guard="true"\n	data-focus-lock-disabled="false"\n	data-autofocus-inside="true"\n	data-popper-arrow="false"\n	data-oranges="true"\n	class="CLASS"\n	styles="\n		display: none;\n		width: 100%;\n		height: 30vh\n	"\n	type="TYPE"\n	target="TARGET"\n	rel="REL"\n	disabled="true"\n	focusable="false"\n	hidden="true"\n	width="WIDTH"\n	height="HEIGHT"\n	tabindex="TABINDEX"\n	for="FOR"\n	title="TITLE"\n	placeholder="PLACEHOLDER"\n	alt="ALT"\n	href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectHtmlNice = `GET EL RAW HTML STRING\n========== FOUND\n\n<h1>\nHEADING\n</h1>\n\n<main>\n\n<img\n	alt="icon plus"\n	src="./icon-plus.svg"\n	width="32"\n	height="32"/>\n\n<article>\n[SPx2]This[SPx3]is an article in the document[SPx2]\n</article>\n\n<hr />\n\n<footer\n	id="FOOTER"\n	name="NAME"\n	role="ROLE"\n	data-testid="DATA-TESTID"\n	aria-label="LABEL"\n	aria-description="ADESC"\n	aria-role="AROLE"\n	aria-rolel="AROLEL"\n	value="false"\n	focusable="true"\n	aria-hidden="false"\n	aria-modal="true"\n	aria-invalid="false"\n	aria-checked="true"\n	aria-expanded="false"\n	data-focus-guard="true"\n	data-focus-lock-disabled="false"\n	data-autofocus-inside="true"\n	data-popper-arrow="false"\n	data-oranges="true"\n	class="CLASS"\n	styles="\n		display: none;\n		width: 100%;\n		height: 30vh\n	"\n	type="TYPE"\n	target="TARGET"\n	rel="REL"\n	disabled="true"\n	focusable="false"\n	hidden="true"\n	width="WIDTH"\n	height="HEIGHT"\n	tabindex="TABINDEX"\n	for="FOR"\n	title="TITLE"\n	placeholder="PLACEHOLDER"\n	alt="ALT"\n	href="#HREF">\nfooter\n</footer>\n\n</main>\n`;
   const expectTextNiceOld = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		alt="icon plus"\n		width="32"\n		height="32"/>\n\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n\n	<footer \n		id="FOOTER"\n		name="NAME"\n		role="ROLE"\n		data-testid="DATA-TESTID"\n		aria-label="LABEL"\n		aria-description="ADESC"\n		aria-role="AROLE"\n		aria-rolel="AROLEL"\n		focusable="true"\n		aria-hidden="false"\n		aria-modal="true"\n		aria-invalid="false"\n		aria-checked="true"\n		aria-expanded="false"\n		data-focus-guard="true"\n		data-focus-lock-disabled="false"\n		data-autofocus-inside="true"\n		data-popper-arrow="false"\n		data-oranges="true"\n		type="TYPE"\n		target="TARGET"\n		rel="REL"\n		disabled="true"\n		focusable="false"\n		hidden="true"\n		width="WIDTH"\n		height="HEIGHT"\n		tabindex="TABINDEX"\n		for="FOR"\n		title="TITLE"\n		placeholder="PLACEHOLDER"\n		alt="ALT"\n		href="#HREF">\n\nfooter\n\n`;
   const expectTextNice1Old = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		src="./icon-plus.svg"/>\n\n[SPACE][SPACE]This   is an article in the document[SPACE][SPACE]\n\n	<footer \n		value="false"\n		class="CLASS"\n		style="display: none;width: 100%;height: 30vh;">\n\nfooter\n\n`;
   const expectTextNice = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		alt="icon plus"\n		width="32"\n		height="32"/>\n\n[SPx2]This[SPx3]is an article in the document[SPx2]\n\n	<footer \n		id="FOOTER"\n		name="NAME"\n		role="ROLE"\n		data-testid="DATA-TESTID"\n		aria-label="LABEL"\n		aria-description="ADESC"\n		aria-role="AROLE"\n		aria-rolel="AROLEL"\n		focusable="true"\n		aria-hidden="false"\n		aria-modal="true"\n		aria-invalid="false"\n		aria-checked="true"\n		aria-expanded="false"\n		data-focus-guard="true"\n		data-focus-lock-disabled="false"\n		data-autofocus-inside="true"\n		data-popper-arrow="false"\n		data-oranges="true"\n		type="TYPE"\n		target="TARGET"\n		rel="REL"\n		disabled="true"\n		focusable="false"\n		hidden="true"\n		width="WIDTH"\n		height="HEIGHT"\n		tabindex="TABINDEX"\n		for="FOR"\n		title="TITLE"\n		placeholder="PLACEHOLDER"\n		alt="ALT"\n		href="#HREF">\n\nfooter\n\n`;
   const expectTextNice1 = `GET EL RAW HTML STRING\n========== FOUND\n\nHEADING\n\n	<img \n		src="./icon-plus.svg"/>\n\n[SPx2]This[SPx3]is an article in the document[SPx2]\n\n	<footer \n		value="false"\n		class="CLASS"\n		style="display: none;width: 100%;height: 30vh;">\n\nfooter\n\n`;

   EX_AS_JS = true;
   const html = getHtml( rawHtmlNoNL );
   const htmlOld = getHtml( rawHtmlNoNL, SPC );
   expectToBe( rawHtml, rawHtml, 'getHtml(rawHtml) should return HTML with newlines in it as is, does not recognise it as raw HTML' );
   expectToBe( html, expectHtmlNoNL, 'getHtml(rawHtml minus \\n) should return the HTML formatted minimally' );
   expectToBe( htmlOld, expectHtmlNoNLOld, 'getHtml(rawHtml minus \\n, SPC) should return the HTML formatted minimally with [SPACE] markers' );
   expectToBe( getHtml( rawHtmlNoNL, '\\s' ), expectHtmlSpc, 'getHtml(with \\s marker) should return the HTML with \\s as space marker' );
   expectToBe( getHtmlNice( rawHtmlNoNL ), expectHtmlNice, 'getHtmlNice(rawHtml minus \\n) should return the HTML formatted one element per line' );
   expectToBe( getHtmlNice( rawHtmlNoNL, SPC ), expectHtmlNiceOld, 'getHtmlNice(rawHtml minus \\n, SPC) should return the HTML formatted one element per line with [SPACE] markers' );
   expectToBe( getHtmlNice( rawHtmlNoNL, '\\s' ), expectHtmlNiceOld.replace( /\[SPACE\]/g, '\\s' ), 'getHtmlNice(with \\s marker) should return the HTML with \\s as space markers' );

   if ( FLIP )
   {
	  expectToBe( getTextNice( rawHtmlNoNL ), expectTextNice1, 'getTextNice1(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
	  expectToBe( getTextNice( rawHtmlNoNL, SPC ), expectTextNice1Old, 'getTextNice1(rawHtml minus \\n, SPC) should return the Text with only HTML elements showing relevant attributes and [SPACE] markers' );
	  expectToBe( getTextNice( rawHtmlNoNL, '@' ), expectTextNice1Old.replace( /\[SPACE\]/g, '@' ), 'getTextNice1(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
   } else
   {
	  expectToBe( getTextNice( rawHtmlNoNL ), expectTextNice, 'getTextNice2(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
	  expectToBe( getTextNice( rawHtmlNoNL, SPC ), expectTextNiceOld, 'getTextNice2(rawHtml minus \\n, SPC) should return the Text with only HTML elements showing relevant attributes and [SPACE] markers' );
	  expectToBe( getTextNice( rawHtmlNoNL, '@' ), expectTextNiceOld.replace( /\[SPACE\]/g, '@' ), 'getTextNice2(rawHtml minus \\n) should return the Text with only HTML elements showing relevant attributes' );
   }

   EX_AS_JS = false;
   if ( NOISY )
   {
	  console.warn( `\ngetHtml: `, html );
	  console.warn( `\ngetHtmlNice: `, getHtmlNice( rawHtmlNoNL ) );
	  console.warn( `\ngetTextNice: `, getTextNice( rawHtmlNoNL ) );
   }

   window.document = document;
   //trace(`window`, window);

   expectToEqual( freezeTime(), '2024-07-04T01:02:03.000Z', 'freezeTime() should return the specific date' );

   const jestSpy = jest.fn();
   if ( NOISY )
   {
	  logMock( void 0, logMock );
	  logMock( 'HEREWEARE', jestSpy );
   }

   const quoted = quotemeta( '/^(.+)[a-z]*?(a|b{2,}|\t\x0d\x0a\u2026)$/' );
   expectToBe( quoted, '\\/\\^\\(\\.\\+\\)\\[a-z\\]\\*\\?\\(a\\|b\\{2,\\}\\|\t\x0d\x0a\u2026\\)\\$\\/', 'quotemeta() should escape regex meta characters in the string' );
   expectToMatch( new RegExp( quoted ), '/^(.+)[a-z]*?(a|b{2,}|\t\x0d\x0a\u2026)$/', 'quoted regex should match content' );

   if ( LET_FAIL_TESTS )
   {
	  checkPageIds();
   }
   checkPageIds( document.body.innerHTML.replace( 'mypara', `${appId}-mypara` ) );

   checkUndefined( '$14.00' );
   checkUndefined( `${LS}14.00` );
   checkUndefined( '<a focusable="false">' );
   checkUndefined( 'BaNaNa' );
   if ( LET_FAIL_TESTS )
   {
	  checkUndefined( '$NaN' );
	  checkUndefined( `${LS}NaN` );
	  checkUndefined( 'focusable="false" value="true"' );
	  checkUndefined( 'undefined' );
	  checkUndefined( 'null' );
	  checkUndefined( 'NaN' );
	  checkUndefined( 'Infinity' );
	  checkUndefined( {}.toString() );
	  checkUndefined( noop.toString() );
   }

   window.getComputedStyle = () => { return { visibility: 'visible' } };
   const dialogElOpen = {
	  tagName: 'div',
	  attributes: [ {
		 name: 'role',
		 value: 'dialog',
	  }, {
		 name: 'aria-modal',
		 value: 'true',
	  }, {
		 name: 'aria-hidden',
		 value: 'false',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as HTMLElement;
   const dialogElClosed = {
	  tagName: 'div',
	  attributes: [ {
		 name: 'hidden',
		 value: '',
	  }, {
		 name: 'role',
		 value: 'dialog',
	  }, {
		 name: 'aria-modal',
		 value: 'true',
	  }, {
		 name: 'aria-hidden',
		 value: 'true',
	  }],
	  innerHTML: '',
	  innerText: '',
   } as unknown as HTMLElement;

   checkDialogClosed( dialogElClosed );
   checkDialogOpen( dialogElOpen );
   if ( LET_FAIL_TESTS )
   {
	  checkDialogOpen( dialogElClosed );
	  checkDialogClosed( dialogElOpen );
   }

   const expectIdentity = `	id="FOOTER"\n	name="NAME"\n	role="ROLE"\n	data-testid="DATA-TESTID"\n	aria-label="LABEL"\n	aria-description="ADESC"\n	aria-role="AROLE"\n	aria-rolel="AROLEL"\n	data-focus-guard="true"\n	data-focus-lock-disabled="false"\n	data-autofocus-inside="true"\n	data-popper-arrow="false"\n	data-oranges="true"`;

   expectToBe( getIdentity(), '\tid="mypara"', 'getIdentity() should show all relevant identity attributes in the document' );
   expectToBe( getIdentity( html ), expectIdentity, 'getIdentity() should show all relevant identity attributes in the document' );

   const expectExpectations = `\n    \n    // render() your component...\n    console.warn('IDENTITY', getIdentity());\n    const before = getHtmlNice();\n    console.warn('RENDER', before);\n    expect(checkUndefined()).toBeTruthy();\n    expect(checkPageIds()).toBeTruthy();\n    expect(checkDocumentTextEmpty()).toBeTruthy();\n    expect(checkDialogOpen(dialog)).toBeTruthy();\n    expect(screen.queryByText(/^\\s*version\\.nickname: JIRA-NNNN XYZY\\s*$/m)).toBeInTheDocument();\n    expect(screen.queryByTitle("tooltip text")).toBeInTheDocument();\n    // await userEvent.click()...\n    let after;\n    await waitFor(() => {\n        after = getHtmlNice();\n        expect(after).not.toBe(before);\n    });\n    // will show only what has changed in the HTML due to the user event.\n    expect(after).toBe(before);\n    `;

   expectToBe( getExpectations(), expectExpectations, 'getExpectations() should show test assertions to match the document' );

   const reRegex = /^regex/;
   const typeError = new TypeError( 'typeerr' );
   const aNumber = new Number( 3 );
   const aBoolean = new Boolean( false );
   const aString = new String( 'what' );
   const aDate = new Date( '2025-01-01' );
   const anObject = { a: 2 };
   const anArray = [ 1, '2', /a/g ];
   const emptyObject = {};
   const emptyArray = [];

   expectToBe( getTypeName( undefined ), '', 'getTypeName(undefined) should return empty string' );
   expectToBe( getTypeName( true ), '', 'getTypeName(true) should return empty string' );
   expectToBe( getTypeName( NaN ), '', 'getTypeName(NaN) should return empty string' );
   expectToBe( getTypeName( Infinity ), '', 'getTypeName(Infinity) should return empty string' );
   expectToBe( getTypeName( 0 ), '', 'getTypeName(0) should return empty string' );
   expectToBe( getTypeName( '' ), '', 'getTypeName("") should return empty string' );
   expectToBe( getTypeName( null ), 'Object ', 'getTypeName(null) should return Object' );
   expectToBe( getTypeName( reRegex ), 'RegExp ', 'getTypeName(RegExp) should return RegExp' );
   expectToBe( getTypeName( aDate ), 'Date ', 'getTypeName(Date) should return Date' );
   expectToBe( getTypeName( [] ), 'Array ', 'getTypeName(Array) should return Array' );
   expectToBe( getTypeName( {} ), 'Object ', 'getTypeName(Object) should return Object' );
   expectToBe( getTypeName( aNumber ), 'Number ', 'getTypeName(Number) should return Number' );
   expectToBe( getTypeName( aBoolean ), 'Boolean ', 'getTypeName(Boolean) should return Boolean' );
   expectToBe( getTypeName( aString ), 'String ', 'getTypeName(String) should return String' );
   expectToBe( getTypeName( typeError ), 'TypeError ', 'getTypeName(TypeError) should return TypeError' );
   expectToBe( getTypeName(() => null ), 'Function ', 'getTypeName(() => null) should return Function' );
   expectToBe( getTypeName( function named(): void { } ), 'Function ', 'getTypeName(function named) should return Function' );
   expectToBe( getTypeName( getTypeName ), 'Function ', 'getTypeName(getTypeName) should return Function' );

   // console.warn(`has Map?`, typeof global, typeof window, typeof global.Map, typeof document.createElement)
   // MUSTDO enable for ES6 environment...
   //expectToBe(getTypeName(new Map()), 'Map ', 'getTypeName(Map) should return Map');
   //expectToBe(getTypeName(document.createElement('input')), 'HTMLInputElement ', 'getTypeName(HTMLInputElement) should return HTMLInputElement');

   expectToBe( enquote( 'text' ), '\u201Ctext\u201D', 'enquote() should quote with left right double quotes by default' );
   expectToBe( enquote( 'text', 'lrsq' ), '\u2018text\u2019', 'enquote() should quote with left right single quotes by name' );
   expectToBe( enquote( 'text', '@' ), '@text@', 'enquote(@) should quote with a specific single character' );
   expectToBe( enquote( 'text', 'qQ' ), 'qtextQ', 'enquote(@) should quote with a specific pair of characters' );

   expectToBe( shortenDump( 'unquoted string' ), `unquoted string`, 'shortenDump() should not shorten' );
   expectToBe( shortenDump( 'unquoted string', 7 ), `unquote${EL}`, 'shortenDump(7) should shorten with ellipsis' );
   expectToBe( shortenDump( 'unquoted string', void 0, '@@' ), `@unquoted string@`, 'shortenDump(quotes:@@) should add custom quotes but not shorten it' );
   expectToBe( shortenDump( 'unquoted', 7, '@@' ), `@unquote${EL}@`, 'shortenDump(7,quotes:@@) should shorten with ellipsis and surround with custom quotes' );
   expectToBe( shortenDump( 'unquoted', 7, `${LDQ}${RDQ}` ), `${LDQ}unquote${EL}${RDQ}`, 'shortenDump(7,quotes) should shorten with ellipsis and surround with custom quotes' );
   expectToBe( shortenDump( 'unquoted\nstring' ), `unquoted\nstring`, 'shortenDump() should not shorten' );
   expectToBe( shortenDump( 'unquoted\nstring', 7 ), `unquote${EL}`, 'shortenDump(7) should shorten with ellipsis' );
   expectToBe( shortenDump( 'function () {}' ), `function () {}`, 'shortenDump(function) should not shorten function with ellipsis' );
   expectToBe( shortenDump( 'function () {}', 7 ), `function () {}`, 'shortenDump(function,7) should shorten function with ellipsis inside' );
   expectToBe( shortenDump( 'function () {}', 12 ), `function () {}`, 'shortenDump(function,12) should shorten function with ellipsis inside' );

   expectToBe( shortenDump( `${LDQ}quoted string${RDQ}`, void 0 ), `${LDQ}quoted string${RDQ}`, `shortenDump(${LDQ}${RDQ}quoted) should not shorten quoted string` );
   expectToBe( shortenDump( `${LDQ}quoted string${RDQ}`, 7 ), `${LDQ}quoted ${EL}${RDQ}`, `shortenDump(${LDQ}${RDQ}quoted,7) should not shorten inside quoted string` );
   expectToBe( shortenDump( '"quoted string"', void 0 ), `"quoted string"`, 'shortenDump("quoted) should not shorten quoted string' );
   expectToBe( shortenDump( '"quoted string"', 7 ), `"quoted ${EL}"`, 'shortenDump("quoted,7) should not shorten inside quoted string' );
   expectToBe( shortenDump( "'quoted string'", void 0 ), `'quoted string'`, "shortenDump('quoted) should not shorten quoted string" );
   expectToBe( shortenDump( "'quoted string'", 7 ), `'quoted ${EL}'`, "shortenDump('quoted,7) should not shorten inside quoted string" );
   expectToBe( shortenDump( "`quoted string`", void 0 ), '`quoted string`', "shortenDump(`quoted) should not shorten quoted string" );
   expectToBe( shortenDump( "`quoted string`", 7 ), `\`quoted ${EL}\``, "shortenDump(`quoted,7) should not shorten inside quoted string" );
   expectToBe( shortenDump( '(unquoted string)', 7 ), `(unquote${EL})`, 'shortenDump(parenthesis,7) should shorten inside theparenthesis string' );
   expectToBe( shortenDump( '<unquoted string/>', void 0 ), `<unquoted string/>`, 'shortenDump(HTML) should not shorten HTML element' );
   expectToBe( shortenDump( '<unquoted string/>', 7 ), `<unquote${EL}>`, 'shortenDump(HTML,7) should shorten the HTML element' );
   expectToBe( shortenDump( '{a:42,b:12,c:14}', void 0 ), `{a:42,b:12,c:14}`, 'shortenDump(Object) should not shorten JSON dump' );
   expectToBe( shortenDump( '{a:42,b:12,c:14}', 7 ), `{a:42,b:${EL}}`, 'shortenDump(Object,7) should shorten the JSON dump' );
   expectToBe( shortenDump( '[a,42,b,12,c,14]', void 0 ), `[a,42,b,12,c,14]`, 'shortenDump(Array) should not shorten Array JSON dump' );
   expectToBe( shortenDump( '[a,42,b,12,c,14]', 7 ), `[a,42,b,${EL}]`, 'shortenDump(Array,7) should shorten the Array JSON dump' );

   expectToBe( has( undefined ), '', 'has(undefined) should return empty string' );
   expectToBe( has( false ), false, 'has(false) should return boolean false' );
   expectToBe( has( NaN ), NaN, 'has(NaN) should return NaN' );
   expectToBe( has( Infinity ), Infinity, 'has(Infinity) should return Infinity' );
   expectToBe( has( 0 ), 0, 'has(0) should return 0' );
   expectToBe( has( '' ), '', 'has("") should return empty string' );
   expectToBe( has( null ), '', 'has(null) should return empty string' );
   expectToBe( has( reRegex ), reRegex, 'has(RegExp) should return stringified regex' );
   expectToBe( has( aDate ), aDate, 'has(Date) should return string Date' );
   expectToBe( has( emptyArray ), emptyArray, 'has(empty Array) should return empty Array with brackets' );
   expectToBe( has( emptyObject ), emptyObject, 'has(empty Object) should return stringified Object' );
   expectToBe( has( anArray ), anArray, 'has(Array) should return the Array' );
   expectToBe( has( anObject ), anObject, 'has(Object) should return the Object' );
   expectToBe( has( aNumber ), aNumber, 'has(Number) should return Number object' );
   expectToBe( has( aBoolean ), aBoolean, 'has(Boolean) should return Boolean object' );
   expectToBe( has( aString ), aString, 'has(String) should return String object itself' );
   expectToBe( has( typeError ), typeError, 'has(TypeError) should return TypeError' );
   expectToBe( has( getTypeName ), getTypeName, 'has(getTypeName) should return the Function itself' );

   expectToBe( str( undefined ), '', 'str(undefined) should return empty string' );
   expectToBe( str( false ), 'false', 'str(false) should return string false' );
   expectToBe( str( NaN ), 'NaN', 'str(NaN) should return string NaN' );
   expectToBe( str( Infinity ), 'Infinity', 'str(Infinity) should return string Infinity' );
   expectToBe( str( 0 ), '0', 'str(0) should return string 0' );
   expectToBe( str( '' ), '', 'str("") should return empty string' );
   expectToBe( str( null ), '', 'str(null) should return empty string' );
   expectToBe( str( reRegex ), '/^regex/', 'str(RegExp) should return stringified regex' );
   expectToBe( str( aDate ), 'Wed Jan 01 2025 00:00:00 GMT+0000 (Coordinated Universal Time)', 'str(Date) should return string Date' );
   expectToBe( str( [] ), '[]', 'str(empty Array) should return empty Array with brackets' );
   expectToBe( str( {} ), '[object Object]', 'str(empty Object) should return stringified Object' );
   expectToBe( str( [ 1, '2', /a/g ] ), '[1,2,/a/g]', 'str(Array) should return stringified Array with brackets' );
   expectToBe( str( { a: 2 } ), '[object Object]', 'str(Object) should return string Object' );
   expectToBe( str( aNumber ), '3', 'str(Number) should return string Number' );
   expectToBe( str( aBoolean ), 'false', 'str(Boolean) should return string Boolean' );
   expectToBe( str( aString ), 'what', 'str(String) should return String' );
   expectToBe( str( new TypeError( 'typeerr' ) ), 'TypeError: typeerr', 'str(TypeError) should return string TypeError' );
   expectToBe( str(() => null ), 'function () { return null; }', 'str(() => null) should return string Function body' );
   expectToBe( str( function named(): void { } ), 'function named() { }', 'str(function named) should return string Function body' );
   expectToBe( str( getTypeName ), `${getTypeName}`, 'str(getTypeName) should return string Function body' );

   // MUSTDO enable for ES6 environment...
   //expectToBe(str(new Map()), 'Map ', 'str(Map) should return stringified Map');
   //expectToBe(str(new Set()), 'Set ', 'str(Set) should return stringified Set');
   //expectToBe(str(document.createElement('input')), 'HTMLInputElement ', 'str(HTMLInputElement) should return HTMLInputElement');

   expectToBe( showThing(), `undefined`, 'showThing(undefined) should have no ellipsis' );
   expectToBe( showThing( null, 12 ), `null`, 'showThing(null) should have no ellipsis' );
   expectToBe( showThing( false, 12 ), `false`, 'showThing(false) should have no ellipsis' );
   expectToBe( showThing( NaN, 12 ), `NaN`, 'showThing(NaN) should have no ellipsis' );
   expectToBe( showThing( Infinity, 12 ), `Infinity`, 'showThing(Ininity) should have no ellipsis' );
   expectToBe( showThing( -Infinity, 12 ), `-Infinity`, 'showThing(Ininity) should have no ellipsis' );
   expectToBe( showThing( 123456789012, 12 ), `123456789012`, 'showThing(123456789012) should have no ellipsis' );
   expectToBe( showThing( '123456789012', 12 ), `${LDQ}123456789012${RDQ}`, 'showThing("123456789012") should have no ellipsis' );
   expectToBe( showThing( /^regexpres/, 12 ), `/^regexpres/`, 'showThing(/^regexpres/) should have no ellipsis' );
   expectToBe( showThing( aDate, 142 ), `Wed Jan 01 2025 00:00:00 GMT+0000 (Coordinated Universal Time)`, 'showThing(Date,142) should have no ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 12 ), `[1,2,3,4,52]`, 'showThing(Array) should have no ellipsis' );
   expectToBe( showThing( { a: 1, b: 2 }, 14 ), `{"a":1,"b":2}`, 'showThing(small Object,13) should have no ellipsis' );
   expectToBe( showThing( { a: 1, b: 2, c: 3, ddd: 4 }, 12 ), `keys: [a, b, c, ddd]`, 'showThing(Object/k) should have keys and no ellipsis' );
   expectToBe( showThing( new Number( 123456789012 ), 12 ), `123456789012`, 'showThing(Number) should have no ellipsis' );
   expectToBe( showThing( new Boolean( false ), 12 ), `false`, 'showThing(Boolean) should have no ellipsis' );
   expectToBe( showThing( new String( '123456789012' ), 12 ), `${LDQ}123456789012${RDQ}`, 'showThing(String) should have no ellipsis' );
   expectToBe( showThing( new TypeError( 'blah' ), 15 ), `TypeError: blah`, 'showThing(TypeError) should have no ellipsis' );
   expectToBe( showThing(() => null, 28 ), `function () { return null; }`, 'showThing(arrow function) should have no ellipsis' );
   expectToBe( showThing( function (): void { }, 15 ), `function () { }`, 'showThing(anon function) should have no ellipsis' );
   expectToBe( showThing( function named(): void { }, 20 ), `function named() { }`, 'showThing(named function) should have no ellipsis' );
   expectToBe( showThing( noop, 19 ), `function noop() { }`, 'showThing(function name) should have no ellipsis' );

   expectToBe( showThing( undefined, 2 ), `un${EL}`, 'showThing(undefined,2) should have ellipsis' );
   expectToBe( showThing( null, 2 ), `nu${EL}`, 'showThing(null,2) should have ellipsis' );
   expectToBe( showThing( false, 2 ), `fa${EL}`, 'showThing(false,2) should have ellipsis' );
   expectToBe( showThing( NaN, 2 ), `Na${EL}`, 'showThing(NaN,2) should have ellipsis' );
   expectToBe( showThing( Infinity, 2 ), `In${EL}`, 'showThing(Ininity,2) should have ellipsis' );
   expectToBe( showThing( -Infinity, 2 ), `-I${EL}`, 'showThing(-Ininity,2) should have ellipsis' );
   expectToBe( showThing( 123456789012, 2 ), `12${EL}`, 'showThing(123456789012,2) should have ellipsis' );
   expectToBe( showThing( '123456789012', 2 ), `${LDQ}12${EL}${RDQ}`, 'showThing("123456789012",2) should have ellipsis' );
   expectToBe( showThing( '123456789AB', 12 ), `${LDQ}123456789AB${RDQ}`, 'showThing(short string) should have no ellipsis' );
   expectToBe( showThing( '123456789ABC', 12 ), `${LDQ}123456789ABC${RDQ}`, 'showThing(just right) should have no ellipsis' );
   expectToBe( showThing( '123456789ABCD', 12 ), `${LDQ}123456789ABC${EL}${RDQ}`, 'showThing(longer string) should have no ellipsis' );
   expectToBe( showThing( /^regexpres/, 2 ), `/^${EL}/`, 'showThing(/^regexpres/,2) should have ellipsis' );
   expectToBe( showThing( aDate, 2 ), `We${EL}`, 'showThing(Date,2) should have ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 2 ), `[1,${EL}]`, 'showThing(Array,2) should have ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 3 ), `[1,2${EL}]`, 'showThing(Array,3) should have ellipsis' );
   expectToBe( showThing( [ 1, 2, 3, 4, 52 ], 4 ), `[1,2,${EL}]`, 'showThing(Array,4) should have ellipsis' );
   expectToBe( showThing( { a: 1, b: 2 }, 2 ), `keys: [a,${EL}]`, 'showThing(Object,2) should have keys and ellipsis' );
   expectToBe( showThing( { a: 1, b: 2, c: 3, ddd: 4 }, 2 ), `keys: [a,${EL}]`, 'showThing(Object/k,2) should have keys and ellipsis' );
   expectToBe( showThing( { a: 1, b: 2, c: 3, dddd: 4 }, 12 ), `keys: [a, b, c, ddd_]`, 'showThing(Object/k,12) should have keys and ellipsis' );
   expectToBe( showThing( new Boolean( false ), 2 ), `fa${EL}`, 'showThing(Boolean,2) should have ellipsis' );
   expectToBe( showThing( new Number( 123456789012 ), 2 ), `12${EL}`, 'showThing(Number,2) should have ellipsis' );
   expectToBe( showThing( new String( '123456789012' ), 2 ), `${LDQ}12${EL}${RDQ}`, 'showThing(String,2) should have ellipsis' );
   expectToBe( showThing( new TypeError( 'blah' ), 2 ), `Ty${EL}`, 'showThing(TypeError,2) should have ellipsis' );
   expectToBe( showThing(() => null, 11 ), `function () { return${EL}}`, 'showThing(arrow function,11) should have ellipsis' );
   expectToBe( showThing( function (): string { return 'S' }, 11 ), `function () { return${EL}}`, 'showThing(anon function,11) should have ellipsis' );
   expectToBe( showThing( function named(): void { }, 8 ), `function named() ${EL}}`, 'showThing(named function,8) should have ellipsis' );
   expectToBe( showThing( noop, 8 ), `function noop() {${EL}}`, 'showThing(function name,8) should have ellipsis' );

   // MUSTDO enable for ES6 environment...
   // const setSm = new Set([1,2,3,4,52]);
   // const mapSm = new Map([['a',1],['b',2]]);
   // const mapLg = new Map([['a',1],['b',2],['c',3],['dddd',4]]);
   // expectToBe(showThing(setSm, 12), `[1,2,3,4,52]`, 'showThing(Set) should have no ellipsis');
   // expectToBe(showThing(mapSm,14), `{"a":1,"b":2}`, 'showThing(small Map,13) should have no ellipsis');
   // expectToBe(showThing(setSm, 4), `[1,2${EL}]`, 'showThing(Set,4) should have ellipsis');
   // expectToBe(showThing(mapLg, 12), `keys: [a, b, c, ddd_]`, 'showThing(Map/k,12) should have keys and ellipsis');
   // const inEl = document.createElement('input');
   // inEl.setAttribute('name', 'phone');
   // inEl.setAttribute('placeholder', 'your phone number?');
   // expectToBe(showThing(inEl, 52), `[1,2,3,4,52]`, 'showThing(HTMLInputElement) should have no ellipsis');
   // expectToBe(showThing(inEl, 12), `[1,2,3,4,52]`, 'showThing(HTMLInputElement) should have ellipsis');

   const elDump: any = {
	  __reactInternalInstance1234: {
	  }
   };
   expectToBe( getElementInfo( elDump ), `NOT ELEM??? object Object  {"__reactInternalInstance1234":{}}`, 'getElementInfo(not) should respond with NOT ELEM??? message' );

   elDump.tagName = 'TAGNAME';
   elDump.src = 'SRC-omitted';
   elDump.id = 'ID';
   elDump.type = 'TEXT';
   elDump.role = 'ROLE';
   elDump[ 'aria-role' ] = 'AROLE';
   elDump.disabled = 'DISABLED';
   elDump.height = 'HEIGHT';
   elDump.tabIndex = 'TABINDEX';
   elDump[ 'aria-label' ] = 'ARLABEL';
   elDump.selected = 'SELECTED';
   elDump[ 'aria-invalid' ] = 'ARINVALID';
   elDump.placeholder = 'PLACEHOLDER';
   elDump.className = 'CLASSNAME';
   elDump.__reactInternalInstance1234 = {
	  elementType: 'REACTELEM',
	  pendingProps: {
		 id: 'IDp',
		 'data-testid': 'DATA-TESTIDp',
		 role: 'ROLEp',
		 target: 'TARGETp',
		 focusable: 'FOCUSABLEp',
		 hidden: 'HIDDENp',
		 'for': 'FORp',
		 value: 'VALUEp',
		 checked: 'CHECKEDp',
		 'aria-expanded': 'AREXPANDEDp',
		 alt: 'ALTp',
	  },
	  memoizedProps: {
		 id: 'IDm',
		 name: 'NAMEm',
		 role: 'ROLEm',
		 rel: 'RELm',
		 width: 'WIDTHm',
		 'aria-hidden': 'ARHIDDENm',
		 label: 'LABELm',
		 defaultValue: 'DEFVALUEm',
		 'aria-checked': 'ARCHECKEDm',
		 title: 'TITLEm',
		 href: 'HREFm',
	  },
   };

   expectToBe( getElementInfo(), `NOT ELEM??? undefined  undefined`, 'getElementInfo() should show NOT ELEM message' );
   if ( showAllPropSources )
   {
	  expectToBe( showThing( elDump ), `<REACTELEM#ID/IDp/IDm[data-testid="/DATA-TESTIDp/"][name="//NAMEm"][type="TEXT//"][role="ROLE/ROLEp/ROLEm"][aria-role="AROLE//"][_>`, 'showThing(Element/React1) should show the element shortened' );
	  expectToBe( getElementInfo( elDump ), `<REACTELEM#ID/IDp/IDm[data-testid="/DATA-TESTIDp/"][name="//NAMEm"][type="TEXT//"][role="ROLE/ROLEp/ROLEm"][aria-role="AROLE//"][target="/TARGETp/"][rel="//RELm"][disabled="DISABLED//"][focusable="/FOCUSABLEp/"][width="//WIDTHm"][height="HEIGHT//"][hidden="/HIDDENp/"][aria-hidden="//ARHIDDENm"][tabIndex="TABINDEX//"][for="/FORp/"][label="//LABELm"][aria-label="ARLABEL//"][value="/VALUEp/"][defaultValue="//DEFVALUEm"][selected="SELECTED//"][checked="/CHECKEDp/"][aria-checked="//ARCHECKEDm"][aria-invalid="ARINVALID//"][aria-expanded="/AREXPANDEDp/"][title="//TITLEm"][placeholder="PLACEHOLDER//"][alt="/ALTp/"][href="//HREFm"].CLASSNAME//. Object />`, 'getElementInfo(Element/React1) should respond with Element and React values' );
   } else
   {
	  expectToBe( showThing( elDump ), `<REACTELEM#ID[data-testid="DATA-TESTIDp"][name="NAMEm"][type="TEXT"][role="ROLE"][aria-role="AROLE"][target="TARGETp"][rel="RELm"_>`, 'showThing(Element/React2) should show the element shortened' );
	  expectToBe( getElementInfo( elDump ), `<REACTELEM#ID[data-testid="DATA-TESTIDp"][name="NAMEm"][type="TEXT"][role="ROLE"][aria-role="AROLE"][target="TARGETp"][rel="RELm"][disabled="DISABLED"][focusable="FOCUSABLEp"][width="WIDTHm"][height="HEIGHT"][hidden="HIDDENp"][aria-hidden="ARHIDDENm"][tabIndex="TABINDEX"][for="FORp"][label="LABELm"][aria-label="ARLABEL"][value="VALUEp"][defaultValue="DEFVALUEm"][selected="SELECTED"][checked="CHECKEDp"][aria-checked="ARCHECKEDm"][aria-invalid="ARINVALID"][aria-expanded="AREXPANDEDp"][title="TITLEm"][placeholder="PLACEHOLDER"][alt="ALTp"][href="HREFm"].CLASSNAME. Object />`, 'getElementInfo(Element/React2) should respond with Element and React values' );
   }

   delete elDump.__reactInternalInstance1234;
   if ( showAllPropSources )
   {
	  expectToBe( getElementInfo( elDump ), `<TAGNAME#ID//[type="TEXT//"][role="ROLE//"][aria-role="AROLE//"][disabled="DISABLED//"][height="HEIGHT//"][tabIndex="TABINDEX//"][aria-label="ARLABEL//"][selected="SELECTED//"][aria-invalid="ARINVALID//"][placeholder="PLACEHOLDER//"].CLASSNAME//. Object />`, 'getElementInfo(Element1) should respond with Element values only' );
   } else
   {
	  expectToBe( getElementInfo( elDump ), `<TAGNAME#ID[type="TEXT"][role="ROLE"][aria-role="AROLE"][disabled="DISABLED"][height="HEIGHT"][tabIndex="TABINDEX"][aria-label="ARLABEL"][selected="SELECTED"][aria-invalid="ARINVALID"][placeholder="PLACEHOLDER"].CLASSNAME. Object />`, 'getElementInfo(Element2) should respond with Element values only' );
   }

   // MUSTDO enable for browser/DOM environment...
   //console.warn(`getElementInfo`, getElementInfo(inEl))
   //expectToBe(getElementInfo(inEl), `<INPUT />`, 'getElementInfo(HTMLInputElement) should respond with HTMLInputElement values');

   expectToBe( showEvent(), `NOT EVENT??? undefined  undefined`, `showEvent() should show NOT EVENT message` );
   const event = {
	  timestamp: '1719410356201',
	  type: 'CLICK',
	  eventPhase: '3',
	  isTrusted: true,
	  bubbles: true,
	  cancellable: true,
	  defaultPrevented: true,
	  isPersistent: true,
	  isDefaultPrevented: true,
	  isPropagationStopped: true,

	  details: 'DETAILS',

	  metaKey: true,
	  ctrlKey: false,
	  shiftKey: true,
	  altKey: false,
	  getModifierState: 'MODSTATE',
	  button: 'BUTTON',
	  buttons: 'BUTTONs',

	  screenX: 12,
	  screenY: 43,
	  clientX: 23,
	  clientY: 0,
	  pageX: 0,
	  pageY: 32,
	  movementX: 0,
	  movementY: 0,

	  nativeEvent: {},
	  dispatchConfig: {
		 phasedRegistrationNames: [ 'ONCLICK', 'ONCLICKCAPTURE' ],
	  },
	  // Elements
	  target: elDump,
	  currentTarget: openInput,
	  relatedTarget: dialogElOpen,
	  view: { what: 'VIEW' },
   };
   // console.warn(`showEvent`, showEvent(event))

   let targetDump = `<TAGNAME#ID//[type="TEXT//"][role="ROLE//"][aria-role="AROLE//"][disabled="DISABLED//"][height="HEIGHT//"][tabIndex="TABINDEX//"][aria-label="ARLABEL//"][selected="SELECTED//"][aria-invalid="ARINVALID//"][placeholder="PLACEHOLDER//"].CLASSNAME//. Object />`;
   if ( !showAllPropSources )
   {
	  targetDump = targetDump.replace( /\/\//g, '' );
   }
   const currentDump = `<input Object />`;
   const relatedDump = `<div Object />`;

   expectToBe( showEvent( event, 'PREFIX:' ), `PREFIX:EVENT Object CLICK/@1719410356201 ONCLICK ONCLICKCAPTURE eventPhase(3) isTrusted bubbles cancellable defaultPrevented isPersistent isDefaultPrevented isPropagationStopped \ndetails(DETAILS) metaKey shiftKey \nbutton buttons screenXY(12,43)clientXY(23,0)pageXY(0,32)\ntarget: ${targetDump}\ncurrentTarget: ${currentDump}\nrelatedTarget: ${relatedDump}\nview: object Object  {"what":"VIEW"}`, `showEvent(event) should show event details` );

   const spacesHyphens = '  \f\n\r\t\v | \x20 \x09 \x0a \x0b \x0c \x0d \x0d\x0a \xa0 \xad | \u0020 \u0009 \u000a \u000b \u000c \u000d \u000d\u000a \u00a0 \u00ad \u202F \uFEFF \u2000 \u2001 \u2002 \u2003 \u2004 \u2005 \u2006 \u2007 \u2008 \u2009 \u200A \u200B \u205F \u3000 \u303F \u2010 \u2011 \u2027 \uFE63 \uFF0D';

   EX_AS_JS = true;
   expectToBe( indicateSpaces( spacesHyphens ), `[SPx2][FF]\n[LF]\n[CR]\n[TAB][VT]\n |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] [NARROW.NBSP] [ZERO.NBSP] [EN.QUAD] [EM.QUAD] [EN.SPACE] [EM.SPACE] [THREE.PER.EM.SPACE] [FOUR.PER.EM.SPACE] [SIX.PER.EM.SPACE] [FIGURE.SPACE] [PUNCT.SPACE] [THIN.SPACE] [HAIR.SPACE] [ZERO.SPACE] [MED.MATH.SPACE] [IDEOGRAPHIC.SPACE] [IDEOGRAPHIC.HALF.FILL.SPACE] [HYPHEN] [NB.HYPHEN] [HYPHEN.POINT] [SMALL.HYPHEN] [FULL.WIDTH.HYPHEN]`, 'indicateSpaces() should show various white space and hypens as [TEXT]' );
   expectToBe( indicateSpaces( replaceCharsCodePt( spacesHyphens ) ), `[SPx2][FF]\n[LF]\n[CR]\n[TAB][VT]\n |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] |[SPx3][TAB] [LF]\n [VT]\n [FF]\n [CR]\n [CR]\n[LF]\n [NBSP] [SOFT.HYPHEN] [U+202F] [U+FEFF] [U+2000] [U+2001] [U+2002] [U+2003] [U+2004] [U+2005] [U+2006] [U+2007] [U+2008] [U+2009] [U+200A] [U+200B] [U+205F] [U+3000] [U+303F] [U+2010] [U+2011] [U+2027] [U+FE63] [U+FF0D]`, 'replaceCharsCodePt() should show all unicode code points in the string.' );

   testSummary();
