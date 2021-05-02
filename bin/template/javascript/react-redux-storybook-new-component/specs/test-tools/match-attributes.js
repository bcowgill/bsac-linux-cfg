// match-attributes.js
// A helper for using jest-dom to validate if a DOM element has some attributes.

// Check if a DOM element has the specified attributes
// or does not have specified attributes.
// { name: 'tom', '!checked': null } => must have name = tom and no checked attribute
export default function matchAttributes(element, expected = {}) {
	Object.keys(expected).forEach((key) => {
		const parts = key.split('!')
		if (parts.length === 1) {
			expect(element).toHaveAttribute(key, expected[key])
		} else {
			const keyNot = parts[1]
			expect(element).not.toHaveAttribute(keyNot)
		}
	})
}
