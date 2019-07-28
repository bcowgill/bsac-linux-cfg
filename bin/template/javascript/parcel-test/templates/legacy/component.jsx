import React from 'react';
import classnames from 'classnames';
import PropTypesStyle from 'react-style-proptype';

const displayName = 'TEMPLATE';

export default class TEMPLATE extends React.Component {
  static displayName = displayName;

  static propTypes = {
    className: React.PropTypes.string,
    name: React.PropTypes.string,
    style: PropTypesStyle,
  };

  static defaultProps = {
    className: '',
    name: 'untitled',
    style: {},
  };

  render() {
    const classNames = classnames(this.props.className, displayName);

    return (
      <div
        className={classNames}
        style={this.props.style}
      >
        {this.props.name}
      </div>
    );
  }
}
