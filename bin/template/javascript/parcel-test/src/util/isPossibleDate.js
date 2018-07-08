// isPossibleDate.js
// used to check if a given year, month, date value could be used to create a valid date.

import prepareYMD, { parseDateString } from './prepareYMD';
import isPossibleDateReturn from './isPossibleDateReturn';

// Input may be a dateString or year, month, day values
// dateString: yyyy-mm-dd or -yyyyyy-mm-dd
// year = actual year i.e. 1970, not 70, -32 for BCE dates
// month 1 = january not 0
// returns dateInfo object (see prepareYMD()) or false
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
