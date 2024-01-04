ZodError: [
  {
    "code": "invalid_type",
    "expected": "array",
    "received": "undefined",
    "path": [
      "results"
    ],
    "message": "Required"
  }
]
    at Object.get error [as error] (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/node_modules/zod/lib/types.js:LLL:CCC)
    at ZodObject.parse (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/node_modules/zod/lib/types.js:LLL:CCC)
    at Object.<anonymous> (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/index.ts:LLL:CCC)
    at Module._compile (node:internal/modules/cjs/loader:1099:14)
    at Module.m._compile (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/node_modules/ts-node/src/index.ts:LLL:CCC)
    at Module._extensions..js (node:internal/modules/cjs/loader:1153:10)
    at Object.require.extensions.<computed> [as .ts] (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/node_modules/ts-node/src/index.ts:LLL:CCC)
    at Module.load (node:internal/modules/cjs/loader:975:32)
    at Function.Module._load (node:internal/modules/cjs/loader:822:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:77:12) {
  issues: [
    {
      code: 'invalid_type',
      expected: 'array',
      received: 'undefined',
      path: [Array],
      message: 'Required'
    }
  ],
  addIssue: [Function (anonymous)],
  addIssues: [Function (anonymous)]
}
SchemaError: printJobs(results !~~ Result)
results:{}
ValidationError [ZodValidationError]: Validation error: Required at "results"
    at fromZodError (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/node_modules/zod-validation-error/dist/cjs/ValidationError.js:LLL:CCC)
    at checkSchema (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/index.ts:LLL:CCC)
    at printJobs (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/index.ts:LLL:CCC)
    at Object.<anonymous> (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/index.ts:LLL:CCC)
    at Module._compile (node:internal/modules/cjs/loader:1099:14)
    at Module.m._compile (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/node_modules/ts-node/src/index.ts:LLL:CCC)
    at Module._extensions..js (node:internal/modules/cjs/loader:1153:10)
    at Object.require.extensions.<computed> [as .ts] (/home/me/workspace/play/bsac-linux-cfg/bin/template/javascript/zod-test/node_modules/ts-node/src/index.ts:LLL:CCC)
    at Module.load (node:internal/modules/cjs/loader:975:32)
    at Function.Module._load (node:internal/modules/cjs/loader:822:12) {
  details: [
    {
      code: 'invalid_type',
      expected: 'array',
      received: 'undefined',
      path: [Array],
      message: 'Required'
    }
  ]
}
ZodError Caught: TypeError: SchemaError: logJobs(results !~~ Result)
results:{}
Validation error: Required at "results"
ZodError Caught: Validation error: Required at "results"
For Developers: {
  where: 'doJobs(results !~~ Result)',
  paramName: 'results',
  param: {}
}
