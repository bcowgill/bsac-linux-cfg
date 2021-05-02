/* eslint-disable prefer-arrow-callback */
import ReactDOM from 'react-dom'
import setRefDOMNode from './set-ref-dom-node'

const suite = 'src/components/utils setRefDOMNode'

describe(suite, function descSetRefDomNodeSuite() {
	let domSpy
	beforeEach(function setupTest() {
		domSpy = jest
			.spyOn(ReactDOM, 'findDOMNode')
			.mockReturnValue('this is the DOM node')
	})
	afterEach(function tearDownTest() {
		if (domSpy) {
			domSpy.mockReset()
			domSpy.mockRestore()
			domSpy = null
		}
	})

	it('should store the DOM node in the object', function testSetRefDomNode() {
		function Make() {
			// like constructor() in a react component
			this.setRef = setRefDOMNode('hello').bind(this)
		}

		const expected = { hello: 'this is the DOM node' }
		const actual = new Make()

		// called from within sub components ref={this.setRef}
		actual.setRef('some node')

		expect(actual.setRef).toBeInstanceOf(Function)
		expect(actual.domNode).toEqual(expected)
		expect(domSpy).toHaveBeenCalledTimes(1)
		expect(domSpy).toHaveBeenCalledWith('some node')
	})

	it('should store the DOM node in an array too', function testSetRefDomNodeArray() {
		function Make() {
			// like constructor() in a react component
			this.domNode = []
			this.setRef = [setRefDOMNode(0).bind(this), setRefDOMNode(1).bind(this)]
		}

		const expected = ['this is the DOM node', 'this is the DOM node']
		const actual = new Make()

		// called from within sub components ref={this.setRef[0]}
		actual.setRef[0]('some node')
		actual.setRef[1]('some other node')

		expect(actual.setRef).toBeInstanceOf(Array)
		expect(actual.domNode).toEqual(expected)
		expect(domSpy).toHaveBeenCalledTimes(2)
		expect(domSpy).toHaveBeenCalledWith('some node')
		expect(domSpy).toHaveBeenCalledWith('some other node')
	})
})
