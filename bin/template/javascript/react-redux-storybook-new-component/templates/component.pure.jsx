import React from 'react'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import './styles.less'

const displayName = 'TEMPLATEOBJNAME'

const propTypes = {
	id: PropTypes.string,
	className: PropTypes.string,
	name: PropTypes.string,
}

const defaultProps = {
	id: undefined,
	className: '',
	name: 'untitled',
}

/* eslint-disable prefer-arrow-callback */
export default function TEMPLATEOBJNAME(props) {
	const classNames = classnames(props.className, displayName)

	return (
		<div data-testid={props.id || displayName} className={classNames}>
			{props.name}
		</div>
	)
}
TEMPLATEOBJNAME.displayName = displayName
TEMPLATEOBJNAME.propTypes = propTypes
TEMPLATEOBJNAME.defaultProps = defaultProps
