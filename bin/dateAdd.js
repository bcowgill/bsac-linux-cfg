#!/usr/bin/env node
// BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

const zeros = "00000000000000000000";
function pad(string = "", length  = 2) {
	if (length > zeros.length) {
		// double the zero length and try again, or throw...
		throw new RangeError("parameter ‘length’ [" + length + "] exceeds maximum supported padding of " + zeros.length)
	}
	return zeros.substr(0, length - string.toString().length) + string;
}

Date.prototype.addDays = function(days) {
    var date = new Date(this.valueOf());
    date.setDate(date.getDate() + days);
    return date;
}

Date.prototype.stringify = function() {
	return this.getFullYear() + '-' + pad(this.getMonth()+1) + '-' + pad(this.getDate()) + ' ' + this.toLocaleTimeString();
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
	console.log(date.stringify());
	console.log(`plus ${days} days`);
	console.log(date.addDays(days).stringify());
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
