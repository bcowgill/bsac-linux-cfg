#!/usr/bin/env node

const moment = require('moment');
const date = require('date-fns');
const dateFns = require('date-fns/fp');

const now = new Date();
const days = 3*7+25;

console.log(`Add ${days} days to current date`)
console.log('moment: ', moment(now).add(days, 'days'));
console.log('date-fns.addDays curried: ', dateFns.addDays(days)(now));
console.log('date-fns.addDays called: ', dateFns.addDays(days, now));
console.log('date-fns.add: ', date.add(now, { days }));

console.log('TZ=', process.env.TZ);
console.log('current time zone offset: ', now.getTimezoneOffset())
console.log('time zone offset in 6 months: ', date.add(now, { months: 6 }).getTimezoneOffset());

function daysToTzOffsetChange(from) {
	const tzNow = from.getTimezoneOffset();
	let changeDate;
	let days = 0;
	let tzNew = tzNow;

	while (days <= 365 && tzNew === tzNow) {
		++days;
		changeDate = date.add(from, { days })
		tzNew = changeDate.getTimezoneOffset();
	}

	return tzNew === tzNow ? undefined : { from, days, date: changeDate, offset: tzNew };
}

const year = now.getYear() + 1900;
const tz1 = daysToTzOffsetChange(new Date(year, 0, 1));
console.log('First time offset change of year: ', tz1);

if (tz1) {
	const tz2 = daysToTzOffsetChange(tz1.date);
	console.log('Second time offset change: ', tz2);

	if (tz2) {
		const tz3 = daysToTzOffsetChange(tz2.date);
		console.log('Third time offset chagne: ', tz3);
	}
}
