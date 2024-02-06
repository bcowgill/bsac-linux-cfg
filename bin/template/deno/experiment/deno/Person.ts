/**
 * interface for a person with a name.
 */
export default interface Person {
	/**
	 * first name of the person.
	 */
	firstName: string
	/**
	 * last name of the person.
	 */
	lastName: string
}

/**
 * answers with a hello message for a specific person.
 * @param {Person} person the person object you want to say hello to.
 * @returns {string} the hello message with the person's name.
 */
export function sayHello(person: Person): string {
	return `Hello, ${person.firstName}!`
}
