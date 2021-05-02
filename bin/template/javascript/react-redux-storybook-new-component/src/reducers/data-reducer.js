import {
	VALIDATE_USER_REQUEST,
	VALIDATE_USER_SUCCESS,
	VALIDATE_USER_FAILURE,
} from '../actions/types'

const initialState = []

const dataReducer = (state = initialState, action = {}) => {
	switch (action.type) {
		case VALIDATE_USER_REQUEST:
		case VALIDATE_USER_SUCCESS:
		case VALIDATE_USER_FAILURE:
			return [...action.payload]
		default:
			return state
	}
}

export default dataReducer
