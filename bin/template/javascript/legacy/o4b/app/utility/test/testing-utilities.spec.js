import sinon from 'sinon';
import {
  expectOk,
  expectTrue,
  expectFalse,
  expectTruthy,
  expectFalsy,
  expectUndefined,
  expectNull,
  expectArraysDeepEqual,
  expectObjectsDeepEqual,
  PromiseNotResolvedError,
  PromiseNotRejectedError
} from '../testing-utilities';

const suite = 'app/utility/test/testing-utilities.spec.js';

describe(suite, function descTestingUtilitiesSuite() {
  describe('testing-utilities', () => {
    let expectSpy;
    let toBeSpy;

    function checkTestFail(name, expected, value) {
      expect(expectSpy.callCount).toBe(1);
      expect(expectSpy.lastCall.args).toEqual([`${name} ${value}`]);
      expect(toBeSpy.callCount).toBe(1);
      expect(toBeSpy.lastCall.args).toEqual([`${name} ${expected}`]);
    }

    beforeEach(function setupTests() {
      expectSpy = sinon.stub();
      toBeSpy = sinon.stub();
      expectSpy.returns({ toBe: toBeSpy });
    });

    describe('expectOk', () => {
      it('should pass if same', () => {
        expectOk('expectOk', true, true);
      });

      it('should fail if differs', () => {
        expectOk('expectOk', true, false, expectSpy);
        checkTestFail('expectOk', true, false);
      });
    });

    describe('expectTrue', () => {
      it('should pass if true', () => {
        expectTrue('expectTrue', true);
      });

      it('should fail if not true', () => {
        expectTrue('expectTrue', false, expectSpy);
        checkTestFail('expectTrue', true, false);
      });
    });

    describe('expectFalse', () => {
      it('should pass if false', () => {
        expectFalse('expectFalse', false);
      });

      it('should fail if not false', () => {
        expectFalse('expectFalse', true, expectSpy);
        checkTestFail('expectFalse', false, true);
      });
    });

    describe('expectTruthy', () => {
      it('should pass if truthy', () => {
        expectTruthy('expectTruthy', 42);
      });

      it('should fail if not truthy', () => {
        expectTruthy('expectTruthy', false, expectSpy);
        checkTestFail('expectTruthy', 'truthy', false);
      });
    });

    describe('expectFalsy', () => {
      it('should pass if falsy', () => {
        expectFalsy('expectFalsy', undefined);
      });

      it('should fail if not falsy', () => {
        expectFalsy('expectFalsy', true, expectSpy);
        checkTestFail('expectFalsy', 'falsy', true);
      });
    });

    describe('expectUndefined', () => {
      it('should pass if undefined', () => {
        expectUndefined('expectUndefined', undefined);
      });

      it('should fail if not undefined', () => {
        expectUndefined('expectUndefined', true, expectSpy);
        checkTestFail('expectUndefined', undefined, true);
      });
    });

    describe('expectNull', () => {
      it('should pass if null', () => {
        expectNull('expectNull', null);
      });

      it('should fail if not null', () => {
        expectNull('expectNull', true, expectSpy);
        checkTestFail('expectNull', null, true);
      });
    });

    describe('PromiseNotRejectedError', () => {
      it('should be an error', () => {
        const error = new PromiseNotRejectedError();
        expect(error).toEqual(jasmine.any(Error)); // instanceof test
        expect(error.toString()).toBe(
          'Error: promise was resolved but should have been rejected'
        );
      });
    }); // PromiseNotRejectedError()

    describe('PromiseNotResolvedError', () => {
      it('should be an error', () => {
        const error = new PromiseNotResolvedError();
        expect(error).toEqual(jasmine.any(Error)); // instanceof test
        expect(error.toString()).toBe(
          'Error: promise was rejected but should have been resolved'
        );
      });
    }); // PromiseNotResolvedError()

    describe('expectArraysDeepEqual', () => {
      const account1 = [42, { extra1: 'extra', name: 'current', same: 'same' }];
      const account2 = [
        42,
        { name: 'current 2', extra2: 'more', same: 'same' }
      ];

      it('should handle identicality', () => {
        expectArraysDeepEqual(account1, account1, 'account1', sinon.spy());
      });

      it('should handle defaults', () => {
        expectArraysDeepEqual();
        expectArraysDeepEqual(null, null);
      });

      it('should handle non arrays well enough', () => {
        expectArraysDeepEqual(42, 42, 'constant', sinon.spy());
      });

      it('should assert when identical', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectArraysDeepEqual(43, 43, 'identical', () => null, exp);

        expect(spy.callCount).toBe(1);
        expect(spy.getCall(0).args).toEqual([43, 43]);
      });

      it('should assert when mixed types with NO symbol path', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectArraysDeepEqual('string', 42, '', () => null, exp);

        expect(spy.callCount).toBe(1);
        expect(spy.getCall(0).args).toEqual(['string', 42]);
      });

      it('should assert with arrays with NO symbol path', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectArraysDeepEqual(['string'], [42], '', () => null, exp);

        expect(spy.callCount).toBe(1);
        expect(spy.getCall(0).args).toEqual([
          { 'array[0]': 'string' },
          { 'array[0]': 42 }
        ]);
      });

      it('should assert when mixed types with symbol path', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectArraysDeepEqual('string', 42, 'mixed', () => null, exp);

        expect(spy.callCount).toBe(1);
        expect(spy.getCall(0).args).toEqual([
          { mixed: 'string' },
          { mixed: 42 }
        ]);
      });

      it('should report when diffing arrays of different lengths', () => {
        const spy = sinon.spy();
        const exp = () => {
          return { toEqual: () => {} };
        };

        expectArraysDeepEqual([1, 2, 3], [1, 2], '.numbers', spy, exp);

        expect(spy.callCount).toBe(3);
        expect(spy.getCall(0).args).toEqual([
          'array actual.numbers: has length 3 which differs from'
        ]);
        expect(spy.getCall(1).args).toEqual([
          'array expected.numbers: has length 2'
        ]);
        expect(spy.getCall(2).args).toEqual([
          'array expected.numbers[2]: is missing value from actual.numbers[2]',
          3
        ]);
      });

      it('should assert when diffing arrays of different lengths', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectArraysDeepEqual([1, 2, 3], [1, 2], 'numbers', () => null, exp);

        expect(spy.callCount).toBe(4);
        expect(spy.getCall(0).args).toEqual([
          'array actualnumbers: has length 3',
          'array expectednumbers: has length 2'
        ]);
        expect(spy.getCall(1).args).toEqual([
          { 'numbers[0]': 1 },
          { 'numbers[0]': 1 }
        ]);
        expect(spy.getCall(2).args).toEqual([
          { 'numbers[1]': 2 },
          { 'numbers[1]': 2 }
        ]);
        expect(spy.getCall(3).args).toEqual([
          { 'numbers[2]': 3 },
          { 'numbers[2]': undefined }
        ]);
      });

      it('should report when expected array is longer than actual array', () => {
        const spy = sinon.spy();
        const exp = () => {
          return { toEqual: () => {} };
        };

        expectArraysDeepEqual([1, 2], [1, 2, 3], '.numbers', spy, exp);

        expect(spy.callCount).toBe(3);
        expect(spy.getCall(0).args).toEqual([
          'array actual.numbers: has length 2 which differs from'
        ]);
        expect(spy.getCall(1).args).toEqual([
          'array expected.numbers: has length 3'
        ]);
        expect(spy.getCall(2).args).toEqual([
          'array actual.numbers[2]: is missing value from expected.numbers[2]',
          3
        ]);
      });

      it('should assert when expected array is longer than actual array', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectArraysDeepEqual([1, 2], [1, 2, 3], 'numbers', () => null, exp);

        expect(spy.callCount).toBe(4);
        expect(spy.getCall(0).args).toEqual([
          'array actualnumbers: has length 2',
          'array expectednumbers: has length 3'
        ]);
        expect(spy.getCall(1).args).toEqual([
          { 'numbers[0]': 1 },
          { 'numbers[0]': 1 }
        ]);
        expect(spy.getCall(2).args).toEqual([
          { 'numbers[1]': 2 },
          { 'numbers[1]': 2 }
        ]);
        expect(spy.getCall(3).args).toEqual([
          { 'numbers[2]': undefined },
          { 'numbers[2]': 3 }
        ]);
      });

      it('should assert on each element/key when diffing arrays with objects', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectArraysDeepEqual(account1, account2, ' account1', () => null, exp);

        expect(spy.callCount).toBe(5);
        expect(spy.getCall(0).args).toEqual([
          { 'account1[0]': 42 },
          { 'account1[0]': 42 }
        ]);
        expect(spy.getCall(1).args).toEqual([
          [
            'missing keys:',
            'actual account1[1][extra2]',
            'expected account1[1][extra1]'
          ],
          ['missing keys:']
        ]);
        expect(spy.getCall(2).args).toEqual([
          { 'account1[1].name': 'current' },
          { 'account1[1].name': 'current 2' }
        ]);
        expect(spy.getCall(3).args).toEqual([
          { 'account1[1].same': 'same' },
          { 'account1[1].same': 'same' }
        ]);
        expect(spy.getCall(4).args).toEqual([account1[1], account2[1]]);
      });
    }); // expectArraysDeepEqual()

    describe('expectObjectsDeepEqual', () => {
      const account1 = { extra1: 'extra', name: 'current', same: 'same' };
      const account2 = { name: 'current 2', extra2: 'more', same: 'same' };

      it('should handle identicality', () => {
        expectObjectsDeepEqual(account1, account1, ' account1', sinon.spy());
      });

      it('should handle defaults', () => {
        expectObjectsDeepEqual();
        expectObjectsDeepEqual(null, null);
      });

      it('should handle non objects well enough', () => {
        expectObjectsDeepEqual(42, 42, 'constant', sinon.spy());
      });

      it('should handle arrays by handing over to expectArraysDeepEqual', () => {
        expectObjectsDeepEqual(
          [account1],
          [account1],
          '[account1]',
          sinon.spy()
        );
      });

      it('should assert when mixed types with NO symbol path', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectObjectsDeepEqual('string', 42, '', () => null, exp);

        expect(spy.callCount).toBe(1);
        expect(spy.getCall(0).args).toEqual(['string', 42]);
      });

      it('should assert with arrays with NO symbol path', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectObjectsDeepEqual(['string'], [42], '', () => null, exp);

        expect(spy.callCount).toBe(1);
        expect(spy.getCall(0).args).toEqual([
          { 'array[0]': 'string' },
          { 'array[0]': 42 }
        ]);
      });

      it('should assert with objects with NO symbol path', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectObjectsDeepEqual(
          { value: 'string' },
          { value: 42 },
          '',
          () => null,
          exp
        );

        expect(spy.callCount).toBe(3);
        expect(spy.getCall(0).args).toEqual([
          ['missing keys:'],
          ['missing keys:']
        ]);
        // one key at a time...
        expect(spy.getCall(1).args).toEqual([
          { value: 'string' },
          { value: 42 }
        ]);
        // compares the whole object as fallback
        expect(spy.getCall(2).args).toEqual([
          { value: 'string' },
          { value: 42 }
        ]);
      });

      it('should report missing keys', () => {
        const spy = sinon.spy();
        const exp = () => {
          return { toEqual: () => {} };
        };

        expectObjectsDeepEqual(account1, account2, ' account1', spy, exp);

        expect(spy.callCount).toBe(4);
        expect(spy.getCall(0).args).toEqual([
          'actual account1 key: extra1 missing in expected object'
        ]);
        expect(spy.getCall(1).args).toEqual([
          'actual account1[extra1] =',
          'extra'
        ]);
        expect(spy.getCall(2).args).toEqual([
          'expected account1 key: extra2 missing in actual object'
        ]);
        expect(spy.getCall(3).args).toEqual([
          'expected account1[extra2] =',
          'more'
        ]);
      });

      it('should assert on common keys one by one', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectObjectsDeepEqual(
          account1,
          account2,
          ' account1',
          () => null,
          exp
        );

        expect(spy.callCount).toBe(4);
        expect(spy.getCall(0).args).toEqual([
          [
            'missing keys:',
            'actual account1[extra2]',
            'expected account1[extra1]'
          ],
          ['missing keys:']
        ]);
        expect(spy.getCall(1).args).toEqual([
          { 'account1.name': 'current' },
          { 'account1.name': 'current 2' }
        ]);
        expect(spy.getCall(2).args).toEqual([
          { 'account1.same': 'same' },
          { 'account1.same': 'same' }
        ]);
        expect(spy.getCall(3).args).toEqual([account1, account2]);
      });

      it('should report when array compared with object', () => {
        const spy = sinon.spy();
        const exp = () => {
          return { toEqual: () => {} };
        };

        expectObjectsDeepEqual(account1, [account2], ' mismatchoa', spy, exp);

        expect(spy.callCount).toBe(2);
        expect(spy.getCall(0).args).toEqual([
          'actual mismatchoa: is NOT an array which differs from'
        ]);
        expect(spy.getCall(1).args).toEqual([
          'expected mismatchoa: is an array'
        ]);
      });

      it('should assert when array compared with object', () => {
        const spy = sinon.spy();
        const exp = (actual) => {
          return { toEqual: (expected) => spy(actual, expected) };
        };

        expectObjectsDeepEqual(
          [account1],
          account2,
          ' mismatchao',
          () => null,
          exp
        );

        expect(spy.callCount).toBe(1);
        expect(spy.getCall(0).args).toEqual([
          { mismatchao: [account1] },
          { mismatchao: account2 }
        ]);
      });
    }); // expectObjectsDeepEqual()
  });
}); // descTestingUtilitiesSuite
