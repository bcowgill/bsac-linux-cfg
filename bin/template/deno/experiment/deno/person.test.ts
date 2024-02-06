#!/usr/bin/env deno test
// before deno.jsonc file created: import { assertEquals } from "https://deno.land/std@0.211.0/assert/mod.ts";
import { assertEquals } from '$std/assert/mod.ts'
import Person, { sayHello } from './Person.ts'

Deno.test('sayHello function', () => {
	const grace: Person = {
		lastName: 'Hopper',
		firstName: 'Grace',
	}

	assertEquals('Hello, Grace!', sayHello(grace))
})
