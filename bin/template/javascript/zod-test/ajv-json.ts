import fs from "fs";
import Ajv, { JSONSchemaType } from "ajv";
import wrapAjvErrors from "ajv-errors";

// change imports to requires for use in Browser TypeScript Playground
// https://www.typescriptlang.org/play
//const fs = require("fs");
//const Ajv = require("ajv").default;
//const wrapAjvErrors = require("ajv-errors");
//import type { JSONSchemaType } from 'ajv' ;

const suite = "AJV test (Typescript) JSONSchemaType";

const ajv = new Ajv({
  // https://ajv.js.org/options.html
  // options can be passed, e.g. {allErrors: true}
  //strict: "log",
  allErrors: true,
  verbose: true,
  $comment: true,
});
// https://ajv.js.org/packages/ajv-errors.html
wrapAjvErrors(ajv /*, {singleError: true} */);

/*
											   interface SchemaValidationError extends ValidationError
											   {
											   source?: {
											   where: string;

											   paramName: string;
											   param: unknown;
											   };
											   }
											 */

const println = console.log;
const err = console.error;

println(suite);

interface ResultItem {
  id: number; // integer/ positive
  job?: string;
}

const schema: JSONSchemaType<ResultItem> = {
  type: "object",
  properties: {
    id: { type: "integer" },
    job: { type: "string", nullable: true },
  },
  required: ["id"],
  additionalProperties: false,
};

// validate is a type guard for ResultItem - type is inferred from schema type
const validate = ajv.compile(schema);

// or, if you did not use type annotation for the schema,
// type parameter can be used to make it type guard:
// const validate = ajv.compile<ResultItem>(schema)

const data = {
  id: 1.4, // use 1.4 for error branch
  job: "abc",
};

if (validate(data)) {
  // data is ResultItem here
  console.log(data.id);
} else {
  console.log(validate.errors);
}
