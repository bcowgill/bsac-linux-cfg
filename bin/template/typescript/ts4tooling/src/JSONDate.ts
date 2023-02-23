// JSONDate.ts helps to JSON.stringify/parse a Regular Expression object.
export type TimeLocale = Partial<Intl.ResolvedDateTimeFormatOptions>
export interface TimeDebug extends TimeLocale {
	utc?: string
	epoch?: number
	timeFormatted?: string
	localeFormatted?: string
}
export type JSONDateish = [
	string, // object:JSONDate
	string?, // toJSON time
	TimeDebug?,
]

export const displayName = 'object:JSONDate'

/**
 * Convert a Date object to an Array which can be serialised with JSON.stringify.
 * @param date Date to convert to a string named array for serialisation with JSON.stringify.
 * @returns An array whose first element is 'object:JSONDate' to indicate that it is a Date object.  The next element is the JSON formatted date string and finally an object containing the Intl.ResolvedDateTimeFormatOptions for the browser/node as well as other Date object properties to aid in debugging locale specific date problems.
 */
export function JSONDate(date: Date): JSONDateish {
	let locale: TimeDebug = {}
	try {
		const dateFormat = new Intl.DateTimeFormat()
		locale = { ...dateFormat.resolvedOptions() }
	} catch (failure) {
		locale = {}
	} finally {
		locale.utc = date.toUTCString()
		locale.epoch = date.getTime()
		locale.timeFormatted = date.toTimeString()
		locale.localeFormatted = date.toLocaleString()
	}
	return [displayName, date.toJSON(), locale]
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
