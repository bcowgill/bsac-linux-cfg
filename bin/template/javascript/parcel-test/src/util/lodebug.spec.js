import lodebug from './lodebug';

let error;
try {
  error.something.else;
}
catch (exception) {
  error = exception;
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
    {}, [
      "{}: isObject",
      "{}: isPlainObject isObjectLike",
      "{}: isEmpty",
      "{}: ",
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
    error, [
      "caught error: isObject",
      "caught error: isObjectLike",
      "caught error: isError",
      "caught error: isEmpty",
      "caught error: _isKey",
    ],
    'caught error',
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
    new Date(), [
      "new Date(): isObject",
      "new Date(): isObjectLike",
      "new Date(): isDate",
      "new Date(): isEmpty",
      "new Date(): _isKey",
    ],
    'new Date()',
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
/*  [
    new Symbol(), [
    ],
    'new Symbol()',
  ],
*/
/*  [
    new Boolean(), [
    ],
    'new Boolean()',
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
