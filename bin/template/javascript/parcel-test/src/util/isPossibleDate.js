// isPossibleDate.js
// used to check if a given year, month, date value could be used to create a valid date.

import isString from 'lodash/isString';
import isValidDate from'./isValidDate';

const DECIMAL = 10;
const INVALID_DATE = new Date('2000-99-99');

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
function dateOf(dateString, dateInfo) {
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
    // for years too far out of range
    date = INVALID_DATE;
  }
// console.error('dateOf', dateString, dateInfo);
  return date;
}

export function prepareYMD(year, month, day) {
  const yearValue = parseInt(year, DECIMAL);
  const monthValue = parseInt(month, DECIMAL);
  const dayValue = parseInt(day, DECIMAL);
  const yearString = padYear(yearValue);
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
    date: INVALID_DATE,
    dateYear: NaN,
    dateMonth: NaN,
    dateDay: NaN,
    timestamp: NaN,
  };
  dateOf(dateString, dateInfo);

  return dateInfo;
}

export function isPossibleDateReturn(dateInfo, result) {
  return isValidDate(dateInfo.date)
    && dateInfo.dateMonth === dateInfo.month
    && dateInfo.dateDay === dateInfo.day
    && dateInfo.dateYear === dateInfo.year
    && result;
}

// Check if a year, month, day tuple would make a valid date if parsed as integers
// year = actual year i.e. 1970, not 70
// month 1 = january not 0
// returns date object or false
export function isPossibleDateYMD(year, month, day) {
  const dateInfo = prepareYMD(year, month, day);

  return isPossibleDateReturn(dateInfo, dateInfo.date);
}

// returns 'yyyy-mm-dd' or false
export function isPossibleDateYMDString(year, month, day) {
  const dateInfo = prepareYMD(year, month, day);

  return isPossibleDateReturn(dateInfo, dateInfo.yyyymmdd);
}

// returns ['yyyy', 'mm', 'dd'] or false
export function isPossibleDateYMDParts(year, month, day) {
  const dateInfo = prepareYMD(year, month, day);

  return isPossibleDateReturn(dateInfo, [dateInfo.yyyy, dateInfo.mm, dateInfo.dd]);
}

export default function isPossibleDate(checkDate, ...rest) {
//  if (isString)

  const date = isString(checkDate) ? new Date(checkDate) : checkDate;
  return isValidDate(date);
}
