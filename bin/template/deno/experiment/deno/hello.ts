#!/usr/bin/env deno run -A --unsafely-ignore-certificate-errors
// specific host not working...
//#!/usr/bin/env deno run -A --unsafely-ignore-certificate-errors=www.deno.com
//#!/usr/bin/env deno run -A

import Person, { sayHello } from './Person.ts'
import noop from '$lodash/noop'

const ada: Person = {
	firstName: 'Ada',
	lastName: 'Lovelace',
}

console.log(sayHello(ada))

function limitText(text: string, LIMIT?: number): string {
	const lined = text.split(/\n/g).slice(0, LIMIT || 5)
	return lined.join('␤\n   ').concat('␤ …')
}

const site = await fetch('https://www.deno.com')
const content = await site.text()
console.log(limitText(content))
noop()
