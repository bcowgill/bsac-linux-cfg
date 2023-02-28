/*
    a module to obscure PII - personally identifiable information: a name, an identification number, location data, an online identifier or to one or more factors specific to the physical, physiological, genetic, mental, economic, cultural or social identity of that natural person.
    https://www.stationx.net/list-of-personally-identifiable-information-pii/
*/

const PROBABILITY = 0.5
const SHORT = 4
const STAR = '*'
const ZERO = '0'
const ONE = '1'
const reChar = /./g
const reNumber = /^[0-9]+$/

/**
 * Obscure a string containing sensitive personally identifiable information (PII) like a password.
 * @param password sensitive personal information to be fully obscured.
 * @returns a string full of '*' characters up to 4 characters longer than the input string.
 */
export function obscurePassword(password: string): string {
	let obscured = password.replace(reChar, STAR)
	obscured += Math.random() < PROBABILITY ? STAR : ''
	obscured += Math.random() < PROBABILITY ? STAR : ''
	obscured += Math.random() < PROBABILITY ? STAR : ''
	obscured += Math.random() < PROBABILITY ? STAR : ''
	return obscured
}

/**
 * Obscure a single number of non-sensitive personally identifiable information (PII).
 * @param value non-sensitive numerical personal information to be partly obscured.
 * @returns a string containing obscured number changing to 0's and 1's where needed.
 */
export function obscureNumber(value: number | string): string {
	let obscured = value.toString()
	switch (obscured.length) {
		case 1:
			obscured = ONE
			break
		case 2:
			obscured = ONE + ONE
			break
		default:
			obscured = obscured.replace(
				/^(.)(.*)(.)$/g,
				function replaceNumber(
					unused: never,
					first: string,
					middle: string,
					last: string,
				): string {
					return `${first}${middle.replace(reChar, ZERO)}${last}`
				},
			)
	}
	return obscured
}

/**
 * Obscure a string containing a single word of non-sensitive personally identifiable information (PII).
 * @param word non-sensitive personal information to be partly obscured.
 * @returns a string containing '*' characters inside of word leaving first and last characters intact.  Very short words are fully obscured.  Numbers are obscured with 0 and 1's
 */
export function obscureWord(word: string): string {
	let obscured = word
	if (reNumber.test(obscured)) {
		obscured = obscureNumber(word)
	} else {
		obscured =
			word.length <= SHORT
				? word.replace(reChar, STAR)
				: word.replace(
						/^(.)(.*)(.)$/g,
						function replaceWord(
							match: never,
							first: string,
							middle: string,
							last: string,
						) {
							return `${first}${middle.replace(
								reChar,
								STAR,
							)}${last}`
						},
				  )
	}
	return obscured
}

/**
 * Obscure a string containing non-sensitive personally identifiable information (PII).
 * @param info non-sensitive personal information to be partly obscured.
 * @returns a string containing '*' characters inside of words leaving first and last characters intact.
 */
export function obscureInfo(info: string): string {
	const obscured = info.replace(/\w+/g, obscureWord)
	return obscured
}
