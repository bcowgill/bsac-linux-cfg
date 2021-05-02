import { combineReducers } from 'redux'
import appReducer from './app-reducer'
import dataReducer from './data-reducer'

const rootReducer = combineReducers({
	data: dataReducer,
	app: appReducer,
})

export default rootReducer
