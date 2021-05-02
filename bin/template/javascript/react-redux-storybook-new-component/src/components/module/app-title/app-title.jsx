import React from 'react'
import noop from 'lodash/noop'
import PropTypes from 'prop-types'
import { Helmet } from 'react-helmet'

const displayName = 'AppTitle'

const propTypes = {
	defaultTitle: PropTypes.string,
	titleTemplate: PropTypes.string,
	title: PropTypes.string,
	error: PropTypes.bool,
	onChangeClientState: PropTypes.func,
}

const defaultProps = {
	defaultTitle: undefined,
	titleTemplate: undefined,
	title: undefined,
	error: false,
	onChangeClientState: noop,
}

/* eslint-disable prefer-arrow-callback */
export default function AppTitle(props) {
	const useTitle = props.title || props.defaultTitle || ''
	const title = props.error ? `Error: ${useTitle}` : props.title
	return (
		<Helmet
			defaultTitle={props.defaultTitle}
			titleTemplate={props.titleTemplate}
			title={title}
			onChangeClientState={props.onChangeClientState}
		/>
	)
}
AppTitle.displayName = displayName
AppTitle.propTypes = propTypes
AppTitle.defaultProps = defaultProps
