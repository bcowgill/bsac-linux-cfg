import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import AppTitle from './components/module/app-title/container'
import configureStore from '../src/reducers/store'
import Home from './journeys/cwa-app/home'
import id from './journeys/cwa-app/id'
import copyProvider from './config'

const store = configureStore

// Get application title information from copy text
const defaultTitle = copyProvider.getResource('app.defaultTitle')
const titleTemplate = copyProvider.getResource('app.titleTemplate')

const renderApp = () =>
	render(
		<Provider store={store}>
			<div id="store-provided">
				<AppTitle defaultTitle={defaultTitle} titleTemplate={titleTemplate} />
				<Home />
			</div>
		</Provider>,
		document.getElementById(id)
	)

/* istanbul ignore next */
if (process.env.NODE_ENV !== 'test') {
	/* istanbul ignore next */
	renderApp()
}

export default renderApp
