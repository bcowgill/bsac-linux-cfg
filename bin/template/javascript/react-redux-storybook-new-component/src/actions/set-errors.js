// set-errors.js - Application level action to set or clear errors
import { SET_ERRORS } from './types'

/* eslint-disable import/prefer-default-export */
export const setErrors = (errors = []) => ({
	type: SET_ERRORS,
	errors,
})
