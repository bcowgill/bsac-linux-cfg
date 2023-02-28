// JSONDebug.ts helpers for JSON.stringify/parse to better debug objects
import { JSONDate, reJSONDate, rePrefixedDate, JSONDateish } from './JSONDate'
import { JSONFunction, functionish } from './JSONFunction'
import { JSONRegExp, JSONRegExpish } from './JSONRegExp'
import { JSONMap } from './JSONMap'
import { JSONSet } from './JSONSet'
import typeOf from './typeOf'

export const NO_ELLIPSIS = [null]

// const DEBUG = true

// A JSON.stringify replacer/reviver callback function
type FnJSONReplacer = (this: object, key: string, value: unknown) => unknown

/**
 * A JSON replacer/reviver function that just returns the value as it is.
 * @param unused The unused key name.
 * @param value The value currently being stringified.
 * @returns the value being stringified just as it is.
 */
export const identityReplacer: FnJSONReplacer = function (unused, value) {
	return value
}

export interface JSONDebugLimits {
	withFunctions?: boolean
	items?: number
	arrayLimit?: number
	setLimit?: number
	mapLimit?: number
	stringLimit?: number
	ellipsis?: string
	mapEllipsis?: [string, string] | null
}

export interface JSONReplacerRevivers {
	preReplacer?: FnJSONReplacer
	postReplacer?: FnJSONReplacer
	preReviver?: FnJSONReplacer
	postReviver?: FnJSONReplacer
}

export const NOLIMITS: JSONDebugLimits = {
	items: 0, // no limits on items at all,
	withFunctions: true,
}

// JSON.stringify/parser replacer/reviver callback functions in one object.
interface JSONStreamer {
	replacer: FnJSONReplacer
	reviver: FnJSONReplacer
}

/**
 * Get JSON.stringify/parser replacer/reviver functions which limit the number of elements output from collections and can call through to a subsequent replacer/reviver for additonal post-processing.
 * @param limits specifies the limits of items to show for arrays, sets, etc and what to use as ellipsis characters for collections that are too long.
 * @param replacers specifies additional JSON.stringify type replacer/reviver functions to apply to the JSON object values before and after the limits have been applied.
 * @returns an object containing a replacer and reviver function to use with JSON/JSON5.stringify/parse functions.
 */
export function getJSONDebugger(
	limits: JSONDebugLimits,
	replacers: JSONReplacerRevivers = {},
): JSONStreamer {
	// let counter = 20

	const preReplacer = replacers.preReplacer ?? identityReplacer
	const postReplacer = replacers.postReplacer ?? identityReplacer
	const preReviver = replacers.preReviver ?? identityReplacer
	const postReviver = replacers.postReviver ?? identityReplacer

	const json = {
		/**
		 * A function that alters the behavior of the JSON stringification process.
		 * @param this the object which the key/value parameters came from.
		 * @param key being currently stringified from the object held in 'this'. Will be an empty string to indicate the top level object being stringified.
		 * @param value being currently stringified from the object held in 'this'. For example a Date object will already be a string here.
		 * @returns the value to use for key in 'this' object.  Unlike JSON.stringify, we support Set and Map data by converting to arrays of type JSONSetish, JSONMapish. We also convert any Dates to an array of type JSONDateish with additional locale debugging in the last element.  We also support RegExp by converting to an array of JSONRegExpish.
		 */
		replacer: function (this: object, key: string, valueIn: unknown) {
			const value = (
				preReplacer.bind(this, key, valueIn) as () => unknown
			)()
			const type = typeOf(value)
			// --counter
			// if (counter <= 0) {
			// 	throw new Error('BREAK JSON LOOP')
			// }
			// if (DEBUG /*|| key === 'list'*/) {
			// 	// DEBUG = true
			// 	const typeSource = typeOf(this[key])

			// 	console.warn(
			// 		`getJSONDebugger.replacer key[${key}] ${typeSource}->${type}\nvalue<`,
			// 		value,
			// 		'>\nthis:',
			// 		this,
			// 	)
			// }

			let better: unknown = value
			switch (type) {
				case 'string': {
					const limit = limits.stringLimit ?? 0
					if (reJSONDate.test(value as string)) {
						better = JSONDate(new Date(value as string))
					} else if (limit > 0 && (value as string).length > limit) {
						better =
							(value as string).substring(0, limit) +
							(limits.ellipsis ?? '')
					}
					break
				}
				case 'object:RegExp': {
					better = JSONRegExp(value as RegExp)
					break
				}
				case 'function': {
					better = limits.withFunctions
						? JSONFunction(value as functionish)
						: void 0
					break
				}
				case 'object:Array': {
					const limit = limits.arrayLimit ?? limits.items ?? 0
					if (limit > 0 && (value as []).length > limit) {
						const ellipsis = limits.ellipsis ?? void 0
						better = (value as []).slice(0, limit) as unknown[]
						if (ellipsis) {
							;(better as unknown[])[limit] = ellipsis
						}
					}
					break
				}
				case 'object:Set': {
					better = JSONSet(
						value as Set<unknown>,
						limits.setLimit ?? limits.items,
						limits.ellipsis,
					)
					break
				}
				case 'object:Map': {
					better = JSONMap(
						value as Map<unknown, unknown>,
						limits.mapLimit ?? limits.items,
						limits.mapEllipsis,
					)
					break
				}
				default: {
					if (type.startsWith('object')) {
						const limit = limits.items ?? 0
						const keys = Object.keys(value as object)
						if (limit > 0 && keys.length > limit) {
							better = {}
							const ellipsis = limits.ellipsis ?? void 0
							for (let idx = 0; idx < limit; ++idx) {
								const key = keys[idx]
								;(better as object)[key] = (value as object)[
									key
								] as unknown
							}
							if (ellipsis) {
								;(better as object)[ellipsis] = ellipsis
							}
						}
					}
				}
			}
			return (postReplacer.bind(this, key, better) as () => unknown)()
		}, // replacer
		reviver: function (this: object, key: string, valueIn: unknown) {
			const value = (
				preReviver.bind(this, key, valueIn) as () => unknown
			)()
			// if (DEBUG /*|| key === 'list'*/) {
			// 	// DEBUG = true
			// 	const type = typeOf(value)
			// 	const typeSource = typeOf(this[key])

			// 	console.warn(
			// 		`getJSONDebugger.reviver key[${key}] ${typeSource}->${type}\nvalue<`,
			// 		value,
			// 		'>\nthis:',
			// 		this,
			// 	)
			// }

			let better: unknown = value
			if (typeOf(value) === 'object:Array') {
				const first = (value as unknown[])[0]
				if (typeof first === 'string' && first.startsWith('object:')) {
					switch (first) {
						case 'object:JSONDate': {
							const date = (value as JSONDateish)[1]
							better = new Date(
								date
									? date.replace(rePrefixedDate, '$2')
									: Date.now(),
							)
							break
						}
						case 'object:JSONRegExp': {
							better = new RegExp(
								(value as JSONRegExpish)[1] ?? '',
								(value as JSONRegExpish)[2] ?? '',
							)
							break
						}
						case 'object:JSONFunction': {
							better = void 0
							break
						}
						case 'object:JSONSet': {
							const iterator = (value as []).values()
							iterator.next()
							better = new Set(iterator)
							break
						}
						case 'object:JSONMap': {
							const iterator = (value as []).values()
							iterator.next()
							better = new Map(iterator)
							break
						}
						default:
							better = value
					}
				}
			}
			return (postReviver.bind(this, key, better) as () => unknown)()
		},
	}
	return json
} // getJSONDebugger()

const JSONDebug = getJSONDebugger(NOLIMITS)

export const replacerDebug = JSONDebug.replacer
export const reviverDebug = JSONDebug.reviver
