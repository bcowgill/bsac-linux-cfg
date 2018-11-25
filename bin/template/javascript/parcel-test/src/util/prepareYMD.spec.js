import isDate from 'lodash/isDate'
import isValidDate from './isValidDate'
import prepareYMD from './prepareYMD'
import * as p from './prepareYMD'

const suite = 'src/util prepareYMD'

describe(suite, function descPrepareYMDSuite() {
	it('should return valid dateInfo for 2000, 3, 4', function testPrepareYMD20000304() {
		const dateInfo = prepareYMD(2000, 3, 4)
		expect(dateInfo).toEqual({
			date: new Date('2000-03-04T00:00:00.000Z'),
			dd: '04',
			dateDay: 4,
			dateMonth: 3,
			dateYear: 2000,
			day: 4,
			month: 3,
			mm: '03',
			year: 2000,
			yyyy: '2000',
			yyyymmdd: '2000-03-04',
			timestamp: 952128000000,
		})
	})

	it('should return valid dateInfo for 32AD, 3, 4 ', function testPrepareYMD32AD0304() {
		const dateInfo = prepareYMD('  32AD', '  03  ', '   04  ')
		expect(dateInfo).toEqual({
			date: new Date('0032-03-04T00:00:00.000Z'),
			dd: '04',
			dateDay: 4,
			dateMonth: 3,
			dateYear: 32,
			day: 4,
			month: 3,
			mm: '03',
			year: 32,
			yyyy: '0032',
			yyyymmdd: '0032-03-04',
			timestamp: -61151932800000,
		})
	})

	it('should return valid dateInfo for 32BC, 3, 4', function testPrepareYMD32BC0304() {
		const dateInfo = prepareYMD('  -32', '  3  ', '   4  ')
		expect(dateInfo).toEqual({
			date: new Date('-000032-03-04T00:00:00.000Z'),
			dateDay: 4,
			dateMonth: 3,
			dateYear: -32,
			day: 4,
			dd: '04',
			mm: '03',
			month: 3,
			timestamp: -63171619200000,
			year: -32,
			yyyy: '-000032',
			yyyymmdd: '-000032-03-04',
		})
	})

	it('should return dateInfo for invalid date 1999, 99, 99', function testPrepareYMD19999999() {
		const dateInfo = prepareYMD('  1999 ', '  99  ', '   99  ')
		// Must compare invalid date separately or testing framework
		// generates a Range Error
		expect(dateInfo.date.toString()).toBe('Invalid Date')
		delete dateInfo.date

		expect(dateInfo).toEqual({
			dateDay: NaN,
			dateMonth: NaN,
			dateYear: NaN,
			day: 99,
			dd: '99',
			mm: '99',
			month: 99,
			timestamp: NaN,
			year: 1999,
			yyyy: '1999',
			yyyymmdd: '1999-99-99',
		})
	})

	it('should return dateInfo for invalid inputs', function testPrepareYMDInvalidInput() {
		const dateInfo = prepareYMD(NaN, 'booga', false)
		// Must compare invalid date separately or testing framework
		// generates a Range Error
		expect(dateInfo.date.toString()).toBe('Invalid Date')
		delete dateInfo.date

		expect(dateInfo).toEqual({
			dateDay: NaN,
			dateMonth: NaN,
			dateYear: NaN,
			day: NaN,
			dd: 'NaN',
			mm: 'NaN',
			month: NaN,
			timestamp: NaN,
			year: NaN,
			yyyy: 'NaN',
			yyyymmdd: 'NaN-NaN-NaN',
		})
	})

	describe('dateOf', function descDateOfSuite() {
		it('should make a valid date', function testDateOfValid() {
			const date = p.dateOf('1234-01-06')
			expect(isDate(date)).toBeTruthy()
			expect(date.toISOString()).toBe('1234-01-06T00:00:00.000Z')
		})

		it('should make an invalid date', function testDateOfInvalid() {
			const date = p.dateOf('-001234-13-99')
			expect(isDate(date)).toBeTruthy()
			expect(isValidDate(date)).toBeFalsy()
		})

		it('should make an invalid date without throwing', function testDateOfNoThrow() {
			const date = p.dateOf(new Date('1999-99-99'))
			expect(isDate(date)).toBeTruthy()
			expect(isValidDate(date)).toBeFalsy()
		})
	})

	describe('parseDateString', function descParseDateStringSuite() {
		it('should parse a date AD', function testParseDateStringPositive() {
			expect(p.parseDateString('1234-01-06')).toEqual(['1234', '01', '06'])
		})

		it('should parse a date BCE', function testParseDateStringNegative() {
			expect(p.parseDateString('-001234-01-06')).toEqual([
				'-001234',
				'01',
				'06',
			])
		})

		it('should be false for anything else', function testParseDateStringInvalid() {
			expect(p.parseDateString('4-01-06')).toBeFalsy()
			expect(p.parseDateString(NaN)).toBeFalsy()
		})
	})
})
