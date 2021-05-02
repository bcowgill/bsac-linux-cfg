// a simple test of a component by user expectations
/* eslint-disable prefer-arrow-callback */
import { render, waitForElement } from 'react-testing-library'
import * as TestFactory from './app-title.factory'

const suite = 'src/components/module <AppTitle> Component'

describe(suite, function descAppTitleComponentSuite() {
	function buildComponent(props = {}) {
		const wrapped = render(TestFactory.buildComponent(props))

		if (process.env.TEST_DEBUG) {
			// eslint-disable-next-line no-console
			console.log(`debug: ${suite}`)
			wrapped.debug()
		}

		return wrapped
	}

	function getByDocumentTitle(expected) {
		return () => {
			const found = document.getElementsByTagName('title')
			// console.error('FOUND', found.length, found[0].innerHTML)
			expect(found[0].innerHTML).toMatch(expected)
			return found
		}
	}

	describe('user should see', function descAppTitleVisibleSuite() {
		beforeEach(function setupTest() {
			buildComponent('XXXX BLAT THE TITLE XXXX')
		})

		it('should match when rendered with minimal props', async function testAppTitleMinimalRender() {
			buildComponent()

			await waitForElement(getByDocumentTitle(/^:APP TITLE:$/))
		})

		it('should match when rendered error state and minimal props', async function testAppTitleMinimalRenderError() {
			buildComponent(TestFactory.makeMinimalProps(undefined, true))

			await waitForElement(getByDocumentTitle(/^Error: :APP TITLE:$/))
		})

		it('should match when rendered with all props', async function testAppTitleRenderAllProps() {
			buildComponent(TestFactory.makeFullProps('FULL PROPS'))

			await waitForElement(getByDocumentTitle(/^FULL PROPS \| DEFAULT TITLE$/))
		})

		it('should match when rendered with all props - no title', async function testAppTitleRenderAllPropsNoTitle() {
			buildComponent(TestFactory.makeFullProps())

			await waitForElement(getByDocumentTitle(/^DEFAULT TITLE$/))
		})

		it('should match when rendered error state with all props - no title', async function testAppTitleRenderAllPropsErrorNoTitle() {
			buildComponent(TestFactory.makeFullProps(undefined, true))

			await waitForElement(
				getByDocumentTitle(/^Error: DEFAULT TITLE \| DEFAULT TITLE$/)
			)
		})

		it('should match when rendered error state with all props', async function testAppTitleRenderAllPropsError() {
			buildComponent(TestFactory.makeFullProps('FULL PROPS AGAIN', true))

			await waitForElement(
				getByDocumentTitle(/^Error: FULL PROPS AGAIN \| DEFAULT TITLE$/)
			)
		})
	}) // user should see
})
/* eslint-enable prefer-arrow-callback */
