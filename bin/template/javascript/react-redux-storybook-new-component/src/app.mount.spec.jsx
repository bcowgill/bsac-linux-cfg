/* eslint-disable prefer-arrow-callback */
import ReactDOM from 'react-dom'
import { render, waitForElement } from 'react-testing-library'
import appDiv from './journeys/cwa-app/id'
import * as AppMount from './app.mount'

const renderApp = AppMount.default

const suite = 'src/ AppMount app renderer'

describe(suite, function descAppMountComponentSuite() {
	describe('exported the right stuff', function descAppMountExportedSuite() {
		it('should export the render function', function testAppMountRender() {
			expect(typeof AppMount.default).toBe('function')
		})
	})

	// MUSTDO restore this suite after constellaion fully implemented
	describe.skip('rendering the right stuff', function descAppMountRenderSuite() {
		let getElementSpy
		let renderSpy

		beforeEach(function setupTests() {
			getElementSpy = jest
				.spyOn(document, 'getElementById')
				.mockReturnValue(`<div id="${appDiv}"> THE APP GOES HERE </div>`)
			renderSpy = jest
				.spyOn(ReactDOM, 'render')
				.mockReturnValue('The Rendered App')
		})

		afterEach(function tearDownTests() {
			if (getElementSpy) {
				getElementSpy.mockReset()
				getElementSpy.mockRestore()
			}
			if (renderSpy) {
				renderSpy.mockReset()
				renderSpy.mockRestore()
			}
		})

		it('should get the right div from the document', function testAppMountRenderDiv() {
			renderApp()
			expect(getElementSpy).toHaveBeenCalledTimes(1)
			expect(getElementSpy).toHaveBeenCalledWith(appDiv)
		})

		function getRenderedApp() {
			renderApp()
			expect(renderSpy).toHaveBeenCalledTimes(1)
			const root = renderSpy.mock.calls[0][0]
			const div = renderSpy.mock.calls[0][1]

			// Resstore ReactDOM.render function so we can test render the component
			renderSpy.mockReset()
			renderSpy.mockRestore()
			renderSpy = null

			const component = render(root)
			if (process.env.TEST_DEBUG) {
				// eslint-disable-next-line no-console
				console.log(`debug: ${suite}`)
				component.debug()
			}
			return {
				root,
				div,
				component,
			}
		}

		it('should pass the right div into ReactDOM.render', function testAppMountRenderDOM() {
			const { div } = getRenderedApp()
			expect(div).toMatch('THE APP GOES HERE')
		})

		it('should render the right component into the HTML', async function testAppMountRenderComponent() {
			const { component } = getRenderedApp()

			// check for header, middle, footer such as they are.
			await waitForElement(() => {
				// eslint-disable-next-line prefer-destructuring
				const children = component.container.firstChild.children
				expect(children).toHaveLength(3)

				expect(children[0].tagName).toMatch(/^HEADER$/i)
				expect(children[0]).toHaveAttribute('id', 'cwa-bank-header')
				expect(children[0]).toHaveClass('id-cwa-bank-header')

				expect(children[1].tagName).toMatch(/^DIV$/i)
				expect(children[1]).toHaveClass('inner')

				expect(children[2].tagName).toMatch(/^DIV$/i)
				expect(children[2]).toHaveClass('footer-wrapper')
				return children
			})
		})
	}) // rendering the right stuff
})
/* eslint-enable prefer-arrow-callback */
