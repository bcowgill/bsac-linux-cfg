import fs from "fs";
import Ajv, { JSONSchemaType, ErrorObject, ValidateFunction } from "ajv";
import { JTDDataType } from "ajv/dist/jtd";
import wrapAjvErrors from "ajv-errors";

// change imports to requires for use in Browser TypeScript Playground
// https://www.typescriptlang.org/play

const suite = "AJV test (Typescript) TODO";
const DEBUG = false;

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

// Grabbed from Zod module
class ValidationError extends Error {
  details;
  name;
  constructor(message: string, details?: ErrorObject[]) {
    super(message);
    this.details = details || [];
    this.name = "AJVValidationError";
  }
  toString() {
    return this.message;
  }
}

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

interface ResultItem {
  id: number; // integer/ positive
  name: string;
  job?: string; // nullable
}

interface Result {
  results: ResultItem[];
}

// See pros/cons of the two formats supported:
// https://ajv.js.org/guide/schema-language.html

const ResultItemSchema: JSONSchemaType<ResultItem> = {
  //errorMessage: "should be a ResultItemSchema object with an id and name.",
  type: "object",
  required: ["id", "name"],
  additionalProperties: false,
  properties: {
    id: {
      type: "integer", // https://ajv.js.org/json-schema.html#json-data-type
      minimum: 0,
    },
    name: {
      type: "string",
    },
    job: { type: "string", nullable: true },
  },
};
const ResultSchema: JSONSchemaType<Result> = {
  //errorMessage: "should be a ResultSchema object with a results array.",
  type: "object",
  required: ["results"],
  additionalProperties: false,
  properties: {
    results: {
      type: "array",
      items: ResultItemSchema,
    },
  },
};

// const ResultItemSchema2: JTDSchemaType<ResultItem> = {};
// const ResultSchema2: JTDSchemaType<Result> = {};

const validate: { [key: string]: ValidateFunction } = {
  ResultItemSchema: ajv.compile<ResultItem>(ResultItemSchema),
  ResultSchema: ajv.compile<Result>(ResultSchema),
  //  ResultItemSchema2: ajv.compile(ResultItemSchema2),
  //  ResultSchema2: ajv.compile(ResultSchema2),
};

/*
																											  function parse(item: unknown, schemaName: string) {
																											  const valid = validate[schemaName](item);
																											  if (!valid) {
																											  throw new TypeError(validate[schemaName].errors);
																											  }
																											  return valid;
																											  }
																											*/

// Dump a JSON object with pretty spacing
function dump(param: unknown, name?: string): string {
  return JSON.stringify(param, void 0, 2) + (name ? ` // END ${name}` : "");
}

function fromAJVError(errorsIn?: ErrorObject[] | null): ValidationError {
  const errors = errorsIn || [];
  //console.error("fromAjvError: ", errors);
  const errorText = ajv.errorsText(errors);
  //console.error(`errorsText: [${errorText}]`);
  return new ValidationError(errorText, errors);
}

// Checks a parameter against a schema and logs an error if it doesn't match.
// For use with an if statement to carry on only if it matches the schema.
// It is like React propTypes where it warns if the data is wrong, but carries on...
function checkSchema(
  info: string,
  paramName: string,
  param: unknown,
  fnValidate: ValidateFunction,
): boolean {
  const check = fnValidate(param);
  //console.log("check", check, fnValidate);
  if (!check) {
    const preamble = `SchemaError: ${info}\n${paramName}: ${dump(
      param,
      paramName,
    )}`;
    const message = fromAJVError(fnValidate.errors || []);
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
      err(`fromAJVError=[`);
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
      err(`] // END fromAJVError`);
    }
  }
  return check;
} // checkSchema()

// Checks a parameter against a schema and throw an error if it doesn't match.
// Adds .source value to describe to developers where the error came from.
// Intended as validating object in an API endpoint and will not perform the task if the data is not valid and provides detail to developers.
function throwAJV(
  where: string,
  paramName: string,
  param: unknown,
  fnValidate: ValidateFunction,
): boolean {
  const check = fnValidate(param);
  if (!check) {
    const source = {
      where,
      paramName,
      param,
    };
    const error: SchemaValidationError = fromAJVError(fnValidate.errors);
    error.source = source;
    throw error;
  }
  return check;
} // throwAJV()

// Checks a parameter against a schema and throw an error if it doesn't match.
// Intended as validating object in an API endpoint and will not perform the task if the data is not valid with less error detail.
function throwSchema(
  info: string,
  paramName: string,
  param: unknown,
  fnValidate: ValidateFunction,
): boolean {
  const check = fnValidate(param);
  if (!check) {
    const preamble = `SchemaError: ${info}\n${paramName}: ${dump(
      param,
      paramName,
    )}`;
    const message = fromAJVError(fnValidate.errors || []);
    throw new TypeError(preamble + message.toString());
  }
  return check;
} // throwSchema()

// example function which checks schema of a parameter but doesn't throw on error.
function printJobs(results: Result): void {
  if (
    checkSchema(
      "printJobs(results !~~ Result)",
      "results",
      results,
      validate.ResultSchema,
    )
  ) {
    results.results.forEach(({ job }) => {
      println(job);
    });
  }
} // printJobs(): void

// example function which checks schema of a parameter and throws an error.
function logJobs(results: Result): void {
  throwSchema(
    "logJobs(results !~~ Result)",
    "results",
    results,
    validate.ResultSchema,
  );
  results.results.forEach(({ job }) => {
    println(job);
  });
} // logJobs(): void

/*

																											  // example function which checks schema of a parameter and throws an official error.
																											  function doJobs( results: Result ): void
																											  {
																											  throwZod( "doJobs(results !~~ Result)", "results", results, ResultSchema );
																											  results.results.forEach(( { job } ) =>
																											  {
																											  println( job );
																											  } );
																											  } // doJobs(): void

																											  function isSchemaErrorLike( exception: unknown ): boolean
																											  {
																											  // err('@@@', exception);
																											  return (
																											  isValidationErrorLike( exception as ValidationError ) ||
																											  "source" in ( exception as SchemaValidationError ) ||
																											  /^TypeError: SchemaError: /.test( `${exception}` )
																											  );
																											  }
									*/

const r1 = {
  results: [
    {
      id: 1,
      name: "John",
      job: "developer",
    },
  ],
};
const rErr = {
  results: [
    {
      id: "1",
      name: ["John"],
      job: "developer",
    },
  ],
};

println(
  checkSchema("fnCall(param !~~ Result)", "r1", r1, validate.ResultSchema),
);

println(
  checkSchema("fnCall(param !~~ Result)", "rErr", rErr, validate.ResultSchema),
);

println("\nprintJobs(r1)");
printJobs(r1);

println("\nparse r1.results[0]");
//parse(r1.results[0], "ResultItemSchema");
let valid = validate.ResultItemSchema(r1.results[0]);
println(valid);
if (!valid) {
  err(validate.ResultItemSchema.errors);
}

println("\nparse r1");
//parse(r1, "ResultSchema");
valid = validate.ResultSchema(r1);
println(valid);
if (!valid) {
  err(validate.ResultSchema.errors);
}

//const data: Result = JSON.parse(fs.readFileSync("data.json", "utf-8"));
//const dataErr: Result = JSON.parse(fs.readFileSync("data-error.json", "utf-8"));

/*
   println( "\nparse data.json" );
   ResultSchema.parse( data );

   println( "\nparse data-error.json" );
   try
   {
	  ResultSchema.parse( dataErr );
   } catch ( exception )
   {
	  err( exception );
   }

   println( "\nprintJobs(from data.json)" );
   printJobs( data );

   println( "\nprintJobs(from data-error.json)" );
   printJobs( dataErr );

   function doIt( fnDo: () => void ): void
   {
	  try
	  {
		 fnDo();
	  } catch ( exception )
	  {
		 if ( isSchemaErrorLike( exception ) )
		 {
			const error: SchemaValidationError = exception as SchemaValidationError;
			err( "AJVError Caught:", `${error}` );
			if ( "source" in error )
			{
			   err( "Source For Developers:", error.source );
			}
      if ("details" in error) {
        err("Details For Developers:", error.details);
      }
		 } else
		 {
			err( "Non-AJVError:", `${exception}` );
		 }
    if (exception && typeof exception === "object" && "stack" in exception) {
      err("Stack For Developers:", exception.stack);
    }
	  }
   } // doIt()

   println( "\nlogJobs(from data-error.json) or throw" );
   doIt(() =>
   {
	  logJobs( dataErr );
   } );

   println( "\ndoJobs(from data-error.json) or throw official" );
   doIt(() =>
   {
	  doJobs( dataErr );
   } );
*/
