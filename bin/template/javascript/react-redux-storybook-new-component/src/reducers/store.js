import thunk from 'redux-thunk'
// import promiseMe from 'redux-promise-middleware'
import { createStore, applyMiddleware, compose } from 'redux'
import rootReducer from './rootReducer'

// Redux middlewares ...
// https://chariotsolutions.com/blog/post/redux-middleware-and-enhancers-getting-redux-to-log-debug-and-process-async-work/

// For Redux DevTools Chrome Extension support
// set up our composeEnhancers function, baed on the existence of the
// DevTools extension when creating the store and the build environment
let composeEnhancers = compose

const middleware = [thunk]
if (process.env.NODE_ENV !== 'production') {
	// eslint-disable-next-line global-require
	const logger = require('redux-logger').default
	middleware.push(logger) // must be last middleware
	// eslint-disable-next-line no-underscore-dangle
	composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose
}

const configureStore = createStore(
	rootReducer,
	undefined, // or initial state
	composeEnhancers(applyMiddleware(...middleware))
)

export default configureStore
