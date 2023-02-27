// JSONMap.ts helps to JSON.stringify/parse a Javascript Map object.

type ellipsis = ['…', '…']
type kvStringified<K, V> = [K, V] | ellipsis
export type JSONMapish<K, V> = [string, ...kvStringified<K, V>[]]

export const displayName = 'object:JSONMap'

export const ELLIPSIS: ellipsis = ['…', '…']

/**
 * Convert a Map object to an Array which can be serialised with JSON.stringify.
 * @param map Map to convert to a string named array for serialisation with JSON.stringify.
 * @param limit number if positive will limit the number of keys from the Map to export.  If the limit is reached, an ellipsis tuple will be shown as the last item in the map.
 * @param ellipsis key, value tuple to use when limit is positive and entries are elided from the output. defaults to ['…', '…']. If null, defaults to showing nothing.
 * @returns An array whose first element is 'object:JSONMap' to indicate that it is a JSON serialisable array.  The following elements are the key, value tuples of the map.
 */
export function JSONMap<K, V>(
	map: Map<K, V>,
	limit = 0,
	ellipsis: kvStringified<K, V> | null = ELLIPSIS,
): JSONMapish<K, V> {
	const jsonMap: JSONMapish<K, V> = [displayName]
	for (const item of map.entries()) {
		if (limit > 0 && jsonMap.length > limit) {
			if (ellipsis !== null) {
				jsonMap.push(ellipsis)
			}
			break
		} else {
			jsonMap.push(item)
		}
	}
	return jsonMap
}

/**
 * Convert an array returned from a JSONMap() call back into a Javascript Map object.
 * @param type Element 0 of the supplied JSONMapish should always be 'object:JSONMap'.
 * @param jsonMap Elements 1..N-1 of the supplied JSONMapish object are key, value tuples to be added to the returned Map.
 * @param ellipsis key, value tuple which was used in JSONMap() call. If present in jsonMap it will be removed as it indicates there were more entries in the map originally.
 * @returns Map constructed from elements 1..N-1 of the supplied JSONMapish object.
 * @throws TypeError if type is not object:JSONMap.
 */
export function MapFromJSON<K, V>(
	[type, ...jsonMap]: JSONMapish<K, V>,
	ellipsis: kvStringified<K, V> = ELLIPSIS,
): Map<K, V> {
	if (type !== displayName) {
		throw new TypeError(
			`Cannot construct a Map from non-JSONMapish, first element of array must be '${displayName}'. (Found '${type}')`,
		)
	}
	const map = new Map<K, V>()
	jsonMap.forEach(([key, value]) => {
		if (key !== ellipsis[0] && value != ellipsis[1]) {
			map.set(key as K, value as V)
		}
	})
	return map
}
