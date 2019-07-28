import React from 'react';
import classnames from 'classnames';
import PropTypesStyle from 'react-style-proptype';

const displayName = 'TEMPLATE';

const propTypes = {
  className: React.PropTypes.string,
  name: React.PropTypes.string,
  style: PropTypesStyle,
};

const defaultProps = {
  className: '',
  name: 'untitled',
  style: {},
};

export default function TEMPLATE(props) {
  const classNames = classnames(props.className, displayName);

  return (
    <div
      className={classNames}
      style={props.style}
    >
      {props.name}
    </div>
  );
}
TEMPLATE.displayName = displayName;
TEMPLATE.propTypes = propTypes;
TEMPLATE.defaultProps = defaultProps;
