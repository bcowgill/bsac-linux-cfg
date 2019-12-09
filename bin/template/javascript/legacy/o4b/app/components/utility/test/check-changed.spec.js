/* eslint-disable prefer-arrow-callback */

import { isObj, toConsole, checkChanges } from '../check-changed';
import {
  expectUndefined,
  expectFalsy,
  expectFalse,
  expectTrue,
  expectNull
  // expectNaN // MUSTDO develop branch
} from '../../../utility/testing-utilities';

const suite = 'app/components/utility/test/check-changed.spec.js';

describe(suite, function descCheckChangedSuite() {
  const ARRAY = [];
  const OBJECT = {};
  const REGEX = /^.$/;
  const FUNCTION = () => 0;

  describe('isObj', function descCheckChangedIsObjSuite() {
    it('should handle non-objects', function testIsObjNot() {
      expectFalsy('isObj1', isObj());
      expectFalsy('isObj2', isObj(null));
      expectFalsy('isObj3', isObj(false));
      expectFalsy('isObj4', isObj(0));
      expectFalsy('isObj5', isObj(Infinity));
      expectFalsy('isObj6', isObj(NaN));
      expectFalsy('isObj7', isObj(''));
      expectFalsy('isObj8', isObj(ARRAY));
      expectFalsy('isObj9', isObj(REGEX));
      expectFalsy('isObj10', isObj(Number(0)));
      expectFalsy('isObj11', isObj(FUNCTION));
    });

    it('should handle objects', function testIsObjTrue() {
      expectTrue('isObj12', isObj(OBJECT));
    });
  });

  describe('toConsole', function descCheckChangedToConsoleSuite() {
    it('should handle RegExp by stringifying it', function testToConsoleRegExp() {
      expect(toConsole(REGEX)).toBe('/^.$/');
    });

    it('should handle everything else as is', function testToConsoleOthers() {
      expectUndefined('toConsole1', toConsole());
      expectNull('toConsole2', toConsole(null));
      expectFalse('toConsole3', toConsole(false));
      expect(isNaN(toConsole(NaN))).toBe(true);
      // MUSTDO develop branch expectNaN('toConsole4', toConsole(NaN));
      expect(toConsole(0)).toBe(0);
      expect(toConsole(Infinity)).toBe(Infinity);
      expect(toConsole('')).toBe('');
      expect(toConsole(Number(0))).toBe(0);
      expect(toConsole(OBJECT)).toBe(OBJECT);
      expect(toConsole(ARRAY)).toBe(ARRAY);
      expect(toConsole(FUNCTION)).toBe(FUNCTION);
    });
  });

  describe('checkChanges', function descCheckChangedCheckChangesSuite() {
    const names = ['value'];
    function props(value) {
      return {
        value
      };
    }

    it('should handle when no change', function testCheckChangesNone() {
      expectFalsy('checkChanges1', checkChanges(props(), props(), names));
      expectFalsy(
        'checkChanges2',
        checkChanges(props(null), props(null), names)
      );
      expectFalsy(
        'checkChanges3',
        checkChanges(props(false), props(false), names)
      );
      expectFalsy('checkChanges4', checkChanges(props(0), props(0), names));
      expectFalsy(
        'checkChanges5',
        checkChanges(props(Infinity), props(Infinity), names)
      );
      expectFalsy('checkChanges6', checkChanges(props(''), props(''), names));
      expectFalsy(
        'checkChanges7',
        checkChanges(props(ARRAY), props(ARRAY), names)
      );
      expectFalsy(
        'checkChanges8',
        checkChanges(props(REGEX), props(REGEX), names)
      );
      expectFalsy(
        'checkChanges9',
        checkChanges(props(FUNCTION), props(FUNCTION), names)
      );
    });

    it('should handle simple changed property', function testCheckChangesSimple() {
      expectTrue('checkChanges10', checkChanges(props(), props(0), names));
      expectTrue(
        'checkChanges11',
        checkChanges(props(null), props(undefined), names)
      );
      expectTrue(
        'checkChanges12',
        checkChanges(props(false), props(true), names)
      );
      expectTrue('checkChanges13', checkChanges(props(0), props(-1), names));
      expectTrue(
        'checkChanges14',
        checkChanges(props(Infinity), props(-Infinity), names)
      );
      expectTrue('checkChanges15', checkChanges(props(NaN), props(NaN), names));
      expectTrue(
        'checkChanges16',
        checkChanges(props(''), props('what'), names)
      );
      expectTrue(
        'checkChanges17',
        checkChanges(props(FUNCTION), props(isObj), names)
      );
    });

    it('should handle changed but identical property', function testCheckChangesIdentical() {
      expectTrue(
        'checkChanges20',
        checkChanges(props(ARRAY), props([]), names)
      );
      expectTrue(
        'checkChanges21',
        checkChanges(props(OBJECT), props({}), names)
      );
      expectTrue(
        'checkChanges22',
        checkChanges(props(REGEX), props(/^.$/), names)
      );
    });

    it('should handle changed arrays and objects', function testCheckChangesComplex() {
      expectTrue(
        'checkChanges30',
        checkChanges(props(ARRAY), props(['12']), names)
      );
      expectTrue(
        'checkChanges31',
        checkChanges(
          props([
            '12',
            '13',
            '14',
            '15',
            '16',
            '17',
            '18',
            '19',
            '20',
            '21',
            '22'
          ]),
          props([12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]),
          names
        )
      );
      expectTrue(
        'checkChanges32',
        checkChanges(props(['12', '13']), props(['12', '13']), names)
      );
    });

    it('should handle changed objects', function testCheckChangesObjects() {
      expectTrue(
        'checkChanges40',
        checkChanges(props(OBJECT), props({ list: ['12'] }), names)
      );
      expectTrue(
        'checkChanges41',
        checkChanges(
          props({
            a: '12',
            b: '13',
            c: '14',
            d: '15',
            e: '16',
            f: '17',
            g: '18',
            h: '19',
            i: '20',
            j: '21',
            k: '22'
          }),
          props({
            a: 12,
            b: 13,
            c: 14,
            d: 15,
            e: 16,
            f: 17,
            g: 18,
            h: 19,
            i: 20,
            j: 21,
            k: 22
          }),
          names
        )
      );
      expectTrue(
        'checkChanges42',
        checkChanges(
          props({ a: '12', b: '13' }),
          props({ a: '12', b: '13' }),
          names
        )
      );
    });
  });
}); // descCheckChangedSuite
