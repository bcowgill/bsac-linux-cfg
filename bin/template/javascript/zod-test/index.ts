   import fs from 'fs';
   import { z, ZodType } from 'zod';
   import { fromZodError, isValidationErrorLike, ValidationError } from 'zod-validation-error';

   // change imports to requires for use in Browser TypeScript Playground
   // https://www.typescriptlang.org/play

   interface SchemaValidationError extends ValidationError
   {
	  source?: {
		 where: string,
		 paramName: string,
		 param: unknown,
	  }
   }

   const print = console.log;
   const err = console.error;

   /*
   interface Result {
	   results: {
		   id: number;
		   name: string;
		   job: string;
	   }[];
   }
   */

   const ResultSchema = z.object( {
	  results: z.array(
		 z.object( {
			id: z.number().int().positive(),
			name: z.string(),
			job: z.string().optional(),
		 } ),
	  )
   } );
   // Same as the Typescript interface Result we have above.
   type Result = z.infer<typeof ResultSchema>;

   // Checks a parameter against a schema and logs an error if it doesn't match.
   // For use with an if statement to carry on only if it matches the schema.
   function checkSchema( info: string, paramName: string, param: unknown, schema: ZodType<any, any, any> ): boolean
   {
	  const check = schema.safeParse( param );
	  if ( !check.success )
	  {
		 const preamble = "SchemaError: " + info + "\n" + paramName + ":" + JSON.stringify( param );
		 const message = fromZodError( check.error );
		 err( preamble );
		 err( message );
	  }
	  return check.success;
   } // checkSchema()

   // Checks a parameter against a schema and throw an error if it doesn't match.
   // Adds .source value to describe to developers where the error came from.
   function throwZod( where: string, paramName: string, param: unknown, schema: ZodType<any, any, any> ): boolean
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
   function throwSchema( info: string, paramName: string, param: unknown, schema: ZodType<any, any, any> ): boolean
   {
	  const check = schema.safeParse( param );
	  if ( !check.success )
	  {
		 const preamble = "SchemaError: " + info + "\n" + paramName + ":" + JSON.stringify( param ) + "\n";
		 const message = fromZodError( check.error );
		 throw new TypeError( preamble + message.toString() );
	  }
	  return check.success;
   } // throwSchema()

   // example function which checks schema of a parameter but doesn't throw on error.
   function printJobs( results: Result ): void
   {
	  if ( checkSchema( "printJobs(results !~~ Result)", "results", results, ResultSchema ) )
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
	  return ( isValidationErrorLike( exception as ValidationError ) || 'source' in ( exception as SchemaValidationError ) || /^TypeError: SchemaError: /.test( `${exception}` ) );
   }

   const r1 = {
	  results: [
		 {
			id: 1,
			name: "John",
			job: "developer",
		 },
	  ]
   };
   print( "\nr1" );
   printJobs( r1 );

   print( "\nparse r1" );
   ResultSchema.parse( r1 );

   const data: Result = JSON.parse( fs.readFileSync( "data.json", "utf-8" ) );
   const dataErr: Result = JSON.parse( fs.readFileSync( "data-error.json", "utf-8" ) );

   print( "\ndata" );
   printJobs( data );

   print( "\ndataErr" );
   printJobs( dataErr );

   function doIt( fnDo: () => void ): void
   {
	  try
	  {
		 fnDo();
	  }
	  catch ( exception )
	  {
		 if ( isSchemaErrorLike( exception ) )
		 {
			const error: SchemaValidationError = exception as SchemaValidationError;
			err( 'ZodError Caught:', `${error}` );
			if ( 'source' in error )
			{
			   err( 'For Developers:', error.source );
			}
		 } else
		 {
			err( 'Non-ZodError:', `${exception}` );
		 }
	  }
   } // doIt()

   print( '\n222' );
   doIt(() =>
   {
	  logJobs( dataErr );
   } );

   print( '\n333' );
   doIt(() =>
   {
	  doJobs( dataErr );
   } );
