#!/usr/bin/env node
// npm install timemachine

// Cater to running the tests in different time zone and daylight saving time
const timeZone = process.env.TZ;
const timeZoneData = {
	'Europe/London': {
		0: {
			offset: 0,
			gmtFromLocal: "Wed, 25 Dec 1991 12:12:59 GMT",
		},
	},
	'America/Vancouver': {
		480: {
			offset: 480,
			gmtFromLocal: "Wed, 25 Dec 1991 20:12:59 GMT",
		},
	},
};

function TZ (date, id) {
	const offset = date.getTimezoneOffset();
    const zone = timeZoneData[timeZone];
	if (zone) {
        const savings = zone[offset];
		if (savings && typeof savings[id] !== "undefined") {
			return savings[id];
		}
	}
	return "timeZoneData[" + timeZone + "][" + offset + "]." + id + " is not configured with test data.";
}
// end Cater to running the tests in different time zone and daylight saving time

const gmtTimestamp = 693663179000;

const now = new Date();

console.log("TZ=", timeZone);
console.log("Date getTimezoneOffset ", now.getTimezoneOffset())
console.log("Date valueOf           ", now.valueOf())
console.log("Date toString          ", now.toString())
console.log("Date ISO String        ", now.toISOString())
console.log("Date JSON              ", now.toJSON())
console.log("Date UTC String        ", now.toUTCString())
console.log("Date GMT String        ", now.toGMTString())
console.log("Date String            ", now.toDateString())
console.log("Date Time String       ", now.toTimeString())
console.log("Date Locale Date String", now.toLocaleDateString())
console.log("Date Locale String     ", now.toLocaleString())

const tm = require('timemachine')
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
		console.log(`OK ${tests} - ${title}`);
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
test("should only run with known time zones", () => {
	// if this test fails you need to update timeZoneData above
	const hasTZ = !!timeZoneData[timeZone];
	assert.equal(hasTZ, true);
})

test("should default to Thu, 01 Jan 1970 00:00:00 GMT", () => {
	const now = new Date();
	assert.equal(now.toUTCString(), "Thu, 01 Jan 1970 00:00:00 GMT");
})

test("should now be set to December 25, 1991 12:12:59 via GMT dateString", {
		dateString: 'December 25, 1991 12:12:59 GMT'
	}, () => {
		const now = new Date();
		assert.equal(now.toUTCString(), "Wed, 25 Dec 1991 12:12:59 GMT");
		assert.equal(now.valueOf(), gmtTimestamp);
})

test("should now be set to December 25, 1991 12:12:59 via timestamp", {
		timestamp: gmtTimestamp
	}, () => {
		const now = new Date();
		assert.equal(now.toUTCString(), "Wed, 25 Dec 1991 12:12:59 GMT");
		assert.equal(now.valueOf(), gmtTimestamp);
})

test("should stay the same for instantiation with millisecond param", () => {
	const now = new Date(1);
	assert.equal(now.toUTCString(), "Thu, 01 Jan 1970 00:00:00 GMT");
})

// will vary by timezone and daylight saving time so we use TZ() function
// to adjust the value we check against
test("should now be set to December 25, 1991 12:12:59 via localtime dateString", {
		dateString: 'December 25, 1991 12:12:59'
	}, () => {
		const now = new Date()
		assert.equal(now.toUTCString(), TZ(now, "gmtFromLocal"));
})

test("should now be set to December 25, 1991 12:12:59 via localtime dateString to GMT conversion", {
		dateString: 'December 25, 1991 12:12:59'
	}, () => {
		const now = new Date()
			, offset = now.getTimezoneOffset() * 60 * 1000
			, timestamp = now.valueOf() - offset
			, when = new Date(timestamp)
		assert.equal(when.toUTCString(), "Wed, 25 Dec 1991 12:12:59 GMT");
		assert.equal(when.valueOf(), gmtTimestamp);
})

test("should now be set to December 25, 1991 12:12:59 via localtime dateString to Date String", {
		dateString: 'December 25, 1991 12:12:59'
	}, () => {
		const now = new Date()
		assert.equal(now.toDateString(), "Wed Dec 25 1991");
})

test("should check time zone offset -- will fail based on TZ!=Europe/London", () =>{
	const now = new Date()
		, offset = now.getTimezoneOffset()
		assert.equal(offset, TZ(now, "offset"));
})

console.log(`${tests} tests, ${passed} passed, ${failed} failed`)
