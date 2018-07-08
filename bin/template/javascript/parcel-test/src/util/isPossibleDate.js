// isPossibleDate.js
// used to check if a given year, month, date value could be used to create a valid date.

import isValidDate from'./isValidDate';
import prepareYMD, { parseDateString } from './prepareYMD';

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

// Input may be a dateString or year, month, day values
// dateString: yyyy-mm-dd or -yyyyyy-mm-dd
// returns dateInfo object or false
export default function isPossibleDate(checkDate, ...rest) {
  const ymd = (rest.length < 2)
    ? parseDateString(checkDate)
    : [checkDate, rest[0], rest[1]];

  if (ymd) {
    const dateInfo = prepareYMD.apply(null, ymd);
    return isPossibleDateReturn(dateInfo, dateInfo);
  }
  return false;
}
