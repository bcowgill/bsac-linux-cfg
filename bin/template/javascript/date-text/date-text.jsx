import React from 'react';
import classnames from 'classnames';
import PropTypesStyle from 'react-style-proptype';
import dateFormat from '../date-format';

const displayName = 'DateText';
const DATE_FORMAT = 'dddd D MMM YYYY h:mm:ss A';

const propTypes = {
  id: React.PropTypes.string,
  className: React.PropTypes.string,
  date: React.PropTypes.instanceOf(Date).isRequired,
  dateFormat: React.PropTypes.string,
  style: PropTypesStyle,
};

const defaultProps = {
  id: undefined,
  className: '',
  dateFormat: DATE_FORMAT,
  style: {},
};

export default function DateText(props) {
  const classNames = classnames(props.className, displayName);
  const isoDate = props.date.toISOString();
  const date = dateFormat(props.dateFormat, props.date);

  return (
    <time
      id={props.id}
      className={classNames}
      dateTime={isoDate}
      title={isoDate}
      style={props.style}
    >
      {date}
    </time>
  );
}
DateText.displayName = displayName;
DateText.propTypes = propTypes;
DateText.defaultProps = defaultProps;
