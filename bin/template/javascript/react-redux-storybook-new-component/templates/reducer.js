// TODO may need to add the ACTION defined below to ../actions/types
// TODO may need to list this reducer within rootReducer
import { TEMPLATEACTION_SUCCESS } from '../actions/types'

const initialState = {
	data: [],
}

const TEMPLATEOBJNAME = (state = initialState, action = {}) => {
	switch (action.type) {
		case TEMPLATEACTION_SUCCESS:
			return { ...state, ...action.payload }
		default:
			return state
	}
}

export default TEMPLATEOBJNAME
