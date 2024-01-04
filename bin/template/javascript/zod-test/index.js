#!/usr/bin/env node
//import fs from "fs";
//import { z } from "zod";
//import { fromZodError, isValidationErrorLike } from "zod-validation-error";
const fs = require("fs");
const { z } = require("zod");
const { fromZodError, isValidationErrorLike } = require("zod-validation-error");

const suite = "Zod test (NodeJS transpiled Typescript)";

const print = console.log;
const err = console.error;

print(suite);

/*
   interface Result {
      results: {
         id: number;
         name: string;
         job: string;
      }[];
   }
*/
const ResultSchema = z.object({
  results: z.array(
    z.object({
      id: z.number().int().positive(),
      name: z.string(),
      job: z.string().optional(),
    }),
  ),
});
// Checks a parameter against a schema and logs an error if it doesn't match.
// For use with an if statement to carry on only if it matches the schema.
function checkSchema(info, paramName, param, schema) {
  const check = schema.safeParse(param);
  if (!check.success) {
    const preamble =
      "SchemaError: " + info + "\n" + paramName + ":" + JSON.stringify(param);
    const message = fromZodError(check.error);
    err(preamble);
    err(message);
  }
  return check.success;
} // checkSchema()
// Checks a parameter against a schema and throw an error if it doesn't match.
// Adds .source value to describe to developers where the error came from.
function throwZod(where, paramName, param, schema) {
  const check = schema.safeParse(param);
  if (!check.success) {
    const source = {
      where,
      paramName,
      param,
    };
    const error = fromZodError(check.error);
    error.source = source;
    throw error;
  }
  return check.success;
} // throwZod()
// Checks a parameter against a schema and throw an error if it doesn't match.
function throwSchema(info, paramName, param, schema) {
  const check = schema.safeParse(param);
  if (!check.success) {
    const preamble =
      "SchemaError: " +
      info +
      "\n" +
      paramName +
      ":" +
      JSON.stringify(param) +
      "\n";
    const message = fromZodError(check.error);
    throw new TypeError(preamble + message.toString());
  }
  return check.success;
} // throwSchema()
// example function which checks schema of a parameter but doesn't throw on error.
function printJobs(results) {
  if (
    checkSchema(
      "printJobs(results !~~ Result)",
      "results",
      results,
      ResultSchema,
    )
  ) {
    results.results.forEach(({ job }) => {
      print(job);
    });
  }
} // printJobs(): void
// example function which checks schema of a parameter and throws an error.
function logJobs(results) {
  throwSchema("logJobs(results !~~ Result)", "results", results, ResultSchema);
  results.results.forEach(({ job }) => {
    print(job);
  });
} // logJobs(): void
// example function which checks schema of a parameter and throws an official error.
function doJobs(results) {
  throwZod("doJobs(results !~~ Result)", "results", results, ResultSchema);
  results.results.forEach(({ job }) => {
    print(job);
  });
} // doJobs(): void
function isSchemaErrorLike(exception) {
  // err('@@@', exception);
  return (
    isValidationErrorLike(exception) ||
    "source" in exception ||
    /^TypeError: SchemaError: /.test(`${exception}`)
  );
}
const r1 = {
  results: [
    {
      id: 1,
      name: "John",
      job: "developer",
    },
  ],
};
print("\nprintJobs(r1)");
printJobs(r1);
print("\nparse r1");
ResultSchema.parse(r1);
const data = JSON.parse(fs.readFileSync("data.json", "utf-8"));
const dataErr = JSON.parse(fs.readFileSync("data-error.json", "utf-8"));
print("\nparse data.json");
ResultSchema.parse(data);
print("\nparse data-error.json");
try {
  ResultSchema.parse(dataErr);
} catch (exception) {
  err(exception);
}
print("\nprintJobs(from data.json)");
printJobs(data);
print("\nprintJobs(from data-error.json)");
printJobs(dataErr);
function doIt(fnDo) {
  try {
    fnDo();
  } catch (exception) {
    if (isSchemaErrorLike(exception)) {
      const error = exception;
      err("ZodError Caught:", `${error}`);
      if ("source" in error) {
        err("For Developers:", error.source);
      }
    } else {
      err("Non-ZodError:", `${exception}`);
    }
  }
} // doIt()
print("\nlogJobs(from data-error.json) or throw");
doIt(() => {
  logJobs(dataErr);
});
print("\ndoJobs(from data-error.json) or throw official");
doIt(() => {
  doJobs(dataErr);
});
