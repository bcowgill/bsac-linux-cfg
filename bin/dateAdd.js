#!/usr/bin/env node
// BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

Date.prototype.addDays = function(days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
}

const FIRST_ARG = 2;

let date = new Date();
let output = false;

function usage(message) {
	const command = process.argv[1];
	if (message) {
		console.log(message);
	}
	console.log(`
${command} [date] number ...

This will add a certain number of days to today's date or the specific date specified.
Each additional number provided is added to the original date.
`);
	process.exit(message ? 1 : 0);
}

function showAddedDate(date, days) {
	console.log(date);
	console.log(`plus ${days} days`);
	console.log(date.addDays(days));
	console.log('');
	output = true;
}

if (process.argv.length < FIRST_ARG) {
	usage('Please provide a date string or the number of days to add.');
}

for (let idx = FIRST_ARG; idx < process.argv.length; idx++) {
	const arg = process.argv[idx];
	if (/^\s*[+-]?\d+\.?\d*$/.test(arg)) {
		showAddedDate(date, parseFloat(arg, 10));
	}
	else {
		date = new Date(arg);
	}
}

if (!output) {
	usage('Please provide a number of days to add.');
}
