// JSONDate.ts helps to JSON.stringify/parse a Regular Expression object.
export type TimeLocale = Partial<Intl.ResolvedDateTimeFormatOptions>
export type JSONDateish = [
	string,
	string?,
	string?,
	number?,
	string?,
	string?,
	string?,
	TimeLocale?,
]

export const displayName = 'object:JSONDate'

export const DOW = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

/**
 * Convert a Date object to an Array which can be serialised with JSON.stringify.
 * @param date Date to convert to a string named array for serialisation with JSON.stringify.
 * @returns An array whose first element is 'object:JSONDate' to indicate that it is a Date object.  The following elements give the date in other formats and provide locale information to aid in debugging locale specific date problems.
 */
export function JSONDate(date: Date): JSONDateish {
	const dow = date.getDay()
	let locale: TimeLocale
	try {
		const dateFormat = new Intl.DateTimeFormat()
		locale = { ...dateFormat.resolvedOptions() }
	} catch (failure) {
		locale = {}
	}
	return [
		displayName,
		date.toJSON(),
		date.toUTCString(),
		date.valueOf(),
		`${DOW[dow]}[${dow}]`,
		date.toTimeString(),
		date.toLocaleString(),
		locale,
	]
}

/**
 * Convert an array returned from a JSONDate() call back into a Javascript Date object.
 * @param type Element 0 of the supplied JSONDateish should always be 'object:JSONDate'.
 * @param date string in Date.toJSON format for setting the date value.
 * @returns Date constructed from date string.
 * @throws TypeError if type is not object:JSONDate.
 */
export function DateFromJSON([type, date]: JSONDateish): Date {
	if (type !== displayName) {
		throw new TypeError(
			`Cannot construct a Date from non-JSONDateish, first element of array must be '${displayName}'. (Found '${type}')`,
		)
	}
	return new Date(date ?? Date.now())
}
