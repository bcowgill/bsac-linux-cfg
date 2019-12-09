import { from as fromProd, empty as emptyProd } from '../code-utilities.prod';
import {
  EST,
  EOB,
  EAR,
  its,
  obj,
  from,
  omit,
  nulls,
  empty,
  nameOf,
  fnOrObj,
  visible,
  objThrow
} from '../code-utilities';

const suite = 'app/utility/test/code-utilities.spec.js';

const arrowFunction = () => {};

describe(suite, function descCodeUtilitiesSuite() {
  // falsy inputs
  const ST0 = '';
  const OB0 = {};
  const AR0 = [];

  // truthy inputs
  const ST = 'value';
  const OB = { value: 42 };
  const AR = [42];
  const FN = (into) => {
    return into.value;
  };

  // Example of a function with no positional parameters
  // as a bonus, nothing in 'my' will be null, only undefined
  function clomp(it = EOB) {
    const my = from(clomp, it);
    return `${my.id}: [${my.width},${my.height}]`;
  }
  clomp.defaults = {
    id: '',
    width: 0,
    height: 0,
    und: null // or undefined
  };
  clomp.expectDefaults = {
    id: '',
    width: 0,
    height: 0,
    und: undefined // null replaced by undefined
  };

  // Example, works with React components defaultProps also
  function Component(props) {
    const my = from(Component, props);
    return my.children;
  }
  Component.displayName = 'Component';
  Component.defaultProps = {
    id: '',
    className: Component.displayName,
    children: ''
  };

  describe('EST', function descESTSuite() {
    it('should be an empty string', function testESTEmpty() {
      expect(EST).toEqual('');
    });
  }); // EST

  describe('EOB', function descEOBSuite() {
    it('should be an empty object', function testEOBEmpty() {
      expect(EOB).toEqual({});
    });
  }); // EOB

  describe('EAR', function descEARSuite() {
    it('should be an empty array', function testEAREmpty() {
      expect(EAR).toEqual([]);
    });
  }); // EAR

  describe('visible', function descVisibleSuite() {
    it('should NOT be visible in these cases', function testVisibleNot() {
      expect(visible(undefined)).toBe(EST);
      expect(visible(null)).toBe(EST);
      expect(visible(NaN)).toBe(EST);
      expect(visible(Infinity)).toBe(EST);
      expect(visible(-Infinity)).toBe(EST);
      expect(visible('     ')).toBe(EST);
      expect(visible(false)).toBe(EST);
      expect(visible(true)).toBe(EST);
      expect(visible(EOB)).toBe(EST);
      expect(visible(EAR)).toBe(EST);
      expect(visible(OB)).toBe(EST);
      expect(visible(AR)).toBe(EST);
      expect(visible(FN)).toBe(EST);
    });
    it('should be visible in these cases', function testVisibleYes() {
      expect(visible(0)).toBe('0');
      expect(visible(-1)).toBe('-1');
      expect(visible(1)).toBe('1');
      expect(visible('a')).toBe('a');
    });
  }); // EAR

  describe('nulls()', function descNullsSuite() {
    it('should convert undefined to null', function testNullsNullify() {
      expect(nulls(undefined)).toBe(null);
      expect(nulls(null)).toBe(null);
    });

    it('should not nullify anything else', function testNullsShouldBeValue() {
      // falsy things...
      expect(nulls(false)).toBe(false);
      expect(nulls(0)).toBe(0);
      expect(nulls(ST0)).toBe(ST0);
      expect(nulls(NaN)).toEqual(NaN);
      expect(nulls(Infinity)).toEqual(Infinity);
      expect(nulls(-Infinity)).toEqual(-Infinity);

      // truthy things...
      expect(nulls(true)).toBe(true);
      expect(nulls(-1)).toBe(-1);
      expect(nulls(1)).toBe(1);
      expect(nulls(ST)).toBe(ST);
      expect(nulls(FN)).toBe(FN);
    });

    it('should deeply nullify things', function testNullsDeeply() {
      expect(nulls(OB0)).toEqual(OB0);
      expect(nulls(AR0)).toEqual(AR0);
      expect(nulls(OB)).toEqual(OB);
      expect(nulls(AR)).toEqual(AR);

      expect(nulls({ a: undefined, b: [undefined, 34] })).toEqual({
        a: null,
        b: [null, 34]
      });
      expect(
        nulls([undefined, { a: 34, b: undefined, c: [1, undefined, 3] }])
      ).toEqual([null, { a: 34, b: null, c: [1, null, 3] }]);
    });
  }); // nulls()

  describe('omit()', function descOmitSuite() {
    it('should convert null to undefined', function testOmitNulls() {
      expect(omit(undefined)).toBe(undefined);
      expect(omit(null)).toBe(undefined);
    });

    it('should not omit anything else', function testOmitShouldBeValue() {
      // falsy things...
      expect(omit(false)).toBe(false);
      expect(omit(0)).toBe(0);
      expect(omit(ST0)).toBe(ST0);
      expect(omit(NaN)).toEqual(NaN);
      expect(omit(Infinity)).toEqual(Infinity);
      expect(omit(-Infinity)).toEqual(-Infinity);

      // truthy things...
      expect(omit(true)).toBe(true);
      expect(omit(-1)).toBe(-1);
      expect(omit(1)).toBe(1);
      expect(omit(ST)).toBe(ST);
      expect(omit(FN)).toBe(FN);
    });

    it('should deeply omit things', function testOmitDeeply() {
      expect(omit(OB0)).toEqual(OB0);
      expect(omit(AR0)).toEqual(AR0);
      expect(omit(OB)).toEqual(OB);
      expect(omit(AR)).toEqual(AR);

      expect(omit({ a: undefined, b: [undefined, 34] })).toEqual({
        b: [34]
      });
      expect(
        omit([undefined, { a: 34, b: undefined, c: [1, undefined, 3] }])
      ).toEqual([{ a: 34, c: [1, 3] }]);
    });
  }); // omit()

  describe('its()', function descItsSuite() {
    it('should not return null', function testItsShouldNotBeNull() {
      expect(its(null)).toBe(undefined);
    });

    it('should return its value', function testItsShouldBeValue() {
      // falsy things...
      expect(its(undefined)).toBe(undefined);
      expect(its(false)).toBe(false);
      expect(its(0)).toBe(0);
      expect(its(ST0)).toBe(ST0);
      expect(its(OB0)).toBe(OB0);
      expect(its(AR0)).toBe(AR0);
      expect(its(NaN)).toEqual(NaN);
      expect(its(Infinity)).toEqual(Infinity);
      expect(its(-Infinity)).toEqual(-Infinity);

      // truthy things...
      expect(its(true)).toBe(true);
      expect(its(-1)).toBe(-1);
      expect(its(1)).toBe(1);
      expect(its(ST)).toBe(ST);
      expect(its(OB)).toBe(OB);
      expect(its(AR)).toBe(AR);
      expect(its(FN)).toBe(FN);
    });
  }); // its()

  describe('obj()', function descObjSuite() {
    it('should return THE empty object for these types', function testObjEmpty() {
      // falsy things...
      expect(obj(undefined)).toBe(EOB);
      expect(obj(null)).toBe(EOB);
      expect(obj(false)).toBe(EOB);
      expect(obj(0)).toBe(EOB);
      expect(obj(ST0)).toBe(EOB);
      expect(obj(NaN)).toEqual(EOB);
      expect(obj(Infinity)).toEqual(EOB);
      expect(obj(-Infinity)).toEqual(EOB);

      // truthy things...
      expect(obj(true)).toBe(EOB);
      expect(obj(-1)).toBe(EOB);
      expect(obj(1)).toBe(EOB);
      expect(obj(ST)).toBe(EOB);
      expect(obj(FN)).toBe(EOB);
    });

    it('should return the object itself', function testObjOkay() {
      expect(obj(OB)).toBe(OB);
      expect(obj(AR)).toBe(AR);
    });
  }); // obj()

  describe('objThrow()', function descObjSuite() {
    it('should return THE empty object for these types', function testObjEmpty() {
      // falsy things...
      expect(objThrow(undefined)).toBe(EOB);
      expect(objThrow(null)).toBe(EOB);
    });

    it('should throw an error for these types', function testObjThrow() {
      const error = (into) =>
        new TypeError(
          `you passed a parameter [${into}] by position into a function which expects an Object (it = EOB)`
        );

      // falsy things...
      expect(() => objThrow(false)).toThrow(error(false));
      expect(() => objThrow(0)).toThrow(error(0));
      expect(() => objThrow(ST0)).toThrow(error(''));
      expect(() => objThrow(NaN)).toThrow(error(NaN));
      expect(() => objThrow(Infinity)).toThrow(error(Infinity));
      expect(() => objThrow(-Infinity)).toThrow(error(-Infinity));

      // truthy things...
      expect(() => objThrow(true)).toThrow(error(true));
      expect(() => objThrow(-1)).toThrow(error(-1));
      expect(() => objThrow(1)).toThrow(error(1));
      expect(() => objThrow(ST)).toThrow(error('value'));
      expect(() => objThrow(FN)).toThrow(error(FN));
    });

    it('should return the object itself', function testObjOkay() {
      expect(objThrow(OB)).toBe(OB);
      expect(objThrow(AR)).toBe(AR);
    });
  }); // objThrow()

  describe('fnOrObj()', function descFnOrObjSuite() {
    it('should return THE empty object for these types', function testFnOrObjEmpty() {
      // falsy things...
      expect(fnOrObj(undefined)).toBe(EOB);
      expect(fnOrObj(null)).toBe(EOB);
      expect(fnOrObj(false)).toBe(EOB);
      expect(fnOrObj(0)).toBe(EOB);
      expect(fnOrObj(ST0)).toBe(EOB);
      expect(fnOrObj(NaN)).toEqual(EOB);
      expect(fnOrObj(Infinity)).toEqual(EOB);
      expect(fnOrObj(-Infinity)).toEqual(EOB);

      // truthy things...
      expect(fnOrObj(true)).toBe(EOB);
      expect(fnOrObj(-1)).toBe(EOB);
      expect(fnOrObj(1)).toBe(EOB);
      expect(fnOrObj(ST)).toBe(EOB);
    });

    it('should return the object itself', function testFnOrObjOkay() {
      expect(fnOrObj(OB)).toBe(OB);
      expect(fnOrObj(AR)).toBe(AR);
      expect(fnOrObj(FN)).toBe(FN);
    });
  }); // fnOrObj()

  describe('nameOf', function descNameOfSuite() {
    it('should be the name of the function', function testNameOfFunction() {
      expect(nameOf(testNameOfFunction)).toEqual('[testNameOfFunction]');
      expect(nameOf(arrowFunction)).toEqual('[arrowFunction]');
      expect(nameOf(() => {})).toEqual('[anon]');
      expect(
        // eslint-disable-next-line func-names
        nameOf(function() {
          return 42;
        })
      ).toEqual('[anon]');
    });

    it('should handle anomalies', function testNameOfOther() {
      expect(nameOf()).toEqual('[object]');
      expect(nameOf(null)).toEqual('[object]');
      expect(nameOf(42)).toEqual('[42]');
    });
  }); // nameOf()

  describe('from() - dev', function descFromSuite() {
    it('should default to empty parameters', function testFromEmpty() {
      expect(from()).toEqual(EOB);
      expect(from(null, null)).toEqual(EOB);
    });

    it('should throw an error warning', function testFromThrowError() {
      expect(() => from(1, 13)).toThrow();
    });

    it('should use the function.defaults', function testFromDefaults() {
      expect(from(clomp)).not.toBe(clomp.defaults);
      expect(from(clomp)).not.toBe(clomp.expectDefaults);
      expect(from(clomp)).toEqual(clomp.expectDefaults);
    });

    it('should use the Component.defaultProps', function testFromDefaultProps() {
      expect(from(Component)).not.toBe(Component.defaultProps);
      expect(from(Component)).toEqual(Component.defaultProps);
    });

    it('should use the defaults passed in', function testFromPassedIn() {
      expect(from(clomp.defaults)).not.toBe(clomp.defaults);
      expect(from(clomp.defaults)).toEqual(clomp.expectDefaults);
    });

    it('should override some defaults', function testFromOverrideSome() {
      const into = { id: 'ID' };
      expect(from(clomp.defaults, into)).not.toBe(clomp.defaults);
      expect(from(clomp.defaults, into)).toEqual({
        und: undefined,
        id: 'ID',
        height: 0,
        width: 0
      });
    });

    it('should not override when null or undefined', function testFromNullUndefined() {
      const into = { id: null, width: undefined };
      expect(from(clomp.defaults, into)).not.toBe(clomp.defaults);
      expect(from(clomp.defaults, into)).toEqual(clomp.expectDefaults);
    });

    it('should strip out parameters not listed in defaults', function testFromStripped() {
      const into = { extra: 'neous' };
      expect(from(clomp.defaults, into)).not.toBe(clomp.defaults);
      expect(from(clomp.defaults, into)).toEqual(clomp.expectDefaults);
    });

    it('should allow debug params always', function testFromDebugParams() {
      const into = { extra: 'neous', traceFrom: false, spyFrom: false };
      expect(from(clomp.defaults, into)).toEqual({
        ...clomp.expectDefaults,
        traceFrom: false,
        spyFrom: false
      });
    });
  }); // from() - dev

  describe('from() - production', function descFromProdSuite() {
    it('should default to empty parameters', function testFromProdEmpty() {
      expect(fromProd()).toEqual(EOB);
      expect(fromProd(null, null)).toEqual(EOB);
    });

    it('should throw an error warning', function testFromProdThrowError() {
      expect(() => fromProd(1, 13)).toThrow();
    });

    it('should use the function.defaults', function testFromProdDefaults() {
      expect(fromProd(clomp)).not.toBe(clomp.defaults);
      expect(fromProd(clomp)).not.toBe(clomp.expectDefaults);
      expect(fromProd(clomp)).toEqual(clomp.expectDefaults);
    });

    it('should use the Component.defaultProps', function testFromProdDefaultProps() {
      expect(fromProd(Component)).not.toBe(Component.defaultProps);
      expect(fromProd(Component)).toEqual(Component.defaultProps);
    });

    it('should use the defaults passed in', function testFromProdPassedIn() {
      expect(fromProd(clomp.defaults)).not.toBe(clomp.defaults);
      expect(fromProd(clomp.defaults)).toEqual(clomp.expectDefaults);
    });

    it('should override some defaults', function testFromProdOverrideSome() {
      const into = { id: 'ID' };
      expect(fromProd(clomp.defaults, into)).not.toBe(clomp.defaults);
      expect(fromProd(clomp.defaults, into)).toEqual({
        und: undefined,
        id: 'ID',
        height: 0,
        width: 0
      });
    });

    it('should not override when null or undefined', function testFromProdNullUndefined() {
      const into = { id: null, width: undefined };
      expect(fromProd(clomp.defaults, into)).not.toBe(clomp.defaults);
      expect(fromProd(clomp.defaults, into)).toEqual(clomp.expectDefaults);
    });

    it('should strip out parameters not listed in defaults', function testFromProdStripped() {
      const into = { extra: 'neous' };
      expect(fromProd(clomp.defaults, into)).not.toBe(clomp.defaults);
      expect(fromProd(clomp.defaults, into)).toEqual(clomp.expectDefaults);
    });

    it('should NOT allow debug params always', function testFromProdDebugParams() {
      const into = { extra: 'neous', traceFrom: false, spyFrom: false };
      expect(fromProd(clomp.defaults, into)).toEqual({
        ...clomp.expectDefaults
      });
    });
  }); // from() - production

  describe('empty() - dev', function descEmptySuite() {
    it('should be a new empty object', function testEmptyIsEmpty() {
      expect(empty()).not.toBe(EOB);
      expect(empty()).toEqual(EOB);
      expect(empty(null, null)).toEqual(EOB);

      expect(empty(OB)).not.toBe(OB);
      expect(empty(OB)).not.toEqual(OB);
      expect(empty(OB)).toEqual(EOB);
    });

    it('should be a new empty object with debug settings', function testEmptyHasDebug() {
      const debug = {
        traceFrom: true,
        spyFrom: () => {}
      };
      expect(empty(debug)).not.toBe(EOB);
      expect(empty(debug)).not.toBe(debug);
      expect(empty(debug).traceFrom).toBe(true);
      expect(empty(debug).spyFrom).toBe(debug.spyFrom);
    });

    it('should preserve truthy settings, with leftmost priority', function testEmptyMany() {
      const debug1 = {
        traceFrom: true,
        spyFrom: false
      };
      const debug2 = {
        traceFrom: /^create/,
        spyFrom: () => {}
      };
      expect(empty(debug1, debug2).traceFrom).toBe(true);
      expect(empty(debug1, debug2).spyFrom).toBe(debug2.spyFrom);
      expect(empty(debug2, debug1).traceFrom).toBe(debug2.traceFrom);
    });
  }); // empty() - dev

  describe('empty() - production', function descEmptyProdSuite() {
    it('should be a new empty object', function testEmptyProdIsEmpty() {
      expect(emptyProd()).not.toBe(EOB);
      expect(emptyProd()).toEqual(EOB);
      expect(emptyProd(null, null)).toEqual(EOB);

      expect(emptyProd(OB)).not.toBe(OB);
      expect(emptyProd(OB)).not.toEqual(OB);
      expect(emptyProd(OB)).toEqual(EOB);
    });

    it('should be a new empty object WITHOUT debug settings', function testEmptyProdHasDebug() {
      const debug = {
        traceFrom: true,
        spyFrom: () => {}
      };
      expect(emptyProd(debug)).not.toBe(EOB);
      expect(emptyProd(debug)).not.toBe(debug);
      expect(emptyProd(debug).traceFrom).toBe(undefined);
      expect(emptyProd(debug).spyFrom).toBe(undefined);
      expect(emptyProd(debug)).toEqual(EOB);
    });

    it('should NOT have debug settings', function testEmptyProdMany() {
      const debug1 = {
        traceFrom: true,
        spyFrom: false
      };
      const debug2 = {
        traceFrom: /^create/,
        spyFrom: () => {}
      };
      expect(emptyProd(debug1, debug2).traceFrom).toBe(undefined);
      expect(emptyProd(debug1, debug2).spyFrom).toBe(undefined);
      expect(emptyProd(debug2, debug1).traceFrom).toBe(undefined);
    });
  }); // empty() - production

  describe('clomp()', function descClompSuite() {
    it('should default nicely', function testClompDefaults() {
      expect(clomp()).toBe(': [0,0]');
    });
    it('should override as well', function testClompOverride() {
      expect(clomp({ id: 'ID', height: 42 })).toBe('ID: [0,42]');
    });
  }); // clomp()

  describe('Component()', function descComponentSuite() {
    it('should default nicely', function testComponentDefaults() {
      // eslint-disable-next-line new-cap
      expect(Component()).toBe('');
    });
    it('should override as well', function testComponentOverride() {
      // eslint-disable-next-line new-cap
      expect(Component({ id: 'ID', children: 'CHILDREN' })).toBe('CHILDREN');
    });
  }); // Component()
}); // suite
