// hoc.js - a utility for making Higher Order Components in React

const REGEX_FUNCTION = /^function\s+(\w+)\s*\(.+/i

export function getFunctionName(Component) {
	const func = Component.toString().split('\n')[0]
	let name = 'Unknown'
	if (REGEX_FUNCTION.test(func)) {
		name = func.replace(REGEX_FUNCTION, '$1')
	}
	return name
}

export default function hocName(displayName, Component) {
	const componentName = Component.displayName || getFunctionName(Component)
	const name = `${displayName}(${componentName})`
	return name
}
