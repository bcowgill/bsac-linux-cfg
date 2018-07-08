import lodebug from './lodebug';

const dateInvalid = new Date('2000-19-99');
let caughtError;
try {
  /^(\d+/;
}
catch (exception) {
  caughtError = exception;
}

const testData = [
  [
    void 0, [
      "undefined: isUndefined",
      "undefined: isNil isEmpty",
      "undefined: _isKey _isStrictComparable err(_isLaziable)",
    ],
  ],
  [
    null, [
      "null: isNull",
      "null: isNil isEmpty",
      "null: _isKey _isKeyable _isStrictComparable err(_isLaziable)"
    ],
  ],
  [
    false, [
      "false: isBoolean",
      "false: isEmpty",
      "false: _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    true, [
      "true: isBoolean",
      "true: isEmpty",
      "true: _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    NaN, [
      "NaN: isNumber",
      "NaN: isEmpty isNaN",
      "NaN: _isKey _isKeyable",
    ],
  ],
  [
    Infinity, [
      "Infinity: isNumber",
      "Infinity: isEmpty",
      "Infinity: _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    -Infinity, [
      "-Infinity: isNumber",
      "-Infinity: isEmpty",
      "-Infinity: _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    0, [
      "0: isNumber",
      "0: isEmpty isInteger isSafeInteger isLength isFinite",
      "0: _isIndex _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    -1, [
      "-1: isNumber",
      "-1: isEmpty isInteger isSafeInteger isFinite",
      "-1: _isKey _isKeyable _isStrictComparable",
   ],
  ],
  [
    1, [
      "1: isNumber",
      "1: isEmpty isInteger isSafeInteger isLength isFinite",
      "1: _isIndex _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    -1.2, [
      "-1.2: isNumber",
      "-1.2: isEmpty isFinite",
      "-1.2: _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    '', [
      "\"\": isString",
      "\"\": isEmpty",
      "\"\": isArrayLike",
      "\"\": _isKey _isKeyable _isStrictComparable",
    ],
    '""',
  ],
  [
    '   ', [
      "\"   \": isString",
      "\"   \": isArrayLike",
      "\"   \": _isKey _isKeyable _isStrictComparable",
    ],
    '"   "',
  ],
  [
    '0', [
      "\"0\": isString",
      "\"0\": isArrayLike",
      "\"0\": _isIndex _isKey _isKeyable _isStrictComparable",
    ],
    '"0"',
  ],
  [
    Symbol.iterator, [
      "Symbol.iterator: isSymbol",
      "Symbol.iterator: isEmpty",
      "Symbol.iterator: _isKey _isKeyable _isStrictComparable",
    ],
    'Symbol.iterator'
  ],
  [
    {}, [
      "{}: isObject",
      "{}: isPlainObject isObjectLike",
      "{}: isEmpty",
    ],
    "{}",
  ],
  [
    [], [
      "[]: isObject",
      "[]: isObjectLike",
      "[]: isEmpty",
      "[]: isArray isArrayLike isArrayLikeObject",
      "[]: _isFlattenable",
    ],
    "[]",
  ],
  [
    () => void 0, [
      "() => void 0: isObject",
      "() => void 0: isFunction",
      "() => void 0: isEmpty",
      "() => void 0: _isKey",    ],
  ],
  [
    caughtError, [
      "caught error: isObject",
      "caught error: isObjectLike",
      "caught error: isError",
      "caught error: isEmpty",
      "caught error: _isKey",
    ],
    'caught error',
  ],
  [
    dateInvalid, [
      "new Date(invalid): isObject",
      "new Date(invalid): isObjectLike",
      "new Date(invalid): isDate",
      "new Date(invalid): isEmpty",
      "new Date(invalid): _isKey",
    ],
    'new Date(invalid)',
  ],
  [
    dateInvalid.getMonth(), [
      "new Date(invalid).getMonth(): isNumber",
      "new Date(invalid).getMonth(): isEmpty isNaN",
      "new Date(invalid).getMonth(): _isKey _isKeyable",
    ],
    'new Date(invalid).getMonth()',
  ],
  [
    '2000-01-02', [
      "2000-01-02: isString",
      "2000-01-02: isPossibleDate",
      "2000-01-02: isArrayLike",
      "2000-01-02: _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    '2000-22-45', [
      "2000-22-45: isString",
      "2000-22-45: isArrayLike",
      "2000-22-45: _isKey _isKeyable _isStrictComparable",
    ],
  ],
  [
    /^/, [
      "/^/: isObject",
      "/^/: isObjectLike",
      "/^/: isRegExp",
      "/^/: isEmpty",
      "/^/: _isKey",
    ],
  ],
  [
    document.body, [
      "document.body: isObject",
      "document.body: isObjectLike",
      "document.body: isElement",
      "document.body: isEmpty",
    ],
    'document.body',
  ],
  [
    eval, [
      "eval: isObject",
      "eval: isFunction",
      "eval: isEmpty isNative",
    ],
    'eval',
  ],
  [
    (function () { return arguments; })(1,2,3), [
      "[object Arguments]: isObject",
      "[object Arguments]: isObjectLike",
      "[object Arguments]: isArguments isArrayLike isArrayLikeObject",
      "[object Arguments]: _isFlattenable",
    ],
  ],
 [
    new Boolean(), [
      "new Boolean(): isBoolean isObject",
      "new Boolean(): isObjectLike",
      "new Boolean(): isEmpty",
      "new Boolean(): _isKey",
    ],
    'new Boolean()',
  ],
  [
    new Number(), [
      "new Number(): isNumber isObject",
      "new Number(): isObjectLike",
      "new Number(): isEmpty",
      "new Number(): _isIndex _isKey",
    ],
    'new Number()',
  ],
  [
    new String(), [
      "new String(): isString isObject",
      "new String(): isObjectLike",
      "new String(): isEmpty",
      "new String(): isArrayLike isArrayLikeObject",
      "new String(): _isKey",
    ],
    'new String()',
  ],
  [
    new Date(), [
      "new Date(): isObject",
      "new Date(): isObjectLike",
      "new Date(): isDate isValidDate",
      "new Date(): isEmpty",
      "new Date(): _isKey",
    ],
    'new Date()',
  ],
  [
    new Array(), [
      "new Array(): isObject",
      "new Array(): isObjectLike",
      "new Array(): isEmpty",
      "new Array(): isArray isArrayLike isArrayLikeObject",
      "new Array(): _isFlattenable",
    ],
    'new Array()',
  ],
  [
    new Object(), [
      "new Object(): isObject",
      "new Object(): isPlainObject isObjectLike",
      "new Object(): isEmpty",
    ],
    'new Object()',
  ],
  [
    new Function(), [
      "new Function(): isObject",
      "new Function(): isFunction",
      "new Function(): isEmpty",
      "new Function(): _isKey",
    ],
    'new Function()',
  ],
  [
    new RegExp(), [
      "new RegExp(): isObject",
      "new RegExp(): isObjectLike",
      "new RegExp(): isRegExp",
      "new RegExp(): isEmpty",
      "new RegExp(): _isKey",
    ],
    'new RegExp()',
  ],
  [
    new Error(), [
      "new Error(): isObject",
      "new Error(): isObjectLike",
      "new Error(): isError",
      "new Error(): isEmpty",
      "new Error(): _isKey",    ],
    'new Error()',
  ],
  [
    new Uint8Array(), [
      "new Uint8Array(): isObject",
      "new Uint8Array(): isObjectLike",
      "new Uint8Array(): isEmpty",
      "new Uint8Array(): isArrayLike isArrayLikeObject isTypedArray",
      "new Uint8Array(): _isKey",
    ],
    'new Uint8Array()',
  ],
  [
    new ArrayBuffer(2), [
      "new ArrayBuffer(2): isObject",
      "new ArrayBuffer(2): isObjectLike",
      "new ArrayBuffer(2): isEmpty",
      "new ArrayBuffer(2): isArrayBuffer",
    ],
    'new ArrayBuffer(2)',
  ],
  [
    new Buffer(2), [
      "new Buffer(2): isObject",
      "new Buffer(2): isObjectLike",
      "new Buffer(2): isArrayLike isArrayLikeObject isTypedArray isBuffer",
      "new Buffer(2): _isKey",
    ],
    'new Buffer(2)',
  ],
  [
    new Map(), [
      "new Map(): isObject",
      "new Map(): isObjectLike",
      "new Map(): isEmpty",
      "new Map(): isMap",
    ],
    'new Map()',
  ],
  [
    new WeakMap(), [
      "new WeakMap(): isObject",
      "new WeakMap(): isObjectLike",
      "new WeakMap(): isEmpty",
      "new WeakMap(): isWeakMap",
    ],
    'new WeakMap()',
  ],
  [
    new Set(), [
      "new Set(): isObject",
      "new Set(): isObjectLike",
      "new Set(): isEmpty",
      "new Set(): isSet",
    ],
    'new Set()',
  ],
  [
    new WeakSet(), [
      "new WeakSet(): isObject",
      "new WeakSet(): isObjectLike",
      "new WeakSet(): isEmpty",
      "new WeakSet(): isWeakSet",
    ],
    'new WeakSet()',
  ],
/*  [
    new (), [
    ],
    'new ()',
  ],
*/
];

describe('lodebug', function descLodebugSuite () {
  it('should debug a number', function testLodebug() {
    const output = [];
    function gather (line) {
      output.push(line);
    }
    lodebug('fortyTwo', 42, gather);
    expect(output).toEqual([
      "fortyTwo: isNumber",
      "fortyTwo: isEmpty isInteger isSafeInteger isLength isFinite",
      "fortyTwo: _isIndex _isKey _isKeyable _isStrictComparable",
    ]);
  });

  it('should debug a Map', function testLodebugMap() {
    const output = [];
    function gather (line) {
      output.push(line);
    }
    lodebug('map', new Map(), gather);
    expect(output).toEqual([
      "map: isObject",
      "map: isObjectLike",
      "map: isEmpty",
      "map: isMap",
    ]);
  });

  testData.map(([value, expected, named = `${value}`]) => {
    it(`should debug a value: ${named}`, function testLodebugValue() {
      const output = [];
      function gather (line) {
        output.push(line);
      }
      lodebug(named, value, gather);
      expect(output).toEqual(expected);
    });
  });
});
