// typeOf.ts A better typeof where null != object and object constructor name is part of returned string.
let counter = 0
const AnonymousConstructors: WeakMap<object, string> = new WeakMap<
	object,
	string
>()
/**
 * Get an object's anonymous constructor name as 'AnonNnn' for anonymously constructed objects.
 * @param source an object whose anonymous constructor name needs to be determined
 * @returns string name of the anonymous constructor like 'AnonNNN'
 */
function getAnonName(source: object): string {
	const konstructor = source.constructor
	if (!AnonymousConstructors.has(konstructor)) {
		AnonymousConstructors.set(konstructor, `Anon${counter++}`)
	}
	// code above ensures there will be something to get...
	// eslint-disable-next-line @typescript-eslint/non-nullable-type-assertion-style
	return AnonymousConstructors.get(konstructor) as string
}

/**
 * Gets the type of some thing similar to the typeof operator.  In this case null is not of type 'object' because you cannot invoke any methods of Object on 'null' so null IS NOT an Object.
 * @param source anything whose type information needs to be known
 * @returns a string indicating whay type of thing the source is.  Objects with named constructor functions return as 'object:ConstructorName'
 */
export default function typeOf(source: unknown): string {
	let type: string = typeof source
	if (source === null) {
		type = 'null'
	} else if (typeof source === 'object') {
		const konstructor = source.constructor
		const name = String(konstructor.name || getAnonName(source))
		type += name !== 'Object' ? ':' + name : ''
		if (/^(Number|Boolean|String)$/.test(name)) {
			// new Number(), etc -> number, boolean, string
			type = name.toLowerCase()
		}
	}
	return type
}
