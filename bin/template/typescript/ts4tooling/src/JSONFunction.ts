// JSONFunction.ts helps to JSON.stringify a Function object.
export interface functionish {
	(...unknown): unknown
	name: string
	length: number
}
export type JSONFunctionish = [string, string?, number?]

export const displayName = 'object:JSONFunction'

/**
 * Convert a Function object to an Array which can be serialised with JSON.stringify.
 * @param fnFunc Function to convert to a string named array for serialisation with JSON.stringify.
 * @returns An array whose first element is 'object:JSONFunction' to indicate that it is a Function object.  The following elements are the name and length(# of parameters) of the function.
 */
export function JSONFunction(fnFunc: functionish) {
	return [displayName, fnFunc.name, fnFunc.length]
}
