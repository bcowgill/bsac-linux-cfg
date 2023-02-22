// JSONRegExp.ts helps to JSON.stringify/parse a Regular Expression object.
export type JSONRegExpish = [string, string?, string?]

export const displayName = 'object:JSONRegExp'

/**
 * Convert a RegExp object to an Array which can be serialised with JSON.stringify.
 * @param regex RegExp to convert to a string named array for serialisation with JSON.stringify.
 * @returns An array whose first element is 'object:JSONRegExp' to indicate that it is a RegExp object.  The following elements are the source and flags strings.
 */
export function JSONRegExp(regex: RegExp) {
	return [displayName, regex.source, regex.flags]
}

/**
 * Convert an array returned from a JSONRegExp() call back into a Javascript RegExp object.
 * @param type Element 0 of the supplied JSONRegExpish should always be 'object:JSONRegExp'.
 * @param source string containing the RegExp matching string.
 * @param flags string containing the RegExp flags.
 * @returns RegExp constructed from source and flags values.
 * @throws TypeError if type is not object:JSONRegExp.
 */
export function RegExpFromJSON([
	type,
	source = '',
	flags,
]: JSONRegExpish): RegExp {
	if (type !== displayName) {
		throw new TypeError(
			`Cannot construct a RegExp from non-JSONRegExpish, first element of array must be '${displayName}'. (Found '${type}')`,
		)
	}
	return new RegExp(source, flags)
}
