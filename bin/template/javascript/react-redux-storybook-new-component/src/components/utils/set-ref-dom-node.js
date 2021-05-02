// set-ref-dom-node.js - a helper for setting react refs properly
// https://hackernoon.com/refs-in-react-all-you-need-to-know-fb9c9e2aeb81
import ReactDOM from 'react-dom'

/*
	Usage (see also the test plan)

	import setRefDOMNode from '.../utils/set-ref-dom-node'

	'''

	constructor() {
		this.setRefInputBox = setRefDOMNode('inputBox').bind(this)
	}

	onSomething() {
		this.domNode.inputBox.focus()
	}

	render () {
		<Component
			ref={this.setRefInputBox}
		/>
	}
*/

export default function setRefDOMNode(nameOrIndex) {
	return function saveDOMNode(node) {
		if (!this.domNode) {
			this.domNode = {}
		}
		// eslint-disable-next-line react/no-find-dom-node
		this.domNode[nameOrIndex] = ReactDOM.findDOMNode(node)
	}
}
