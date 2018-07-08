import isDate from 'lodash/isDate';
import isPossibleDate from './isPossibleDate';
import * as pd from './isPossibleDate';
import prepareYMD from './prepareYMD';


const suite = 'src/util isPossibleDate';

const validDates = [
  ['2000', '1', '2'],
  [2000, 1, 2],
  [2000, 2, 29],
  [1999, 2, 28],
];

const invalidDates = [
  [undefined, NaN, 'plugh'],
  ['2000', '61', '290'],
  [2000, 61, 290],
  [2000, 2, 30],
  [1999, 2, 29],
];

describe(suite, function descIsPossibleDate() {
  it('isPossibleDateYMD should return date object for valid dates: ', function testIsPossibleDateValidAsDate() {
    const date = pd.isPossibleDateYMD(2000, 3, 4);
    expect(isDate(date)).toBeTruthy();
  });

  it('isPossibleDateYMD should return date object for timestamp 0: ', function testIsPossibleDateValidZero() {
    const zeroDate = new Date(0);
    const date = pd.isPossibleDateYMD(
      1900 + zeroDate.getYear(),
      1 + zeroDate.getMonth(),
      zeroDate.getDate());
    expect(isDate(date)).toBeTruthy();
  });

  it('isPossibleDateYMDString should return YMD dateString for valid dates: ', function testIsPossibleDateValidAsDateString() {
    const date = pd.isPossibleDateYMDString(2000, 3, 4);
    expect(date).toBe('2000-03-04');
  });

  it('isPossibleDateYMDParts should return YMD padded array for valid dates: ', function testIsPossibleDateValidAsArray() {
    const date = pd.isPossibleDateYMDParts(2000, 3, 4);
    expect(date).toEqual(["2000", "03", "04"]);
  });

  it('isPossibleDate should return dateInfo for valid dates: ', function testIsPossibleDateValidAsDateInfo() {
    const date = isPossibleDate(2000, 3, 4);
    expect(date).toEqual({
      "date": new Date('2000-03-04T00:00:00.000Z'),
      "dateDay": 4,
      "dateMonth": 3,
      "dateYear": 2000,
      "day": 4,
      "dd": "04",
      "mm": "03",
      "month": 3,
      "timestamp": 952128000000,
      "year": 2000,
      "yyyy": "2000",
      "yyyymmdd": "2000-03-04",
    });
  });

  validDates.map((dateArray) => {
    it('should handle valid dates: ' + dateArray.join(', '), function testIsPossibleDateValid() {
      expect(pd.isPossibleDateYMD.apply(null, dateArray)).toBeTruthy();
      expect(pd.isPossibleDateYMDString.apply(null, dateArray)).toBeTruthy();
      expect(pd.isPossibleDateYMDParts.apply(null, dateArray)).toBeTruthy();
      expect(isPossibleDate.apply(null, dateArray)).toBeTruthy();

      const dateString = prepareYMD.apply(null, dateArray).yyyymmdd;
      expect(isPossibleDate(dateString)).toBeTruthy();
    });
  });

  invalidDates.map((dateArray) => {
    it('should handle invalid dates: ' + dateArray.join(', '), function testIsPossibleDateInvalid() {
      expect(pd.isPossibleDateYMD.apply(null, dateArray)).toBeFalsy();
      expect(pd.isPossibleDateYMDString.apply(null, dateArray)).toBeFalsy();
      expect(pd.isPossibleDateYMDParts.apply(null, dateArray)).toBeFalsy();
      expect(isPossibleDate.apply(null, dateArray)).toBeFalsy();

      const dateString = prepareYMD.apply(null, dateArray).yyyymmdd;
      expect(isPossibleDate(dateString)).toBeFalsy();
    });
  });
});
