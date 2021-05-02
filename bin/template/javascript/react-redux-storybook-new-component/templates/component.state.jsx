import React from 'react'
import noop from 'lodash/noop'
import PropTypes from 'prop-types'
import classnames from 'classnames'
import './styles.less'

const displayName = 'TEMPLATEOBJNAME'

export default class TEMPLATEOBJNAME extends React.Component {
	static displayName = displayName

	static propTypes = {
		id: PropTypes.string,
		className: PropTypes.string,
		name: PropTypes.string,
		onChange: PropTypes.func,
	}

	static defaultProps = {
		id: undefined,
		className: '',
		name: 'untitled',
		onChange: noop,
	}

	constructor(props) {
		super(props)
		this.state = {
			opened: false,
			...props,
		}

		this.handleChange = this.handleChange.bind(this)
	}

	handleChange(event) {
		this.props.onChange(event)
	}

	render() {
		const classNames = classnames(this.props.className, displayName)

		return (
			<div
				id={this.props.id}
				data-testid={this.props.id || displayName}
				className={classNames}
			>
				{this.props.name}
			</div>
		)
	}
}
