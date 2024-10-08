import JSON5 from 'json5'
import platform from 'platform'
import { describe, expect, test } from '@jest/globals'
import './setupBrowserEnvTests'
import { JSONDateish, rePrefixedDate } from '../JSONDate'
import getPlatformModernizr from '../platform-modernizr'
import getPlatformFeatures from '../platform-feature'
import { JSONDebugLimits } from '../JSONDebug'
import { JSONRegExpish } from '../JSONRegExp'
import { PlatformFeatures } from '../platform-system'
import { JSONSetish } from '../JSONSet'
import { JSONMapish } from '../JSONMap'
import * as testMe from '../JSONDebug'

const displayName = 'JSONDebug'

describe(`${displayName} module tests`, function descJSONDebugModuleSuite() {
	type stuff = string | number | boolean
	type kvPair = [stuff, stuff]
	type kvPairs = kvPair[]

	const setItems: stuff[] = ['hello', 42, false, 'world']

	const mapItems: kvPairs = [
		['hello', 42],
		[false, 'world'],
		[45, 'sided'],
		['thicken', true],
	]

	function fnFunc(x: number, y: number, z = 0) {
		return (x + y) * z
	}

	const date = new Date()
	const reDate = /^"?[-0-9]+T[.:0-9]+Z"?$/
	const regex = /^this is the source$/gimuy
	const set = new Set(setItems)
	const map = new Map(mapItems)

	interface Big {
		void?
		null?: null
		boolean?: boolean
		number?: number
		bigint?: bigint
		string?: string
		reDate?: RegExp
		fnFunc?: typeof fnFunc
		date?: Date | JSONDateish
		set?: Set<stuff> | JSONSetish<stuff>
		map?: Map<stuff, stuff> | JSONMapish<stuff, stuff>
		array?: number[]
		object?: object
		unknown?: stuff[]
		dateErr?: stuff[]
		regexErr?: stuff[]
	}
	const Big = {
		void: void 0,
		null: null,
		boolean: true,
		number: 554,
		// bigint: 2352345234523452345n, only for target ES2020+
		string: 'man this string is long, man this string is long, man this string is long, man this string is long!',
		reDate,
		fnFunc,
		date,
		set,
		map,
		array: [1, 2, 3, 4, 5, 6, 7, 8],
		object: {
			a: 1,
			b: 2,
			c: 3,
			d: 4,
			e: 5,
			f: 6,
			g: 7,
			h: 8,
			i: 9,
			j: 10,
			k: 11,
			l: 12,
			m: 13,
			n: 14,
			o: 15,
		},
	}
	const bigArray = Big.array
	const bigObject = Big.object

	const limits: JSONDebugLimits = {
		withFunctions: false,
		items: 14,
		arrayLimit: 6,
		setLimit: 2,
		mapLimit: 1,
		stringLimit: 64,
		ellipsis: '...',
		mapEllipsis: ['...', '...'],
	}

	const limitsNoEllipsis: JSONDebugLimits = {
		withFunctions: false,
		items: 14, // default limit of keys/entries for objects, arrays, sets and maps
		arrayLimit: 4,
		setLimit: 3,
		mapLimit: 2,
		stringLimit: 32,
		ellipsis: '',
		mapEllipsis: testMe.NO_ELLIPSIS[0],
	}

	const limited = testMe.getJSONDebugger(limits)
	const limitedNoEllipsis = testMe.getJSONDebugger(limitsNoEllipsis)
	const limitedDefaults = testMe.getJSONDebugger({})
	const limitedDefaultsEllipsis = testMe.getJSONDebugger(
		{
			items: limitsNoEllipsis.items,
			arrayLimit: limitsNoEllipsis.arrayLimit,
			stringLimit: limitsNoEllipsis.stringLimit,
		},
		{
			postReplacer: function (key, value) {
				if (typeof value === 'string') {
					return value
						.replace(/hello/i, 'Hola!!')
						.replace(/world/i, 'Universidad')
				}
				return value
			},
			// For coverage, we add them explicitly.
			preReplacer: testMe.identityReplacer,
			preReviver: testMe.identityReplacer,
			postReviver: testMe.identityReplacer,
		},
	)

	describe('JSON.stringify limits', function descJSONStringifySuite() {
		test('JSON.stringify does not handle RegExp objects', function testJSONStringifyRegExp() {
			const got = JSON.stringify(regex)
			expect(got).toBe('{}') // Not very useful
		})

		test('JSON.stringify does handle Date objects as string value but could be better', function testJSONStringifyDate() {
			const got = JSON.stringify(new Date())
			expect(got).toMatch(reDate) // somewhat useful but not as reversable or useful for debugging logs
		})

		test('JSON.stringify does not handle Function objects', function testJSONStringifyFunction() {
			const got = JSON.stringify({
				split: function SplitMe(str: string, ch: string | RegExp) {
					return str.split(ch)
				},
			})
			expect(got).toBe('{}') // Not very useful would at least be nice to know there was a function there
		})

		test('JSON.stringify does not handle Set objects', function testJSONStringifySet() {
			const got = JSON.stringify(set)
			expect(got).toBe('{}') // Not very useful
		})

		test('JSON.stringify does not handle Map objects', function testJSONStringifyMap() {
			const got = JSON.stringify(map)
			expect(got).toBe('{}') // Not very useful
		})
		test('JSON.stringify does not handle WeakMap objects', function testJSONStringifyWeakMap() {
			type kvPairWM = [object, string]
			type kvPairsWM = kvPairWM[]

			const weakMap = new WeakMap([
				[map, 'MAP'],
				[global, 'GLOBAL'],
			] as kvPairsWM)
			const got = JSON.stringify(weakMap)
			expect(got).toBe('{}') // Not very useful, BUT weak map cannot iterate its keys so it's all that is possible
		})
	}) // JSON.stringify limitations

	describe('replacerDebug()', function descJSONDebugReplacerDebugSuite() {
		test('should handle a String with replacerDebug', function testJSONDebugReplacerDebugString() {
			const json = JSON.stringify(
				'this is the string of stuff',
				testMe.replacerDebug,
			)
			expect(json).toBe('"this is the string of stuff"')
		})

		test('should handle a Function with replacerDebug', function testJSONDebugReplacerDebugFunction() {
			const json = JSON.stringify(fnFunc, testMe.replacerDebug)
			expect(json).toBe('["object:JSONFunction","fnFunc",2]')
		})

		test('should handle a RegExp with replacerDebug', function testJSONDebugReplacerDebugRegExp() {
			const json = JSON.stringify(regex, testMe.replacerDebug)
			expect(JSON.parse(json) as JSONRegExpish).toEqual([
				'object:JSONRegExp',
				'^this is the source$',
				'gimuy',
			])
		})

		test('should handle a Date with replacerDebug', function testJSONDebugReplacerDebugDate() {
			const json = JSON.stringify(new Date(), testMe.replacerDebug)
			const date = JSON.parse(json) as JSONDateish
			expect(date.length).toBe(3)
			expect(date[0]).toBe('object:JSONDate')
			expect(date[1]).toMatch(rePrefixedDate)
			expect(Object.keys(date[2] ?? {})).toEqual([
				'utc',
				'epoch',
				'timeFormatted',
				'localeFormatted',
				'locale',
				'calendar',
				'numberingSystem',
				'timeZone',
				'year',
				'month',
				'day',
			])
		})

		test('should handle a Set with replacerDebug', function testJSONDebugReplacerDebugSet() {
			const json = JSON.stringify(set, testMe.replacerDebug)
			expect(JSON.parse(json) as JSONSetish<stuff>).toEqual([
				'object:JSONSet',
				...setItems,
			])
		})

		test('should handle a Map with replacerDebug', function testJSONDebugReplacerDebugMap() {
			const json = JSON.stringify(map, testMe.replacerDebug)
			expect(JSON.parse(json) as JSONMapish<stuff, stuff>).toEqual([
				'object:JSONMap',
				...mapItems,
			])
		})

		test('should output everything with JSON.stringify and replacerDebug', function testJSONDebugReplacerDebugEverything() {
			const json = JSON.stringify(Big, testMe.replacerDebug)

			// No damage to the object when stringified
			expect(Big.array).toBe(bigArray)
			expect(Big.object).toBe(bigObject)

			const obj = JSON.parse(json) as Big
			expect(Object.keys(obj).sort()).toEqual([
				'array',
				'boolean',
				'date',
				'fnFunc',
				'map',
				'null',
				'number',
				'object',
				'reDate',
				'set',
				'string',
			])
			expect(obj.boolean).toBe(Big.boolean)
			expect(obj.null).toBe(Big.null)
			expect(obj.number).toBe(Big.number)
			expect(obj.string).toBe(Big.string)
			expect(obj.fnFunc).toEqual(['object:JSONFunction', 'fnFunc', 2])

			const dd = obj.date as JSONDateish
			expect(dd.length).toBe(3)
			expect(dd[0]).toBe('object:JSONDate')
			expect(dd[1]).toMatch(rePrefixedDate)

			const extra = 1 // type name only, no ellipsis
			expect(obj.string).toHaveLength(Big.string.length)
			expect(obj.map).toHaveLength(mapItems.length + extra)
			expect(obj.set).toHaveLength(setItems.length + extra)

			expect(obj.array).toHaveLength(Big.array.length)
			expect(Object.keys(obj.object ?? {})).toHaveLength(
				Object.keys(Big.object).length,
			)

			expect(obj.map).toEqual(['object:JSONMap', ...mapItems])
			expect(obj.set).toEqual(['object:JSONSet', ...setItems])
			expect(obj.array).toEqual(Big.array)
			expect(obj.object).toEqual(Big.object)
		})

		test('should output everything with JSON5.stringify and replacerDebug', function testJSON5StringifyEverything() {
			const json = JSON5.stringify(Big, {
				quote: '"',
				space: '  ',
				replacer: testMe.replacerDebug,
			})

			// No damage to the object when stringified
			expect(Big.array).toBe(bigArray)
			expect(Big.object).toBe(bigObject)

			const obj: Big = JSON5.parse(json)
			expect(Object.keys(obj).sort()).toEqual([
				'array',
				'boolean',
				'date',
				'fnFunc',
				'map',
				'null',
				'number',
				'object',
				'reDate',
				'set',
				'string',
			])
			expect(obj.boolean).toBe(Big.boolean)
			expect(obj.null).toBe(Big.null)
			expect(obj.number).toBe(Big.number)
			expect(obj.string).toBe(Big.string)
			expect(obj.fnFunc).toEqual(['object:JSONFunction', 'fnFunc', 2])

			const dd = obj.date as JSONDateish
			expect(dd.length).toBe(3)
			expect(dd[0]).toBe('object:JSONDate')
			expect(dd[1]).toMatch(rePrefixedDate)

			const extra = 1 // type name only, no ellipsis
			expect(obj.string).toHaveLength(Big.string.length)
			expect(obj.map).toHaveLength(mapItems.length + extra)
			expect(obj.set).toHaveLength(setItems.length + extra)

			expect(obj.array).toHaveLength(Big.array.length)
			expect(Object.keys(obj.object ?? {})).toHaveLength(
				Object.keys(Big.object).length,
			)

			expect(obj.map).toEqual(['object:JSONMap', ...mapItems])
			expect(obj.set).toEqual(['object:JSONSet', ...setItems])
			expect(obj.array).toEqual(Big.array)
			expect(obj.object).toEqual(Big.object)
		})

		test('should handle platform and feature.js data with replacerDebug', function testJSONDebugReplacerDebugPlatformFeatures() {
			const system: PlatformFeatures = getPlatformFeatures(platform)
			const json = JSON.stringify(system, testMe.replacerDebug)

			const obj: PlatformFeatures = JSON5.parse(json, testMe.reviverDebug)
			expect(Object.keys(obj).sort()).toEqual([
				'description',
				'layout',
				'manufacturer',
				'name',
				'os',
				'prerelease',
				'product',
				'ua',
				'unsupportedFeatures',
				'version',
			])
			expect(obj.description).toMatch(/^Node\.js \d+\.\d+\.\d+ on /)
			expect(obj.unsupportedFeatures).toBe(
				'async contextMenu css3Dtransform deviceMotion deviceOrientation fetch geolocation matchMedia serviceWorker svg touch webGL',
			)
		}) // platform and feature.js

		test('should handle platform and modernizr data with replacerDebug', function testJSONDebugReplacerDebugPlatformModernizr() {
			const system: PlatformFeatures = getPlatformModernizr(platform)
			const json = JSON.stringify(system, testMe.replacerDebug)

			const obj: PlatformFeatures = JSON5.parse(json, testMe.reviverDebug)
			expect(Object.keys(obj).sort()).toEqual([
				'description',
				'layout',
				'manufacturer',
				'name',
				'os',
				'prerelease',
				'product',
				'ua',
				'unsupportedFeatures',
				'version',
			])
			expect(obj.description).toMatch(/^Node\.js \d+\.\d+\.\d+ on /)
			expect(obj.unsupportedFeatures).toBe(
				'ambientlight applicationcache audio:m4a: audio:mp3: audio:ogg: audio:opus: audio:wav: audiopreload backdropfilter battery-api batteryapi bdi beacon bgpositionshorthand bgrepeatround bgrepeatspace bloburls blobworkers capture checked contains contenteditable contextmenu createelement-attrs createelementattrs crypto csscalc csscolumns:breakafter:false csscolumns:breakbefore:false csscolumns:breakinside:false cssescape cssgradients cssgridlegacy cssinvalid csspseudoanimations csspseudotransitions cssreflections cssscrollbar csstransforms3d csstransformslevel2 cssvalid cssvhunit cssvmaxunit cssvminunit cssvwunit customprotocolhandler dart datachannel details devicemotion deviceorientation display-table displaytable emoji eventsource fetch fileinputdirectory filesystem flash flexboxlegacy flexboxtweener focuswithin forcetouch framed fullscreen gamepads generatedcontent geolocation getusermedia hairline hovermq htmlimports ie8compat indexeddb inlinesvg input-formaction input-formenctype inputformaction inputformenctype inputformmethod inputsearchevent inputtypes::false inputtypes:datetime:false lastchild localizednumber lowbandwidth lowbattery matchmedia mathml mediaqueries messagechannel microdata multiplebgs notification nthchild overflowscrolling peerconnection pointerevents pointerlock pointermq preserve3d proximity quotamanagement regions requestautocomplete ruby sandbox scriptasync seamless serviceworker sharedworkers siblinggeneral smil speechrecognition speechsynthesis stylescoped supports svg svgclippaths svgfilters svgforeignobject time todataurlwebp transferables unicode unicoderange userdata vibrate video:av1: video:h264: video:h265: video:hls: video:ogg: video:vp9: video:webm: videoautoplay vml webanimations webaudio webgl webglextensions webintents websqldatabase webworkers wrapflow xdomainrequest',
			)
		}) // platform and modernizr
	}) // replacerDebug()

	describe('getJSONDebug().replacer()', function descJSONDebugReplacerDebugLimitsSuite() {
		test('should limit number of items output with options', function testJSONDebugReplacerDebugLimits() {
			const json = JSON.stringify(Big, limited.replacer)

			// No damage to the object when stringified
			expect(Big.array).toBe(bigArray)
			expect(Big.object).toBe(bigObject)

			const obj = JSON.parse(json) as Big
			expect(obj.fnFunc).toBeUndefined()

			const extra = 2 // type name, plus ellipsis entry
			expect(obj.string).toHaveLength(
				(limits.stringLimit ?? 0) + (limits.ellipsis ?? '').length,
			)
			expect(obj.string).toMatch(/\.\.\.$/)

			expect(obj.map).toHaveLength((limits.mapLimit ?? 0) + extra)
			expect(obj.set).toHaveLength((limits.setLimit ?? 0) + extra)
			expect(obj.array).toHaveLength((limits.arrayLimit ?? 0) + 1)
			expect(Object.keys(obj.object ?? {})).toHaveLength(
				(limits.items ?? 0) + extra - 1,
			)

			expect(obj.map).toEqual([
				'object:JSONMap',
				['hello', 42],
				['...', '...'],
			])
			expect(obj.set).toEqual(['object:JSONSet', 'hello', 42, '...'])
			expect(obj.object).toEqual({
				a: 1,
				b: 2,
				c: 3,
				d: 4,
				e: 5,
				f: 6,
				g: 7,
				h: 8,
				i: 9,
				j: 10,
				k: 11,
				l: 12,
				m: 13,
				n: 14,
				'...': '...',
			})
			expect(obj.array).toEqual([1, 2, 3, 4, 5, 6, '...'])
		})

		test('should limit number of items with empty ellipsis', function testJSONDebugReplacerDebugLimitsEmptyEllipsis() {
			const json = JSON.stringify(Big, limitedNoEllipsis.replacer)

			// No damage to the object when stringified
			expect(Big.array).toBe(bigArray)
			expect(Big.object).toBe(bigObject)

			const obj = JSON.parse(json) as Big
			expect(obj.fnFunc).toBeUndefined()

			const extra = 1 // type name, plus ellipsis entry
			expect(obj.string).toHaveLength(
				(limitsNoEllipsis.stringLimit ?? 0) +
					(limitsNoEllipsis.ellipsis ?? '').length,
			)
			expect(obj.string).toBe('man this string is long, man thi')

			expect(obj.map).toHaveLength(
				(limitsNoEllipsis.mapLimit ?? 0) + extra,
			)
			expect(obj.set).toHaveLength(
				(limitsNoEllipsis.setLimit ?? 0) + extra,
			)
			expect(obj.array).toHaveLength(limitsNoEllipsis.arrayLimit ?? 0)
			expect(Object.keys(obj.object ?? {})).toHaveLength(
				(limitsNoEllipsis.items ?? 0) + extra - 1,
			)

			expect(obj.map).toEqual([
				'object:JSONMap',
				['hello', 42],
				[false, 'world'],
			])
			expect(obj.set).toEqual(['object:JSONSet', 'hello', 42, false])
			expect(obj.object).toEqual({
				a: 1,
				b: 2,
				c: 3,
				d: 4,
				e: 5,
				f: 6,
				g: 7,
				h: 8,
				i: 9,
				j: 10,
				k: 11,
				l: 12,
				m: 13,
				n: 14,
			})
			expect(obj.array).toEqual([1, 2, 3, 4])
		})

		test('should use default options to limit number of items (coverage)', function testJSONDebugReplacerDebugLimitsDefault() {
			const json = JSON.stringify(Big, limitedDefaults.replacer)

			// No damage to the object when stringified
			expect(Big.array).toBe(bigArray)
			expect(Big.object).toBe(bigObject)

			const obj = JSON.parse(json) as Big
			expect(obj.fnFunc).toBeUndefined()

			const extra = 1 // type name
			expect(obj.string).toHaveLength(Big.string.length)
			expect(obj.string).not.toMatch(/\.\.\.$/)

			expect(obj.map).toHaveLength(mapItems.length + extra)
			expect(obj.set).toHaveLength(setItems.length + extra)
			expect(obj.array).toHaveLength(Big.array.length)
			expect(Object.keys(obj.object ?? {})).toHaveLength(
				Object.keys(Big.object).length,
			)

			expect(obj.map).toEqual(['object:JSONMap', ...mapItems])
			expect(obj.set).toEqual(['object:JSONSet', ...setItems])
			expect(obj.object).toEqual(Big.object)
			expect(obj.array).toEqual(Big.array)
		})

		test('should use fnReplacer chain and default ellipsis settings when limit number of items (coverage)', function testJSONDebugReplacerDebugWithReplacerChain() {
			const json = JSON.stringify(Big, limitedDefaultsEllipsis.replacer)

			// No damage to the object when stringified
			expect(Big.array).toBe(bigArray)
			expect(Big.object).toBe(bigObject)

			const obj = JSON.parse(json) as Big
			expect(obj.fnFunc).toBeUndefined()

			const extra = 1 // type name
			expect(obj.string).toHaveLength(limitsNoEllipsis.stringLimit ?? 0)
			expect(obj.string).not.toMatch(/\.\.\.$/)

			expect(obj.map).toHaveLength(mapItems.length + extra)
			expect(obj.set).toHaveLength(setItems.length + extra)
			expect(obj.array).toHaveLength(limitsNoEllipsis.arrayLimit ?? 0)
			expect(Object.keys(obj.object ?? {})).toHaveLength(
				limitsNoEllipsis.items ?? 0,
			)

			expect(obj.map).toEqual([
				'object:JSONMap',
				['Hola!!', 42],
				[false, 'Universidad'],
				[45, 'sided'],
				['thicken', true],
			])
			expect(obj.set).toEqual([
				'object:JSONSet',
				'Hola!!',
				42,
				false,
				'Universidad',
			])
			expect(obj.object).toEqual({
				a: 1,
				b: 2,
				c: 3,
				d: 4,
				e: 5,
				f: 6,
				g: 7,
				h: 8,
				i: 9,
				j: 10,
				k: 11,
				l: 12,
				m: 13,
				n: 14,
			})
			expect(obj.array).toEqual([1, 2, 3, 4])
		})
	}) // getJSONDebug().replacer()

	describe('reviverDebug()/getJSONDebug().reviver()', function descJSONDebugReviverDebugSuite() {
		test('should handle a JSONFunction by omitting it', function testJSONDebugReviverDebugFunction() {
			const json = JSON.stringify(fnFunc, testMe.replacerDebug)
			const fn = JSON.parse(json, testMe.reviverDebug) as unknown
			expect(fn).toBeUndefined()
		})

		test('should handle a JSONRegExp with replacerDebug', function testJSONDebugReviverDebugRegExp() {
			const json = JSON.stringify(regex, testMe.replacerDebug)
			const reRevived = JSON.parse(json, testMe.reviverDebug) as RegExp
			expect(reRevived).toBeInstanceOf(RegExp)
			expect('this is the source').toMatch(reRevived)
		})

		test('should handle a JSONDate with replacerDebug', function testJSONDebugReviverDebugDate() {
			const json = JSON.stringify(new Date(), testMe.replacerDebug)
			const date = JSON.parse(json, testMe.reviverDebug) as Date
			expect(date).toBeInstanceOf(Date)
		})

		test('should handle a JSONSet with replacerDebug', function testJSONDebugReviverDebugSet() {
			const json = JSON.stringify(set, testMe.replacerDebug)
			const newSet = JSON.parse(json, testMe.reviverDebug) as Set<stuff>
			expect(newSet).toBeInstanceOf(Set)
			expect(Array.from(newSet.values())).toEqual(setItems)
		})

		test('should handle a JSONMap with replacerDebug', function testJSONDebugReviverDebugMap() {
			const json = JSON.stringify(map, testMe.replacerDebug)
			const newMap = JSON.parse(json, testMe.reviverDebug) as Map<
				stuff,
				stuff
			>
			expect(newMap).toBeInstanceOf(Map)
			expect(Array.from(newMap.entries())).toEqual(mapItems)
		})

		test('should revive everything sans functions', function testJSONDebugReviverDebugEverything() {
			const json = JSON.stringify(
				{
					...Big,
					unknown: ['object:Unsupported', 1, 1, 2, 3, 5, 8],
					dateErr: ['object:JSONDate'],
					regexErr: ['object:JSONRegExp'],
				},
				testMe.replacerDebug,
			)

			// No damage to the object when stringified
			expect(Big.array).toBe(bigArray)
			expect(Big.object).toBe(bigObject)

			const obj = JSON.parse(json, testMe.reviverDebug) as Big
			expect(Object.keys(obj).sort()).toEqual([
				'array',
				'boolean',
				'date',
				'dateErr',
				// 'fnFunc', not revived!
				'map',
				'null',
				'number',
				'object',
				'reDate',
				'regexErr',
				'set',
				'string',
				'unknown',
			])
			expect(obj.boolean).toBe(Big.boolean)
			expect(obj.null).toBe(Big.null)
			expect(obj.number).toBe(Big.number)
			expect(obj.string).toBe(Big.string)
			expect(obj.fnFunc).toBeUndefined()

			expect(obj.date).toBeInstanceOf(Date)
			expect((obj.date as Date).toJSON()).toMatch(reDate)

			expect(obj.string).toHaveLength(Big.string.length)
			const revivedMap = obj.map as Map<stuff, stuff>
			const revivedSet = obj.set as Set<stuff>
			expect(revivedMap.size).toBe(mapItems.length)
			expect(revivedSet.size).toBe(setItems.length)

			expect(obj.array).toHaveLength(Big.array.length)
			expect(Object.keys(obj.object ?? {})).toHaveLength(
				Object.keys(Big.object).length,
			)

			expect(Array.from(revivedMap.entries())).toEqual(mapItems)
			expect(Array.from(revivedSet.values())).toEqual(setItems)
			expect(obj.array).toEqual(Big.array)
			expect(obj.object).toEqual(Big.object)
			expect(obj.unknown).toEqual([
				'object:Unsupported',
				1,
				1,
				2,
				3,
				5,
				8,
			])
			expect(obj.dateErr).toBeInstanceOf(Date)
			expect(obj.regexErr).toBeInstanceOf(RegExp)
		})
	}) // reviverDebug()
}) // module tests
