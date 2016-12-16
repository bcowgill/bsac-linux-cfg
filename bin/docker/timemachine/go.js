#!/usr/bin/env node

const tm = require('./timemachine')
	assert = require('assert')

let tests = 0
	, passed = 0
	, failed = 0

function test(title, config, fnTest) {
	let thisPassed;

	if (!fnTest) {
		fnTest = config;
		config = {};
	}
	++tests;
	tm.config(config);
	try {
		fnTest();
		thisPassed = true;
		console.log(`OK - ${title}`);
	}
	catch (failure) {
		thisPassed = false;
		console.error(title, failure)
	}
	finally {
		passed += thisPassed ? 1 : 0;
		failed += thisPassed ? 0 : 1;
		tm.reset();
		tm.config({});
	}
}

console.log("check Date constructor")
test("should default to Thu, 01 Jan 1970 00:00:00 GMT", () => {
	const now = new Date();
	assert.equal(now.toUTCString(), "Thu, 01 Jan 1970 00:00:00 GMT");
})

test("should now be set to December 25, 1991 12:12:59 via GMT dateString", {
		dateString: 'December 25, 1991 12:12:59 GMT'
	}, () => {
		const now = new Date();
		assert.equal(now.toUTCString(), "Wed, 25 Dec 1991 12:12:59 GMT");
})

test("should now be set to December 25, 1991 12:12:59 via timestamp", {
		timestamp: 693663179000
	}, () => {
		const now = new Date();
		assert.equal(now.toUTCString(), "Wed, 25 Dec 1991 12:12:59 GMT");
})

test("should stay the same for instantiation with millisecond param", () => {
	const now = new Date(1);
	assert.equal(now.toUTCString(), "Thu, 01 Jan 1970 00:00:00 GMT");
})

test("should now be set to December 25, 1991 12:12:59 via localtime dateString", {
		dateString: 'December 25, 1991 12:12:59'
	}, () => {
		const now = new Date();
		assert.equal(now.toString(), "Wed, 25 Dec 1991 12:12:59 GMT");
})

test("should check time zone offset", () =>{
	const now = new Date()
		, offset = now.getTimezoneOffset()
		assert.equal(offset, 0);
})






console.log(`${tests} tests, ${passed} passed, ${failed} failed`)
