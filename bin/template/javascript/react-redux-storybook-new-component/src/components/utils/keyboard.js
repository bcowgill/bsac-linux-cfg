// for legacy browser support as needed
export default function getKey(event) {
	return event.key
}

// get the cursor position within an input DOM element
export function getCursorPosition(inputElement) {
	const where = {
		start: false,
		middle: true,
		end: false,
	}

	const position =
		inputElement.selectionDirection === 'forward'
			? inputElement.selectionEnd
			: inputElement.selectionStart
	if (position >= inputElement.value.length) {
		where.end = true
		where.middle = false
	}
	if (position <= 0) {
		where.start = true
		where.middle = false
	}
	return where
}
