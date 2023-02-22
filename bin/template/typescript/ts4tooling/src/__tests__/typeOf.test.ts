import { describe, expect, test } from '@jest/globals'
import typeOf from '../typeOf'

const displayName = 'typeOf'

describe(`${displayName}() module tests`, function descTypeOfSuite() {
	/* eslint-disable @typescript-eslint/no-unsafe-return */
	const fnThisIdentity = (x) => x
	const fnIdentity = function (x) {
		return x
	}
	/* eslint-enable @typescript-eslint/no-unsafe-return */

	test('primitive types', function testTypeOfPrimitive() {
		// undefined has no methods
		expect(typeOf(void 0)).toBe('undefined')

		/*
			In node v18.12.1
			> x = false
			> x.<TAB> to get the list of methods availble as shown below:

			A boolean has 8 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString

			x.constructor           x.toString              x.valueOf
		*/
		expect(typeOf(false)).toBe('boolean')
		expect(typeOf(true)).toBe('boolean')

		/*
			A number has 11 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable

			x.constructor           x.toExponential         x.toFixed               x.toLocaleString
			x.toPrecision           x.toString              x.valueOf
		*/
		expect(typeOf(0)).toBe('number')
		expect(typeOf(0.5)).toBe('number')
		expect(typeOf(-1)).toBe('number')
		expect(typeOf(1)).toBe('number')
		// unlike null, NaN and Infinity have all the same methods available as a valid number
		expect(typeOf(NaN)).toBe('number')
		expect(typeOf(Infinity)).toBe('number')

		/*
			A BigInt has 8 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable

			x.constructor           x.toLocaleString        x.toString              x.valueOf
		*/
		expect(typeOf(BigInt(0))).toBe('bigint')
		expect(typeOf(BigInt(-1))).toBe('bigint')
		expect(typeOf(BigInt(1))).toBe('bigint')
		// expect(typeOf(BigInt(0.5))).toBe('bigint') Cannot convert to BigInt
		// expect(typeOf(BigInt(NaN))).toBe('bigint') Cannot convert to BigInt
		// expect(typeOf(BigInt(Infinity))).toBe('bigint')

		/*
			A string has 55 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString

			x.anchor                x.at                    x.big                   x.blink
			x.bold                  x.charAt                x.charCodeAt            x.codePointAt
			x.concat                x.constructor           x.endsWith              x.fixed
			x.fontcolor             x.fontsize              x.includes              x.indexOf
			x.italics               x.lastIndexOf           x.length                x.link
			x.localeCompare         x.match                 x.matchAll              x.normalize
			x.padEnd                x.padStart              x.repeat                x.replace
			x.replaceAll            x.search                x.slice                 x.small
			x.split                 x.startsWith            x.strike                x.sub
			x.substr                x.substring             x.sup                   x.toLocaleLowerCase
			x.toLocaleUpperCase     x.toLowerCase           x.toString              x.toUpperCase
			x.trim                  x.trimEnd               x.trimLeft              x.trimRight
			x.trimStart             x.valueOf
		*/
		expect(typeOf('')).toBe('string')
		expect(typeOf('whatever')).toBe('string')
	}) // primitive types

	test('abnormal primitive types', function testTypeOfAbnormalPrimitive() {
		// null has no methods
		expect(typeOf(null)).toBe('null')
	}) // abnormal primitive types

	test('object-like types', function testTypeOfPrimitive() {
		/*
			An object has only 8 methods:

			x.__proto__             x.constructor           x.hasOwnProperty        x.isPrototypeOf
			x.propertyIsEnumerable  x.toLocaleString        x.toString              x.valueOf
		*/
		expect(typeOf({})).toBe('object')

		// A Number object 11 methods just like a number primitive
		expect(typeOf(new Number(87))).toBe('object:Number')

		/*
			A SyntaxError has 11 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString        x.valueOf

			x.toString

			x.constructor           x.name

			x.message               x.stack
		*/
		try {
			JSON.parse('let x = 42;')
		} catch (exception) {
			expect(typeOf(exception)).toBe('object:SyntaxError')
		}

		/*
			A WeakMap has 12 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString        x.toString              x.valueOf

			x.constructor           x.delete                x.get                   x.has
			x.set
		*/
		expect(typeOf(new WeakMap())).toBe('object:WeakMap')

		/*
			A function has 16 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString        x.valueOf

			x.apply                 x.bind                  x.call                  x.constructor
			x.toString

			x.arguments             x.caller                x.length                x.name
			x.prototype
		*/
		expect(typeOf(fnThisIdentity)).toBe('function')
		expect(typeOf(fnIdentity)).toBe('function')

		/*
			A Set has 17 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString        x.toString              x.valueOf

			x.add                   x.clear                 x.constructor           x.delete
			x.entries               x.forEach               x.has                   x.keys
			x.size                  x.values
		*/
		expect(typeOf(new Set())).toBe('object:Set')

		/*
			A Map has 18 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString        x.toString              x.valueOf

			x.clear                 x.constructor           x.delete                x.entries
			x.forEach               x.get                   x.has                   x.keys
			x.set                   x.size                  x.values
		*/
		expect(typeOf(new Map())).toBe('object:Map')

		/*
			A RegExp has 21 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.toLocaleString        x.valueOf

			x.compile               x.constructor           x.dotAll                x.exec
			x.flags                 x.global                x.hasIndices            x.ignoreCase
			x.multiline             x.source                x.sticky                x.test
			x.toString              x.unicode

			x.lastIndex
		*/
		expect(typeOf(/matchThis/)).toBe('object:RegExp')

		/*
			An Array has 41 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable
			x.valueOf

			x.at                    x.concat                x.constructor           x.copyWithin
			x.entries               x.every                 x.fill                  x.filter
			x.find                  x.findIndex             x.findLast              x.findLastIndex
			x.flat                  x.flatMap               x.forEach               x.includes
			x.indexOf               x.join                  x.keys                  x.lastIndexOf
			x.map                   x.pop                   x.push                  x.reduce
			x.reduceRight           x.reverse               x.shift                 x.slice
			x.some                  x.sort                  x.splice                x.toLocaleString
			x.toString              x.unshift               x.values

			x.length
		*/
		expect(typeOf([])).toBe('object:Array')

		/*
			A Date has 51 methods:
			x.__proto__             x.hasOwnProperty        x.isPrototypeOf         x.propertyIsEnumerable

			x.constructor           x.getDate               x.getDay                x.getFullYear
			x.getHours              x.getMilliseconds       x.getMinutes            x.getMonth
			x.getSeconds            x.getTime               x.getTimezoneOffset     x.getUTCDate
			x.getUTCDay             x.getUTCFullYear        x.getUTCHours           x.getUTCMilliseconds
			x.getUTCMinutes         x.getUTCMonth           x.getUTCSeconds         x.getYear
			x.setDate               x.setFullYear           x.setHours              x.setMilliseconds
			x.setMinutes            x.setMonth              x.setSeconds            x.setTime
			x.setUTCDate            x.setUTCFullYear        x.setUTCHours           x.setUTCMilliseconds
			x.setUTCMinutes         x.setUTCMonth           x.setUTCSeconds         x.setYear
			x.toDateString          x.toGMTString           x.toISOString           x.toJSON
			x.toLocaleDateString    x.toLocaleString        x.toLocaleTimeString    x.toString
			x.toTimeString          x.toUTCString           x.valueOf
		*/
		expect(typeOf(new Date())).toBe('object:Date')

		/*
			The node global has 164 methods:
			global.__proto__                         global.hasOwnProperty
			global.isPrototypeOf                     global.propertyIsEnumerable
			global.toLocaleString                    global.toString
			global.valueOf

			global.constructor

			global.AbortController                   global.AbortSignal
			global.AggregateError                    global.Array
			global.ArrayBuffer                       global.Atomics
			global.BigInt                            global.BigInt64Array
			global.BigUint64Array                    global.Blob
			global.Boolean                           global.BroadcastChannel
			global.Buffer                            global.ByteLengthQueuingStrategy
			global.CompressionStream                 global.CountQueuingStrategy
			global.DOMException                      global.DataView
			global.Date                              global.DecompressionStream
			global.Error                             global.EvalError
			global.Event                             global.EventTarget
			global.FinalizationRegistry              global.Float32Array
			global.Float64Array                      global.FormData
			global.Function                          global.Headers
			global.Infinity                          global.Int16Array
			global.Int32Array                        global.Int8Array
			global.Intl                              global.JSON
			global.Map                               global.Math
			global.MessageChannel                    global.MessageEvent
			global.MessagePort                       global.NaN
			global.Number                            global.Object
			global.Performance                       global.Promise
			global.Proxy                             global.RangeError
			global.ReadableByteStreamController      global.ReadableStream
			global.ReadableStreamBYOBReader          global.ReadableStreamBYOBRequest
			global.ReadableStreamDefaultController   global.ReadableStreamDefaultReader
			global.ReferenceError                    global.Reflect
			global.RegExp                            global.Request
			global.Response                          global.Set
			global.SharedArrayBuffer                 global.String
			global.Symbol                            global.SyntaxError
			global.TextDecoder                       global.TextDecoderStream
			global.TextEncoder                       global.TextEncoderStream
			global.TransformStream                   global.TransformStreamDefaultController
			global.TypeError                         global.URIError
			global.URL                               global.URLSearchParams
			global.Uint16Array                       global.Uint32Array
			global.Uint8Array                        global.Uint8ClampedArray
			global.WeakMap                           global.WeakRef
			global.WeakSet                           global.WebAssembly
			global.WritableStream                    global.WritableStreamDefaultController
			global.WritableStreamDefaultWriter       global._
			global._error                            global.assert
			global.async_hooks                       global.atob
			global.btoa                              global.buffer
			global.child_process                     global.clearImmediate
			global.clearInterval                     global.clearTimeout
			global.cluster                           global.console
			global.constants                         global.crypto
			global.decodeURI                         global.decodeURIComponent
			global.dgram                             global.diagnostics_channel
			global.dns                               global.domain
			global.encodeURI                         global.encodeURIComponent
			global.escape                            global.eval
			global.events                            global.fetch
			global.fs                                global.global
			global.globalThis                        global.http
			global.http2                             global.https
			global.inspector                         global.isFinite
			global.isNaN                             global.module
			global.net                               global.os
			global.parseFloat                        global.parseInt
			global.path                              global.perf_hooks
			global.performance                       global.process
			global.punycode                          global.querystring
			global.queueMicrotask                    global.readline
			global.repl                              global.require
			global.setImmediate                      global.setInterval
			global.setTimeout                        global.stream
			global.string_decoder                    global.structuredClone
			global.sys                               global.timers
			global.tls                               global.trace_events
			global.tty                               global.undefined
			global.unescape                          global.url
			global.util                              global.v8
			global.vm                                global.wasi
			global.worker_threads                    global.zlib
		*/
		expect(typeOf(global)).toBe('object')
	}) // object-like types

	test('anonymous objects', function testTypeOfAnonymous() {
		interface TwoD {
			x: number
			y: number
		}
		interface ThreeD {
			x: number
			y: number
			z: number
		}

		const anon: TwoD = new (function (this: TwoD, x: number, y: number) {
			this.x = x
			this.y = y
		})(1, -1) as TwoD

		const anon2: ThreeD = new (function (
			this: ThreeD,
			x: number,
			y: number,
			z: number,
		) {
			this.x = x
			this.y = y
			this.z = z
		})(1, -1, 0) as ThreeD
		expect(typeOf(anon)).toMatch(/^object:Anon\d+$/)
		expect(typeOf(anon2)).toMatch(/^object:Anon\d+$/)
		expect(typeOf(anon2)).not.toBe(typeOf(anon))
	})
})
