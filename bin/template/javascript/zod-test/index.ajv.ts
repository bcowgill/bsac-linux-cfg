import fs from "fs";
import Ajv from "ajv";
import wrapAjvErrors from "ajv-errors";

// change imports to requires for use in Browser TypeScript Playground
// https://www.typescriptlang.org/play

const suite = "AJV test (Typescript) TODO";

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

const print = console.log;
const err = console.error;

print(suite);

/*
																											   interface Result {
																												  results: {
																													 id: number; integer/positive
																													 name: string;
																													 job?: string;
																												  }[];
																											   }
																											   */

// See pros/cons of the two formats supported:
// https://ajv.js.org/guide/schema-language.html

const ResultItemSchema = {
  //errorMessage: "should be a ResultItemSchema object with an id and name.",
  type: "object",
  required: ["id", "name"],
  additionalProperties: false,
  properties: {
    id: {
      type: "integer", // https://ajv.js.org/json-schema.html#json-data-type
      minimum: 10,
    },
    name: {
      type: "string",
    },
    job: { type: "string" },
  },
};
const ResultSchema = {
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
// Same as the Typescript interface Result we have above.
// type Result = z.infer<typeof ResultSchema>;

const validate = {
  ResultItemSchema: ajv.compile(ResultItemSchema),
  ResultSchema: ajv.compile(ResultSchema),
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

// Checks a parameter against a schema and logs an error if it doesn't match.
// For use with an if statement to carry on only if it matches the schema.
/*
																											function checkSchema(
																											   info: string,
																											   paramName: string,
																											   param: unknown,
																											   schema: ZodType<any, any, any>,
																											): boolean
																											{
																											   const check = schema.safeParse( param );
																											   if ( !check.success )
																											   {
																												  const preamble =
																													 "SchemaError: " + info + "\n" + paramName + ":" + JSON.stringify( param );
																												  const message = fromZodError( check.error );
																												  err( preamble );
																												  err( message );
																											   }
																											   return check.success;
																											} // checkSchema()

																											// Checks a parameter against a schema and throw an error if it doesn't match.
																											// Adds .source value to describe to developers where the error came from.
																											function throwZod(
																											   where: string,
																											   paramName: string,
																											   param: unknown,
																											   schema: ZodType<any, any, any>,
																											): boolean
																											{
																											   const check = schema.safeParse( param );
																											   if ( !check.success )
																											   {
																												  const source = {
																													 where,
																													 paramName,
																													 param,
																												  };
																												  const error: SchemaValidationError = fromZodError( check.error );
																												  error.source = source;
																												  throw error;
																											   }
																											   return check.success;
																											} // throwZod()

																											// Checks a parameter against a schema and throw an error if it doesn't match.
																											function throwSchema(
																											   info: string,
																											   paramName: string,
																											   param: unknown,
																											   schema: ZodType<any, any, any>,
																											): boolean
																											{
																											   const check = schema.safeParse( param );
																											   if ( !check.success )
																											   {
																												  const preamble =
																													 "SchemaError: " +
																													 info +
																													 "\n" +
																													 paramName +
																													 ":" +
																													 JSON.stringify( param ) +
																													 "\n";
																												  const message = fromZodError( check.error );
																												  throw new TypeError( preamble + message.toString() );
																											   }
																											   return check.success;
																											} // throwSchema()

																											// example function which checks schema of a parameter but doesn't throw on error.
																											function printJobs( results: Result ): void
																											{
																											   if (
																												  checkSchema(
																													 "printJobs(results !~~ Result)",
																													 "results",
																													 results,
																													 ResultSchema,
																												  )
																											   )
																											   {
																												  results.results.forEach(( { job } ) =>
																												  {
																													 print( job );
																												  } );
																											   }
																											} // printJobs(): void

																											// example function which checks schema of a parameter and throws an error.
																											function logJobs( results: Result ): void
																											{
																											   throwSchema( "logJobs(results !~~ Result)", "results", results, ResultSchema );
																											   results.results.forEach(( { job } ) =>
																											   {
																												  print( job );
																											   } );
																											} // logJobs(): void

																											// example function which checks schema of a parameter and throws an official error.
																											function doJobs( results: Result ): void
																											{
																											   throwZod( "doJobs(results !~~ Result)", "results", results, ResultSchema );
																											   results.results.forEach(( { job } ) =>
																											   {
																												  print( job );
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
//   print( "\nprintJobs(r1)" );
//   printJobs( r1 );

print("\nparse r1.results[0]");
//parse(r1.results[0], "ResultItemSchema");
let valid = validate.ResultItemSchema(r1.results[0]);
print(valid);
if (!valid) {
  err(validate.ResultItemSchema.errors);
}

print("\nparse r1");
//parse(r1, "ResultSchema");
valid = validate.ResultSchema(r1);
print(valid);
if (!valid) {
  err(validate.ResultSchema.errors);
}

//const data: Result = JSON.parse(fs.readFileSync("data.json", "utf-8"));
//const dataErr: Result = JSON.parse(fs.readFileSync("data-error.json", "utf-8"));

/*
   print( "\nparse data.json" );
   ResultSchema.parse( data );

   print( "\nparse data-error.json" );
   try
   {
	  ResultSchema.parse( dataErr );
   } catch ( exception )
   {
	  err( exception );
   }

   print( "\nprintJobs(from data.json)" );
   printJobs( data );

   print( "\nprintJobs(from data-error.json)" );
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
			err( "ZodError Caught:", `${error}` );
			if ( "source" in error )
			{
			   err( "For Developers:", error.source );
			}
		 } else
		 {
			err( "Non-ZodError:", `${exception}` );
		 }
	  }
   } // doIt()

   print( "\nlogJobs(from data-error.json) or throw" );
   doIt(() =>
   {
	  logJobs( dataErr );
   } );

   print( "\ndoJobs(from data-error.json) or throw official" );
   doIt(() =>
   {
	  doJobs( dataErr );
   } );
*/