import fs from "fs";
import { z, ZodType } from "zod";
import {
  fromZodError,
  isValidationErrorLike,
  ValidationError,
} from "zod-validation-error";

// change imports to requires for use in Browser TypeScript Playground
// https://www.typescriptlang.org/play

const suite = "Zod test (Typescript)";
const DEBUG = false;

interface SchemaValidationError extends ValidationError {
  source?: {
    where: string;
    paramName: string;
    param: unknown;
  };
}

const println = console.log;
const err = console.error;

println(suite);

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
// Same as the Typescript interface Result we have above.
type Result = z.infer<typeof ResultSchema>;

// Dump a JSON object with pretty spacing
function dump(param: unknown, name?: string): string {
  return JSON.stringify(param, void 0, 2) + (name ? ` // END ${name}` : "");
}

// Checks a parameter against a schema and logs an error if it doesn't match.
// For use with an if statement to carry on only if it matches the schema.
// It is like React propTypes where it warns if the data is wrong, but carries on...
function checkSchema(
  info: string,
  paramName: string,
  param: unknown,
  schema: ZodType<any, any, any>,
): boolean {
  const check = schema.safeParse(param);
  if (!check.success) {
    const preamble = `SchemaError: ${info}\n${paramName}: ${dump(
      param,
      paramName,
    )}`;
    const message = fromZodError(check.error);
    err(preamble);
    if (!DEBUG) {
      err(
        `${message.constructor.name}: ${message.stack}\n${dump(
          message,
          message.constructor.name,
        )}`,
      );
      //err(message);
    } else {
      err(`fromZodError=[`);
      err(`   typeof message<${typeof message}>`);
      err(`   message.name<${message.name}>`);
      err(`   message.constructor<${message.constructor}>`);
      err(`   message instanaceof Error<${message instanceof Error}>`);
      err(
        `   message instanaceof ValidationError<${
          message instanceof ValidationError
        }>`,
      );
      err(`   message.message<${message.message}>`);
      err(`   message.details<`, message.details, `>`);
      err(`   message.stack<${message.stack}>`);
      err(`   message.toString()<${message.toString()}>`);
      err(`   message.toLocaleString()<${message.toLocaleString()}>`);
      err(`] // END fromZodError`);
    }
  }
  return check.success;
} // checkSchema()

// Checks a parameter against a schema and throw an error if it doesn't match.
// Adds .source value to describe to developers where the error came from.
// Intended as validating object in an API endpoint and will not perform the task if the data is not valid and provides detail to developers.
function throwZod(
  where: string,
  paramName: string,
  param: unknown,
  schema: ZodType<any, any, any>,
): boolean {
  const check = schema.safeParse(param);
  if (!check.success) {
    const source = {
      where,
      paramName,
      param,
    };
    const error: SchemaValidationError = fromZodError(check.error);
    error.source = source;
    throw error;
  }
  return check.success;
} // throwZod()

// Checks a parameter against a schema and throw an error if it doesn't match.
// Intended as validating object in an API endpoint and will not perform the task if the data is not valid with less error detail.
function throwSchema(
  info: string,
  paramName: string,
  param: unknown,
  schema: ZodType<any, any, any>,
): boolean {
  const check = schema.safeParse(param);
  if (!check.success) {
    const preamble = `SchemaError: ${info}\n${paramName}: ${dump(
      param,
      paramName,
    )}\n`;
    const message = fromZodError(check.error);
    throw new TypeError(preamble + message.toString());
  }
  return check.success;
} // throwSchema()

// example function which checks schema of a parameter but doesn't throw on error.
function printJobs(results: Result): void {
  if (
    checkSchema(
      "printJobs(results !~~ Result)",
      "results",
      results,
      ResultSchema,
    )
  ) {
    results.results.forEach(({ job }) => {
      println(job);
    });
  }
} // printJobs(): void

// example function which checks schema of a parameter and throws an error.
function logJobs(results: Result): void {
  throwSchema("logJobs(results !~~ Result)", "results", results, ResultSchema);
  results.results.forEach(({ job }) => {
    println(job);
  });
} // logJobs(): void

// example function which checks schema of a parameter and throws an official error.
function doJobs(results: Result): void {
  throwZod("doJobs(results !~~ Result)", "results", results, ResultSchema);
  results.results.forEach(({ job }) => {
    println(job);
  });
} // doJobs(): void

function isSchemaErrorLike(exception: unknown): boolean {
  // err('@@@', exception);
  return (
    isValidationErrorLike(exception as ValidationError) ||
    "source" in (exception as SchemaValidationError) ||
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
println("\nprintJobs(r1)");
printJobs(r1);

println("\nparse r1");
ResultSchema.parse(r1);

const data: Result = JSON.parse(fs.readFileSync("data.json", "utf-8"));
const dataErr: Result = JSON.parse(fs.readFileSync("data-error.json", "utf-8"));

println("\nparse data.json");
ResultSchema.parse(data);

println("\nparse data-error.json");
try {
  ResultSchema.parse(dataErr);
} catch (exception) {
  err(exception);
}

println("\nprintJobs(from data.json)");
printJobs(data);

println("\nprintJobs(from data-error.json)");
printJobs(dataErr);

function doIt(fnDo: () => void): void {
  try {
    fnDo();
  } catch (exception) {
    if (isSchemaErrorLike(exception)) {
      const error: SchemaValidationError = exception as SchemaValidationError;
      err("ZodError Caught:", `${error}`);
      if ("source" in error) {
        err("Source For Developers:", error.source);
      }
      if ("details" in error) {
        err("Details For Developers:", error.details);
      }
    } else {
      err("Non-ZodError:", `${exception}`);
    }
    if (exception && typeof exception === "object" && "stack" in exception) {
      err("Stack For Developers:", exception.stack);
    }
  }
} // doIt()

println("\nlogJobs(from data-error.json) or throw");
doIt(() => {
  logJobs(dataErr);
});

println("\ndoJobs(from data-error.json) or throw official");
doIt(() => {
  doJobs(dataErr);
});
