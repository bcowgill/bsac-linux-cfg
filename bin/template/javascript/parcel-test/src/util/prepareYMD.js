// prepareYMD.js
// somewhat internal to prepare year month date values for possible date validation

const DECIMAL = 10;
const reDateString = /^(-?\d{4,6})-(\d{2})-(\d{2})$/;

function INVALID_DATE() {
  return new Date('2000-99-99');
}

// pad to number of digits with optional negative sign
function padDigits(value, length) {
  if (value < 0) {
    return '-' + padDigits(-value, length);
  }
  const valueString = '' + value;
  if (valueString.length >= length) {
    return valueString;
  }
  return '0' + padDigits(value, length - 1);
}

// pad year to 4 digits if positive or 6 digits if negative
function padYear(yearValue) {
  let yearString;
  if (isNaN(yearValue)) {
    yearString = yearValue;
  }
  else if (yearValue < 0) {
    yearString = padDigits(yearValue, 6);
  }
  else {
    yearString = padDigits(yearValue, 4);
  }
  return yearString;
}

// makes a date object, valid or invalid, but does not throw an error
// updates dateInfo for the date if it is valid so that nothing throws.
export function dateOf(dateString, dateInfo = {}) {
  let date;
  try {
    date = new Date(dateString);
    dateInfo.date = date;
    dateInfo.dateYear = 1900 + date.getYear();
    dateInfo.dateMonth = 1 + date.getMonth();
    dateInfo.dateDay = date.getDate();
    dateInfo.timestamp = date.getTime();
  }
  catch (ignored) {
    // may be impossible to get here now...
    date = INVALID_DATE();
  }
  return date;
}

// Input may be a dateString only
// dateString: yyyy-mm-dd or -yyyyyy-mm-dd
// returns array of year, month, day values or false
export function parseDateString(dateString) {
  const match = ('' + dateString).match(reDateString);
  return match ? [match[1], match[2], match[3]] : false;
}

// year, month, day should be parseable as an integer
// or you will get an invalid date returned
export default function prepareYMD(year, month, day) {
  const yearValue = parseInt(year, DECIMAL);
  const monthValue = parseInt(month, DECIMAL);
  const dayValue = parseInt(day, DECIMAL);
  const yearString = '' + padYear(yearValue);
  const monthString = (monthValue < 10 ? '0' : '') + monthValue;
  const dayString = (dayValue < 10 ? '0' : '') + dayValue;
  const dateString = `${yearString}-${monthString}-${dayString}`;

  const dateInfo = {
    year: yearValue,
    month: monthValue,
    day: dayValue,
    yyyymmdd: dateString,
    yyyy: yearString,
    mm: monthString,
    dd: dayString,
    date: INVALID_DATE(),
    dateYear: NaN,
    dateMonth: NaN,
    dateDay: NaN,
    timestamp: NaN,
  };
  dateOf(dateString, dateInfo);

  return dateInfo;
}
