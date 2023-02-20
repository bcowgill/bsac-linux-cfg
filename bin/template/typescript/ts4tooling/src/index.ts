/* eslint-env node */
/* eslint-disable @typescript-eslint/no-unused-vars, no-console */

import { B } from './common' // for npm run compile until typescript 5 arrives
//import { B } from './common.ts' // for npm run fast / compile with typescript@beta == 5

console.log(B)

// For massive sample of typescript see ../fast-compile/src/index.ts and not.ts

/*
  Typescript Handbook Rules of Thumb for adding type information:
    - Prefer to use interface to type until you need to use type specific features.

  Everyday Types https://www.typescriptlang.org/docs/handbook/2/everyday-types.html
    - The type names String, Number, and Boolean (starting with capital letters) are legal, but refer to some special built-in types that will very rarely appear in your code. Always use string, number, or boolean for types.
    - TypeScript doesn’t use “types on the left”-style declarations like int x = 0; Type annotations will always go after the thing being typed.
    - Even if you don’t have type annotations on your parameters, TypeScript will still check that you passed the right number of arguments.
    - Reminder: Because type assertions are removed at compile-time, there is no runtime checking associated with a type assertion. There won’t be an exception or null generated if the type assertion is wrong.

  Functions https://www.typescriptlang.org/docs/handbook/2/functions.html
    - Rule: When possible, use the <Type> parameter itself rather than constraining it.
    - Rule: Always use as few <Type> parameters as possible.
    - Rule: If a <Type> parameter only appears in one location, strongly reconsider if you actually need it.
    - When writing a function type for a callback, never write an optional parameter unless you intend to call the function without passing that argument.
    - Always have two or more signatures above the implementation of the function when writing an overloaded function.  The signature of the implementation is not visible from the outside.
    - Always prefer parameters with union types instead of overloads when possible.
    - void is not the same as undefined.
    - object is not Object. Always use object! (functions are objects, so is array.)
    - unknown is similar to the any type, but is safer because it’s not legal to do anything with an unknown value.
    - never type represents values which are never observed.
    - Function is an untyped function call and is generally best avoided because of the unsafe any return type. Prefer () => void.
  Objects https://www.typescriptlang.org/docs/handbook/2/objects.html
    - Annotating types as readonly tuples when possible is a good default.
  Classes https://www.typescriptlang.org/docs/handbook/2/classes.html
    - Note that a field-backed get/set pair with no extra logic is very rarely useful in JavaScript. It’s fine to expose public fields if you don’t need to add additional logic during the get/set operations.
  Utility Types https://www.typescriptlang.org/docs/handbook/utility-types.html
    - utilities for async/Promise: Await<Type>
    - utilities for properties of types: Partial<Type>, Required<Type>, Readonly<Type>, Record<Keys, Type>, Pick<Type, Keys>, Omit<Type, Keys>
    - utilities for type unions: Exclude<Un1, Un2>, Extract<Un1, Un2>, NonNullable<Un>
    - utilities for functions: Parameters<Fn>, ConstructorParameters<CFn>, ReturnType<Fn>, InstanceType<CFn>, ThisParameterType<Fn>, OmitThisParameterType<Fn>, ThisType<Type>
    - utilities for strings: Uppercase<Str>, Lowercase<Str>, Capitalize<Str>, Uncapitalize<Str>
  - like Awaited, Promise, Capitalize, etc
  Enums https://www.typescriptlang.org/docs/handbook/enums.html
    - prefer modern typescript's object as const to enums

HEREIAM
https://www.typescriptlang.org/docs/handbook/module-resolution.html
*/