import isNaN from'lodash/isNaN';
import isDate from 'lodash/isDate';

// Checks if a date object was created with a valid date
// returns false for non-date objects
export default function isValidDate(date) {
  return (isDate(date) && !isNaN(date.getMonth()));
}
