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
	const command = process.argv[1].replace(/^.+\//, '');
	if (message) {
		console.log(message);
	}
	console.log(`
${command} [--help|--man|-?] [start-date] number ...

This will add a certain number of days to today's date or the specific date specified.
Each additional number provided is added to the original date.

start-date  The starting date/time.
number      The number of days to add to the start date.
--man       Shows help for this tool.
--help      Shows help for this tool.
-?          Shows help for this tool.

The date can be given in any format that Javascript understands. For example, the date -R command gives a format that is compatible.

See also dateDaysBetween.js time-to-finish.sh predict-when.sh date
Example

	Add a tenth of a day to the current time.

${command} 0.1

	Show the date one week before the new year.

${command} 2024-01-01 -7
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
	if (/^--?(help|man|\?)/.test(arg)) {
		usage();
	}
	if (/^-[^0-9]/.test(arg)) {
		usage(`unknown option ${arg}, please study the command usage below.`);
	}
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
