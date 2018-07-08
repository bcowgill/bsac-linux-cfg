import isPossibleDateReturn from './isPossibleDateReturn';
import prepareYMD from './prepareYMD';

// Check if a year, month, day tuple would make a valid date if parsed as integers
// year = actual year i.e. 1970, not 70, -32 for BCE dates
// month 1 = january not 0
// returns date object or false
export default function isPossibleDateYMD(year, month, day) {
  const dateInfo = prepareYMD(year, month, day);

  return isPossibleDateReturn(dateInfo, dateInfo.date);
}
