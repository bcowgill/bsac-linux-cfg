import isValidDate from './isValidDate'

// dateInfo as provided by prepareYMD()
export default function isPossibleDateReturn(dateInfo, result) {
	return (
		// prettier-ignore
		isValidDate(dateInfo.date)
		&& dateInfo.dateMonth === dateInfo.month
		&& dateInfo.dateDay === dateInfo.day
		&& dateInfo.dateYear === dateInfo.year
		&& result
	)
}
