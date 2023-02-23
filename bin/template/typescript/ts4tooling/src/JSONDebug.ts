// JSONDebug.ts helpers for JSON.stringify/parse to better debug objects
import { JSONFunction, functionish } from './JSONFunction'
import { JSONRegExp } from './JSONRegExp'
import { JSONDate, reJSONDate } from './JSONDate'
import { JSONMap } from './JSONMap'
import { JSONSet } from './JSONSet'
import typeOf from './typeOf'

export interface JSONDebugLimits {
	withFunctions?: boolean
	items: number
	arrayLimit?: number
	setLimit?: number
	mapLimit?: number
	ellipsis?: string
	mapEllipsis?: [string, string]
}

const limits: JSONDebugLimits = {
	items: 0,
	withFunctions: true,
}

// let counter = 20

export function replacerDebug(this: unknown, key: string, value: unknown) {
	const type = typeOf(value)
	// --counter
	// if (counter <= 0) {
	// 	throw new Error('BREAK JSON LOOP')
	// }
	// console.warn(
	// 	`REPLACER key[${key}] type[${type}] this:`,
	// 	this,
	// 	'value: ',
	// 	value,
	// )
	let better: unknown = value
	switch (type) {
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
		case 'string': {
			if (reJSONDate.test(value as string)) {
				better = JSONDate(new Date(value as string))
			}
			break
		}
		// MUSTDO Array, slice it up if too many entries exceeding limits.items...
		default: {
			better = value
		}
	}
	return better
}
