import isPossibleDateReturn from './isPossibleDateReturn'
import prepareYMD from './prepareYMD'

// Check if a year, month, day tuple would make a valid date if parsed as integers
// year = actual year i.e. 1970, not 70, -32 for BCE dates
// month 1 = january not 0
// returns 'yyyy-mm-dd' '-yyyyyy-mm-dd' or false
export default function isPossibleDateYMDString(year, month, day) {
	const dateInfo = prepareYMD(year, month, day)

	return isPossibleDateReturn(dateInfo, dateInfo.yyyymmdd)
}
