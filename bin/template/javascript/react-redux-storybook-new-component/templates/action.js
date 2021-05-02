// TODO may need to add the ACTION defined below to ../types
import { TEMPLATEACTION_SUCCESS } from './types'

/* eslint-disable import/prefer-default-export */
export const TEMPLATEOBJNAMESuccess = (response) => ({
	type: TEMPLATEACTION_SUCCESS,
	payload: response,
})
