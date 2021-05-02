// a simple test of a component by user expectations
/* eslint-disable prefer-arrow-callback */
import React from 'react'
import { render, waitForElement, fireEvent } from 'react-testing-library'
import TEMPLATEOBJNAME from './'

const suite = 'src/components/TEMPLATEPATH <TEMPLATEOBJNAME> Component'

describe(suite, function descTEMPLATETESTNAMEComponentSuite() {
	function buildComponent(props = {}) {
		const mergedProps = {
			// specify default props needed to suppress prop validation errors
			...props,
		}
		const wrapped = render(<TEMPLATEOBJNAME {...mergedProps} />)

		if (process.env.TEST_DEBUG) {
			// eslint-disable-next-line no-console
			console.log(`debug: ${suite}`)
			wrapped.debug()
		}

		/*
      TEMPLATE
      Quick reference for getting info about the component for testing
      https://www.npmjs.com/package/react-testing-library#render
      https://testing-library.com/docs/api-queries
      console.error('wrapped methods', wrapped);
    */

		return wrapped
	}

	describe('user should see', function descTEMPLATETESTNAMEVisibleSuite() {
		it('should match when rendered with minimal props', async function testTEMPLATETESTNAMEMinimalRender() {
			const component = buildComponent()

			await waitForElement(() =>
				component.getByText(/^TODO SOMETHING THE USER SHOULD SEE$/)
			)
		})

		it('should match when rendered with all props', async function testTEMPLATETESTNAMERenderAllProps() {
			const component = buildComponent({
				TODO: 'more props here',
			})

			// Shows simple test for something the user can see or by test id
			await waitForElement(() =>
				// component.getByTestId(TEMPLATEOBJNAME.displayName)
				component.getByText(/^TODO SOMETHING THE USER SHOULD SEE$/)
			)

			// Shows how to check the top level element of the component
			await waitForElement(() => {
				const found = component.container.firstChild
				expect(found).toHaveClass('section-panel')
				return found
			})

			// Shows how to locate by data-testid and check text / attrs
			await waitForElement(() => {
				const found = component.getByTestId('value-for-attrib:data-testid')
				// console.error('FOUND', found.innerHTML)
				expect(found.tagName).toMatch(/^H2$/i)
				expect(found).toHaveClass('CLASSNAME')
				expect(found).toHaveTextContent(/^TODO can check text by testid/)

				expect(found).toHaveAttribute('width', '32')

				// to regex match an attribute
				expect(found).toHaveAttribute('src')
				expect(found.getAttribute('src')).toMatch(/^data:image\/png/)

				return found
			})

			// Shows how you can find items and verify order / content of each
			await waitForElement(() => {
				const found = component.getAllByText(/^ITEM/)
				expect(found).toHaveLength(2)
				expect(found[0]).toHaveTextContent(/^TODO first item/)
				expect(found[0]).toHaveTextContent(/^TODO second item/)
				return found
			})
		})
	}) // user should see

	describe('component behaviour', function descTEMPLATETESTNAMEBehaviourSuite() {
		function userClick(component) {
			fireEvent.click(component.getByText(/^TITLE$/))
		}
		function userAction(component, value) {
			fireEvent.change(component.getByText(/^TITLE$/), value)
		}

		it('should handle user action', async function testTEMPLATETESTNAMEUserAction() {
			const spy = jest.fn()
			const component = buildComponent({
				onAction: spy,
			})

			userClick(component)
			userAction(component, 'CHANGE')

			// check for changes to component
			await waitForElement(() => {
				const found = component.getByText(/^TODO CHANGED BY USER$/)
				expect(found).toHaveFocus()
				expect(spy).toHaveBeenCalledTimes(1)
				expect(spy).toHaveBeenCalledWith('CLICK')
				return found
			})
		})
	}) // component behaviour
})
/* eslint-enable prefer-arrow-callback */
