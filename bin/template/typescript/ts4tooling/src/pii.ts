/*
    a module to obscure PII - personally identifiable information: a name, an identification number, location data, an online identifier or to one or more factors specific to the physical, physiological, genetic, mental, economic, cultural or social identity of that natural person.
    https://www.stationx.net/list-of-personally-identifiable-information-pii/
*/

const probability = 0.5
const short = 4
const reChar = /./g
const reNumber = /^[0-9]+$/
const star = '*'
const zero = '0'
const one = '1'

/**
 * Obscure a string containing sensitive personally identifiable information (PII) like a password.
 * @param password sensitive personal information to be fully obscured.
 * @returns a string full of '*' characters up to 4 characters longer than the input string.
 */
export function obscurePassword(password: string): string {
	let obscured = password.replace(reChar, star)
	obscured += Math.random() < probability ? star : ''
	obscured += Math.random() < probability ? star : ''
	obscured += Math.random() < probability ? star : ''
	obscured += Math.random() < probability ? star : ''
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
			obscured = one
			break
		case 2:
			obscured = one + one
			break
		default:
			obscured = obscured.replace(
				/^(.)(.*)(.)$/g,
				function replaceNumber(unused, first, middle, last) {
					return `${first}${middle.replace(reChar, zero)}${last}`
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
			word.length <= short
				? word.replace(reChar, star)
				: word.replace(
						/^(.)(.*)(.)$/g,
						function replaceWord(match, first, middle, last) {
							return `${first}${middle.replace(
								reChar,
								star,
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
