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

// Once time converted to JSON we prepend with a symbol so it no longer
// matches the date regex so that JSON.stringify does not loop infinitely.
export const PREFIX = '⏰'
export const ALL_CLOCKS = `${PREFIX}🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚🕛🕜🕝🕞🕟🕠🕡🕢🕣🕤🕥🕦🕧`
const TWELVE = '🕛'
// eslint-disable-next-line @typescript-eslint/non-nullable-type-assertion-style
const CODE_12 = TWELVE.codePointAt(0) as number
// const ONE = '🕐' // U+1F550
// const ONE_THIRTY = '🕜' // U+1F55C
// const TWELVE_THIRTY = '🕧' // U+1F567
export const rePrefix = new RegExp(`^[${ALL_CLOCKS}]`, 'u')
// toJSON gives 2023-02-23T17:37:38.975Z
export const reJSONDate = /^([-0-9]+)T([.:0-9]+)Z$/
export const rePrefixedDate = new RegExp(
	`^([${ALL_CLOCKS}])([-0-9]+T[.:0-9]+Z)$`,
	'u',
)

/**
 * Get a unicode clock character representing the given time in hours and minutes.
 * @param hour number from a date object.
 * @param minute number from a date object.
 * @returns a unicode clock character that is close to the time given.
 */
export function getClock(hour = 0, minute = 0) {
	const H = (hour + (minute >= 45 ? 1 : 0)) % 12 || 12
	const offset = 12 - H
	const code = CODE_12 - offset + (minute >= 15 && minute < 45 ? 12 : 0)
	return String.fromCodePoint(code)
}

/**
 * Convert a Date object to an Array which can be serialised with JSON.stringify.
 * @param date Date to convert to a string named array for serialisation with JSON.stringify.
 * @returns An array whose first element is 'object:JSONDate' to indicate that it is a Date object.  The next element is the JSON formatted date string and finally an object containing the Intl.ResolvedDateTimeFormatOptions for the browser/node as well as other Date object properties to aid in debugging locale specific date problems.
 */
export function JSONDate(date: Date): JSONDateish {
	let options: TimeDebug = {}
	const locale: TimeDebug = {
		utc: date.toUTCString(),
		epoch: date.getTime(),
		timeFormatted: date.toTimeString(),
		localeFormatted: date.toLocaleString(),
	}
	try {
		const dateFormat = new Intl.DateTimeFormat()
		options = dateFormat.resolvedOptions()
		// eslint-disable-next-line no-empty
	} catch (failure) {}
	return [
		displayName,
		getClock(date.getHours(), date.getMinutes()) + date.toJSON(),
		{ ...locale, ...options },
	]
}

/**
 * Convert an array returned from a JSONDate() call back into a Javascript Date object.
 * @param type Element 0 of the supplied JSONDateish should always be 'object:JSONDate'.
 * @param date string in Date.toJSON format for setting the date value.
 * @returns Date constructed from date string.
 * @throws TypeError if type is not object:JSONDate.
 */
export function DateFromJSON([type, dateIn]: JSONDateish): Date {
	let date = dateIn
	if (type !== displayName) {
		throw new TypeError(
			`Cannot construct a Date from non-JSONDateish, first element of array must be '${displayName}'. (Found '${type}')`,
		)
	}
	if (typeof date === 'string') {
		date = date.replace(rePrefix, '')
	}
	return new Date(date ?? Date.now())
}
