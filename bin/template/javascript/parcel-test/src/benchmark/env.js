// env.js -- subset
// Detecting your environment and getting access to the global object
// http://stackoverflow.com/questions/17575790/environment-detection-node-js-or-browser
// https://developer.mozilla.org/en-US/docs/Web/API/Window/self

const makeGet = function(globalVar) {
	return 'try { __global = __global || ' + globalVar + '} catch (exception) {}'
}

// eslint-disable-next-line no-new-func
export const getGlobal = new Function(
	// prettier-ignore
	'var __global;'
	+ makeGet('window')
	+ makeGet('global')
	+ makeGet('WorkerGlobalScope')
	+ 'return __global;'
)

function _getOutputDiv(document, id) {
	let div
	try {
		div = document.getElementById(id)
		if (!div) {
			const newDiv = document.createElement('div')
			newDiv.id = id
			document.body.insertBefore(newDiv, document.body.firstChild)
			div = document.getElementById(id)
		}
	} finally {
		void 0
	}
	return div
}

function _addElement(document, message) {
	try {
		const newDiv = document.createElement('div'),
			newContent = document.createTextNode(message),
			div = _getOutputDiv(document, 'spray-output-div')

		newDiv.appendChild(newContent)
		div.appendChild(newDiv)
	} finally {
		void 0
	}
}

// Show a message in every possible place.
const spray = function() {
	const which = 'log'
	const ALERT_OK = false

	const global = getGlobal(),
		args = Array.prototype.slice.call(arguments)
	if (global.document && global.document.body) {
		_addElement(global.document, args.join())
	}

	if (global.console && global.console[which]) {
		global.console[which].apply(global.console, args)
	}

	if (ALERT_OK && global.alert) {
		global.alert.apply(global, args)
	}
}

export default spray
