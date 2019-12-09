// windows version of it function
// change this from it to xit when running on windows to skip the
// tests which have promise rejection errors, until we fix the problem.

// istanbul ignore next
const skipOnWindows = /^win/i.test(navigator.platform) ? xit : it;
// for example: MacIntel, Win32, Linux x86_64

// istanbul ignore next
const skipOnJenkins =
  /^Linux/i.test(navigator.platform) && /PhantomJS/.test(navigator.appVersion)
    ? xit
    : it;

// istanbul ignore next
const skipOnWindowsOrJenkins =
  skipOnWindows === xit ? skipOnWindows : skipOnJenkins;

// console.log('XYZZY platform', navigator);
// console.log('XYZZY win', skipOnWindows === xit);
// console.log('XYZZY jenk', skipOnJenkins === xit);
// console.log('XYZZY win|jenk', skipOnWindowsOrJenkins === xit);

class PromiseNotRejectedError extends Error {
  constructor() {
    super('promise was resolved but should have been rejected');
  }
}

class PromiseNotResolvedError extends Error {
  constructor() {
    super('promise was rejected but should have been resolved');
  }
}

export function expectOk(name, expected, value, expekt = expect) {
  expekt(`${name} ${value}`).toBe(`${name} ${expected}`);
}

export function expectTrue(name, value, expekt = expect) {
  expectOk(name, true, value, expekt);
}

export function expectFalse(name, value, expekt = expect) {
  expectOk(name, false, value, expekt);
}

export function expectTruthy(name, value, expekt = expect) {
  if (value) {
    expekt(value).toBeTruthy();
  } else {
    expectOk(name, 'truthy', value, expekt);
  }
}

export function expectFalsy(name, value, expekt = expect) {
  if (!value) {
    expekt(value).toBeFalsy();
  } else {
    expectOk(name, 'falsy', value, expekt);
  }
}

export function expectUndefined(name, value, expekt = expect) {
  if (typeof value === 'undefined') {
    expekt(value).toBeUndefined();
  } else {
    expectOk(name, undefined, value, expekt);
  }
}

export function expectNull(name, value, expekt = expect) {
  if (value === null) {
    expekt(value).toBeNull();
  } else {
    expectOk(name, null, value, expekt);
  }
}

// Empty Array, Object constants
const EOA = [];
const EOB = {};

// eslint-disable-next-line import/no-mutable-exports
let expectObjectsDeepEqual;

// Jasmine reports .toEqual() differences very poorly so this
// can be used to get a better view of how arrays differ when a
// test fails.
// change expect(actual).toEqual(expected)
// to expectObjectsDeepEqual(actual, expected)
// this function will be used automatically if they are arrays
function expectArraysDeepEqual(
  actual = EOA,
  expected = EOA,
  symbolPath = '',
  spy = console.error,
  expekt = expect
) {
  const actualArray = Array.isArray(actual);
  const expectedArray = Array.isArray(expected);

  if (actual === expected || !actualArray || !expectedArray) {
    if ((actualArray && !expectedArray) || (!actualArray && expectedArray)) {
      spy(
        `actual${symbolPath}: ${
          actualArray ? 'is an array' : 'is NOT an array'
        } which differs from`
      );
      spy(
        `expected${symbolPath}: ${
          expectedArray ? 'is an array' : 'is NOT an array'
        }`
      );
    }
    if (!symbolPath || actual === expected) {
      expekt(actual).toEqual(expected);
    } else {
      expekt({ [symbolPath.trim()]: actual }).toEqual({
        [symbolPath.trim()]: expected
      });
    }
  } else {
    const length = Math.max(actual.length, expected.length);
    const min = Math.min(actual.length, expected.length);

    if (length !== min) {
      spy(
        `array actual${symbolPath}: has length ${
          actual.length
        } which differs from`
      );
      spy(`array expected${symbolPath}: has length ${expected.length}`);
      expekt(`array actual${symbolPath}: has length ${actual.length}`).toEqual(
        `array expected${symbolPath}: has length ${expected.length}`
      );
    }

    for (let index = 0; index < length; index += 1) {
      const indexPath = `${symbolPath || 'array'}[${index}]`;
      const indexPathKey = indexPath.trim();
      if (index < min) {
        if (
          actual[index] === null ||
          expected[index] === null ||
          (typeof actual[index] !== 'object' &&
            typeof expected[index] !== 'object')
        ) {
          expekt({ [indexPathKey]: actual[index] }).toEqual({
            [indexPathKey]: expected[index]
          });
        } else {
          expectObjectsDeepEqual(
            actual[index],
            expected[index],
            indexPath,
            spy,
            expekt
          );
        }
      } else if (index >= actual.length) {
        spy(
          `array actual${indexPath}: is missing value from expected${indexPath}`,
          expected[index]
        );
        expekt({ [indexPathKey]: undefined }).toEqual({
          [indexPathKey]: expected[index]
        });
      } else {
        spy(
          `array expected${indexPath}: is missing value from actual${indexPath}`,
          actual[index]
        );
        expekt({ [indexPathKey]: actual[index] }).toEqual({
          [indexPathKey]: undefined
        });
      }
    }
  }
} // expectArraysDeepEqual()

// Jasmine reports .toEqual() differences very poorly so this
// can be used to get a better view of how objects differ when a
// test fails.
// change expect(actual).toEqual(expected)
// to expectObjectsDeepEqual(actual, expected)
expectObjectsDeepEqual = (
  actual = EOB,
  expected = EOB,
  symbolPath = '',
  spy = console.error,
  expekt = expect
) => {
  if (
    actual === null ||
    expected === null ||
    typeof actual !== 'object' ||
    typeof expected !== 'object' ||
    Array.isArray(actual) ||
    Array.isArray(expected)
  ) {
    expectArraysDeepEqual(actual, expected, symbolPath, spy, expekt);
  } else {
    const missingKeys = [];
    const commonKeys = [];

    let keys = Object.keys(actual);
    keys.sort().forEach((actualKey) => {
      if (actualKey in expected) {
        commonKeys.push(actualKey);
      } else {
        spy(`actual${symbolPath} key: ${actualKey} missing in expected object`);
        spy(`actual${symbolPath}[${actualKey}] =`, actual[actualKey]);
        missingKeys.push(`expected${symbolPath}[${actualKey}]`);
      }
    });

    keys = Object.keys(expected);
    keys.sort().forEach((expectedKey) => {
      if (!(expectedKey in actual)) {
        spy(
          `expected${symbolPath} key: ${expectedKey} missing in actual object`
        );
        spy(`expected${symbolPath}[${expectedKey}] =`, expected[expectedKey]);
        missingKeys.push(`actual${symbolPath}[${expectedKey}]`);
      }
    });

    missingKeys.push('missing keys:');

    expekt(missingKeys.reverse()).toEqual(['missing keys:']);
    commonKeys.sort().forEach((key) => {
      const indexPath = (symbolPath ? `${symbolPath}.${key}` : key).trim();
      expekt({ [indexPath]: actual[key] }).toEqual({
        [indexPath]: expected[key]
      });
    });
    expekt(actual).toEqual(expected);
  }
};

export {
  skipOnWindows,
  skipOnJenkins,
  skipOnWindowsOrJenkins,
  expectArraysDeepEqual,
  expectObjectsDeepEqual,
  PromiseNotRejectedError,
  PromiseNotResolvedError
};
