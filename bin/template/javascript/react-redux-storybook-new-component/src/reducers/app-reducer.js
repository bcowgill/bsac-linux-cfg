import { SET_ERRORS, SET_TITLE } from '../actions/types'

const initialState = {
	title: undefined,
	errors: [],
}

const appReducer = (state = initialState, action = {}) => {
	switch (action.type) {
		case SET_TITLE:
			return { ...state, title: action.title }
		case SET_ERRORS:
			return { ...state, errors: action.errors }
		default:
			return state
	}
}

export default appReducer
