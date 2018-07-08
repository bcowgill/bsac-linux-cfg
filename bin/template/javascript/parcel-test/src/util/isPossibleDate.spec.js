import isDate from 'lodash/isDate';
import * as pd from './isPossibleDate';

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
  it('prepareYMD 2000, 3, 4 should return dateInfo', function testPrepareYMD20000304() {
    const dateInfo = pd.prepareYMD(2000, 3, 4);
    expect(dateInfo).toEqual({
      "date": new Date('2000-03-04T00:00:00.000Z'),
      "dd": "04",
      "dateDay": 4,
      "dateMonth": 3,
      "dateYear": 2000,
      "day": 4,
      "month": 3,
      "mm": "03",
      "year": 2000,
      "yyyy": "2000",
      "yyyymmdd": "2000-03-04",
      "timestamp": 952128000000,
    });
  });

  it('prepareYMD 32AD, 3, 4 should return dateInfo', function testPrepareYMD32AD0304() {
    const dateInfo = pd.prepareYMD('  32', '  3  ',  '   4  ');
    expect(dateInfo).toEqual({
      "date": new Date('0032-03-04T00:00:00.000Z'),
      "dd": "04",
      "dateDay": 4,
      "dateMonth": 3,
      "dateYear": 32,
      "day": 4,
      "month": 3,
      "mm": "03",
      "year": 32,
      "yyyy": "0032",
      "yyyymmdd": "0032-03-04",
      "timestamp": -61151932800000,
    });
  });


  it('prepareYMD 32BC, 3, 4 should return dateInfo', function testPrepareYMD32BC0304() {
    const dateInfo = pd.prepareYMD('  -32', '  3  ',  '   4  ');
    expect(dateInfo).toEqual({
      "date": new Date('-000032-03-04T00:00:00.000Z'),
      "dateDay": 4,
      "dateMonth": 3,
      "dateYear": -32,
      "day": 4,
      "dd": "04",
      "mm": "03",
      "month": 3,
      "timestamp": -63171619200000,
      "year": -32,
      "yyyy": "-000032",
      "yyyymmdd": "-000032-03-04",
    });
  });

  it('prepareYMD 1999, 99, 99 should return dateInfo', function testPrepareYMD19999999() {
    const dateInfo = pd.prepareYMD('  1999 ', '  99  ',  '   99  ');
    // Must compare invalid date separately of framework generates a Range Error
    expect(dateInfo.date.toString()).toBe('Invalid Date');
    delete dateInfo.date;

    expect(dateInfo).toEqual({
      "dateDay": NaN,
      "dateMonth": NaN,
      "dateYear": NaN,
      "day": 99,
      "dd": "99",
      "mm": "99",
      "month": 99,
      "timestamp": NaN,
      "year": 1999,
      "yyyy": "1999",
      "yyyymmdd": "1999-99-99",
    });
  });

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

  validDates.map((dateArray) => {
    it('should handle valid dates: ' + dateArray.join(', '), function testIsPossibleDateValid() {
      expect(pd.isPossibleDateYMD.apply(null, dateArray)).toBeTruthy();
    });
  });

  invalidDates.map((dateArray) => {
    it('should handle invalid dates: ' + dateArray.join(', '), function testIsPossibleDateInvalid() {
      expect(pd.isPossibleDateYMD.apply(null, dateArray)).toBeFalsy();
    });
  });
});
