// errors.ts convert catch(exception: unknown) to Error or String type safely as needed
import typeOf from './typeOf'

const ELLIPSIS = '…'

const elementProps = [
	'tagName',
	'localName',
	'id',
	'name',
	'type',
	'tabIndex',
	'className',
	'title',
	'alt',
	'src',
	'href',
	'ariaLabel',
	'ariaDescription',
	'ariaRoleDescription',
	'placeholder',
	'ariaPlaceholder',
	'value',
	'defaultValue',
	'checked',
	'ariaChecked',
	'indeterminate',
	'defaultChecked',
	'ariaPressed',
	'ariaSelected',
	'ariaValueNow',
	'ariaValueText',
	'ariaValueMin',
	'ariaValueMax',
	'required',
	'ariaRequired',
	'hidden',
	'ariaHidden',
	'ariaOrientation',
	'ariaBusy',
	'disabled',
	'ariaDisabled',
	'readOnly',
	'ariaReadOnly',
	'validity',
	'autofocus',
	'autocomplete',
	'pattern',
	'size',
	'min',
	'max',
	'minLength',
	'maxLength',
	'ariaExpanded',
	'ariaHasPopup',
	'ariaModal',
	'ariaSort',
	'ariaPosInSet',
	'ariaSetSize',
] // elementProps

/**
 * Limit the length of information shown with an ellipsis added to indicate something is missing.
 * @param info Some long string to limit the display of characters from.
 * @param limit An optional upper limit (at least 2) of characters to show from the info string.  An ellipsis will be inserted before the last character of the string when it is shortened.
 * @param ellipsis value to use when characters are elided from the output. defaults to '…'.
 * @returns The info string as is or with an ellipsis if it is too long.  Total length will be the limit value plus the length of the ellipsis.
 */
export function limitLength(info: string, limitIn = 0, ellipsis = ELLIPSIS) {
	let short = info
	const limit = limitIn > 0 ? Math.max(2, limitIn) : 0
	if (limit && short.length >= limit + 1) {
		short =
			short.substring(0, limit - 1) +
			ellipsis +
			short.substring(info.length - 1)
	}
	return short
} // limitLength()

/**
 * Will convert an object to a string better than just [object Object] if possible.  This is suitable for debugging, testing and logging, not for showing to a user.
 * @param error An object to stringify better than [object Object].
 * @param limit An optional upper limit (at least 2) of characters to show from the object.  An ellipsis will be inserted before the last character when it is shortened.
 * @param ellipsis value to use when characters are elided from the output. defaults to '…'.
 * @returns JSON stringified version of the object limited by the length, if possible.
 */
// MUSTDO add replacer function, handle BigInt values...
export function objectToString(
	error: object | null,
	limit?: number,
	ellipsis?: string,
): string {
	// This lint warning is what we are solving with this function...
	/* eslint-disable @typescript-eslint/restrict-template-expressions */
	let asString = Array.isArray(error)
		? limitLength(`[${error as unknown[]}]`, limit, ellipsis)
		: `${error}`

	try {
		if (error !== null && /^\[object .+\]/.test(asString)) {
			const exception = {}
			const keys =
				error instanceof Element
					? [...elementProps, ...Object.keys(error)]
					: Object.keys(error)
			keys.forEach((key) => {
				type SimpleValue = boolean | number | bigint | string
				const result = !(
					key.startsWith('_') ||
					/^(function|object|undefined|null)/.test(typeOf(error[key]))
				)
				// if (!result)
				// 	console.warn(`objectToString() KEY[${key}] T:${typeOf(error[key])}`)
				const value = error[key] as SimpleValue
				if (result && value !== '') {
					;(exception as object)[key] = value
				}
			})
			asString = limitLength(JSON.stringify(exception), limit, ellipsis)
		}
	} catch (exception) {
		asString += ` error with stringify! ${exception}`
	}
	/* eslint-enable @typescript-eslint/restrict-template-expressions */
	return asString
} // objectToString()

/**
 * Given an unknown object from a catch(exception) convert it to a string type safely..  This is suitable for debugging, testing and logging, not for showing to a user.
 * @param context A short message to identify location of error. i.e. 'fooFunction() Caught: '
 * @param error Something caught by a try/catch block to convert to a string.
 * @param limit An optional upper limit (at least 2) of characters to show from the object.  An ellipsis will be inserted before the last character when it is shortened.
 * @param ellipsis value to use when characters are elided from the output. defaults to '…'.
 * @returns A string version of whatever was caught with the context message.  If error has excessive spacing it will be surrounded by <> characters to show that.
 */
export function toErrorString(
	context: string,
	error?: unknown,
	limit?: number,
	ellipsis?: string,
): string {
	let exception = error
	let type = typeOf(error)
	type = /^(undefined|null)$/.test(type) ? '' : `(${type})`
	// console.warn('toErrorString() TYPE', type)
	if (type === '(string)') {
		let value = (exception as string).valueOf()
		const trimmed = value.trim()
		if (value === '') {
			value = '<empty string>'
		} else if (value !== trimmed) {
			value = `<${value}>`
		}
		exception = limitLength(value, limit, ellipsis)
	}

	if (typeof error === 'object' && error !== null) {
		if (type.startsWith('(object')) {
			exception = objectToString(error, limit, ellipsis)
		} else {
			type = `(object:${error.constructor.name})`
		}
	}
	// This function solves this eslint issue for unknown errors
	// eslint-disable-next-line @typescript-eslint/restrict-template-expressions
	return `${context}${type}${exception}`
} // toErrorString()

/**
 * Returns Error objects as is, or wraps non-Error's in an Error so you can throw it.
 * @param error If a non-Error object is passed it will be turned into an Error for throwing.
 * @param context optional prefix string for when error is not already an Error object.
 * @param limit An optional upper limit (at least 2) of characters to show from the object.  An ellipsis will be inserted before the last character when it is shortened.
 * @param ellipsis value to use when characters are elided from the output. defaults to '…'.
 * @returns an Error which you can throw right away.
 */
export function throwAsError(
	error?: unknown,
	context = '',
	limit?: number,
	ellipsis?: string,
): Error {
	const exception =
		error instanceof Error
			? error
			: new Error(toErrorString(context, error, limit, ellipsis))
	return exception
} // throwAsError()
