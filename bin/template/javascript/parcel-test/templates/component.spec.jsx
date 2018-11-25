// a simple test of a component by comparing an html snapshot
/* eslint-disable prefer-arrow-callback */
import React from 'react'
import { shallow /* , mount */ } from 'enzyme'
/* eslint-disable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import { prettify } from 'specs/test-tools/snapshot'
import mockStyles from 'specs/test-tools/mockStyles'
/* eslint-enable import/no-extraneous-dependencies, import/no-unresolved, import/extensions */
import TEMPLATE from './'

const suite = 'src/TEMPLATE <TEMPLATE> Component'

const useStyle = mockStyles(require('./style'))

/* eslint-disable no-useless-escape */
// You should be able to paste the HTML output shown on the console directly
// and the prettify function will take care of the spacing differences.
const HTML = `

`

const HTML_ALL = `

`
/* eslint-enable no-useless-escape */

describe(suite, function descTEMPLATEComponentSuite() {
	function buildComponent(props = {}) {
		const context = { router: {} }
		const mergedProps = {
			// specify default props needed to suppress prop validation errors
			useStyle,
			...props,
		}
		const wrapped = shallow(<TEMPLATE {...mergedProps} />, { context })

		/*
			TEMPLATE
			Quick reference for getting info about the component for testing
			http://airbnb.io/enzyme/docs/api/shallow.html
			console.error('wrapped.props()', wrapped.props(), wrapped.props('title'));
			console.error('wrapped.state()', wrapped.state(), wrapped.state('farm'));
			console.error('wrapped.context()', wrapped.context(), wrapped.context('router'));
			console.error('wrapped.hasClass()', wrapped.hasClass('theApp'));
			console.error('wrapped.type()', wrapped.type());
			console.error('wrapped.name()', wrapped.name());
			console.error('wrapped html attribs', wrapped.find('div').get(0).attribs);
			console.error('wrapped.debug()', wrapped.debug());
			console.error('wrapped.html()', wrapped.html());
			console.error('wrapped.text()', wrapped.text());
		*/

		return wrapped
	}

	describe('match snapshot HTML', function descTEMPLATESnapshotSuite() {
		it('should match when rendered with minimal props', function testTEMPLATEMinimalRender() {
			const component = buildComponent()
			const html = component.debug()
			const expected = prettify(HTML)
			const actual = prettify(html)
			expect(actual).toBe(expected)
		})

		it('should match when rendered with all props', function testTEMPLATERenderAllProps() {
			const component = buildComponent({
				TODO: 'more props here',
			})
			const html = component.debug()
			const expected = prettify(HTML_ALL)
			const actual = prettify(html)
			expect(actual).toBe(expected)
		})
	}) // match snapshot HTML

	describe('match styles', function descTEMPLATEStylesSuite() {
		function getStyle(component) {
			// eslint-disable-next-line lodash/prefer-lodash-method
			const found = component.find('div.somethingHere').get(0).props.style
			return found
		}

		it('should match styles by default', function testTEMPLATEStyles() {
			const component = buildComponent()
			expect(getStyle(component)).toEqual({ font: '"UPDATE THIS"' })
		})
	}) // match styles

	describe('component behaviour', function descTEMPLATEBehaviourSuite() {
		function getSubState(component) {
			const state = component.state()
			// import assign from 'lodash/assign';
			// const state = assign({}, component.state());
			// delete (state.brandStyles);
			return state
		}

		function userAction(component, value) {
			// eslint-disable-next-line lodash/prefer-lodash-method
			component.find('input#ID').simulate('change', value)
		}

		it('should receive new props', function testTEMPLATEReceiveProps() {
			const component = buildComponent({})
			expect(getSubState(component)).toEqual({
				something: 'BEFORE RECEIVE NEW PROPS',
			})

			component.setProps({ value: 'SOMETHING NEW VALUE' })

			expect(getSubState(component)).toEqual({
				something: 'AFTER RECEIVE NEW PROPS',
			})
		})

		it('should handle user action', function testTEMPLATEUserAction() {
			const spy = jest.fn()
			const component = buildComponent({
				onAction: spy,
			})
			expect(getSubState(component)).toEqual({
				something: 'GOES HERE',
			})

			userAction(component, 'CLICK')

			expect(getSubState(component)).toEqual({
				something: 'CHANGED AFTERWARDS',
			})

			expect(spy).toHaveBeenCalledTimes(1)
			expect(spy).toHaveBeenCalledWith('CLICK')
		})
	}) // component behaviour
})
/* eslint-enable prefer-arrow-callback */
