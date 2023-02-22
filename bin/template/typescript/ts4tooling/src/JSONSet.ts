// JSONSet.ts helps to JSON.stringify/parse a Javascript Set object.
export type JSONArrayish<T> = [string, ...T[]]

export const displayName = 'object:JSONSet'

export const ELLIPSIS = '…'

/**
 * Convert a Set object to an Array which can be serialised with JSON.stringify.
 * @param set Set to convert to a string named array for serialisation with JSON.stringify.
 * @param limit number if positive will limit the number of keys from the Set to export.  If the limit is reached, an ellipsis will be shown as the last item in the set.
 * @returns An array whose first element is 'object:JSONSet' to indicate that it is a JSON serialisable array.  The following elements are the keys of the set.
 */
export function JSONSet<T>(set: Set<T>, limit = 0): JSONArrayish<T> {
	const jsonSet: JSONArrayish<T> = [displayName]
	for (const item of set.keys()) {
		if (limit > 0 && jsonSet.length > limit) {
			jsonSet.push(ELLIPSIS)
			break
		} else {
			jsonSet.push(item)
		}
	}
	return jsonSet
}

/**
 * Convert an array returned from a JSONSet() call back into a Javascript Set object.
 * @param type Element 0 of the supplied JSONArrayish should always be 'object:JSONSet'.
 * @param jsonSet Elements 1..N-1 of the supplied JSONArrayish object to be added to the returned Set.
 * @returns Set constructed from elements 1..N-1 of the supplied JSONArrayish object.
 * @throws TypeError if type is not object:JSONSet.
 */
export function SetFromJSON<T>([type, ...jsonSet]: JSONArrayish<T>): Set<T> {
	if (type !== displayName) {
		throw new TypeError(
			`Cannot construct a Set from non-JSONArrayish, first element of array must be '${displayName}'. (Found '${type}')`,
		)
	}
	return new Set(jsonSet)
}
