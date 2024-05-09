#!/usr/bin/env node
// BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

const SEC_PER_MILLISEC = 1000;
const SEC_PER_MINUTE = 60;
const MIN_PER_HOUR = 60;
const HOUR_PER_DAY = 24;
const SEC_PER_DAY = SEC_PER_MILLISEC * SEC_PER_MINUTE * MIN_PER_HOUR * HOUR_PER_DAY;

Date.prototype.milliSecondsBetween = function(current) {
    const elapsed = current.valueOf() - this.valueOf();
    return elapsed;
}

const FIRST_ARG = 2;

let start;
let date = new Date();
let units = 'd';
let output = false;

function usage(message) {
	const command = process.argv[1].replace(/^.+\//, '');
	if (message) {
		console.log(message);
	}
	console.log(`
${command} [--help|--man|-?] [units] start-date [end-date]

This will determine the number of days (or the specified units) between the given start-date and today's date or the end-date specified.

start-date  The starting date/time.
end-date    optional. The ending date/time. defaults to right now.
units       optional. The units to display the elapsed time in: [days?|hours?|minutes?|seconds?] units can appear first or last in the options list.
--man       Shows help for this tool.
--help      Shows help for this tool.
-?          Shows help for this tool.

The dates can be given in any format that Javascript understands. For example, the date -R command gives a format that is compatible.

See also dateAdd.js time-to-finish.sh predict-when.sh date

Example

	Work out the number of hours since Jan 1 2024.

${command} hours 2024-01-01
`);
	process.exit(message ? 1 : 0);
}

const Convert = {
	d: SEC_PER_DAY,
	h: SEC_PER_MINUTE * MIN_PER_HOUR * SEC_PER_MILLISEC,
	m: SEC_PER_MINUTE * SEC_PER_MILLISEC,
	s: SEC_PER_MILLISEC,
};

function showDaysBetween(startDate, endDate, units) {
	const milliSeconds = startDate.milliSecondsBetween(endDate);
	const conversion = Convert[units];
	const duration = milliSeconds / conversion;
	console.log(`${duration} ${units}`);
	console.log('');
	output = true;
}

if (process.argv.length < FIRST_ARG) {
	usage('Please provide date strings for the start date/time and optional end date/time and optional units: day, hour, minute, second.');
}

for (let idx = FIRST_ARG; idx < process.argv.length; idx++) {
	const arg = process.argv[idx];
	if (/^--?(help|man|\?)/.test(arg)) {
		usage();
	}
	if (/^-/.test(arg)) {
		usage(`unknown option ${arg}, please study the command usage below.`);
	}
	if (/^[dhms][a-z]+$/i.test(arg)) {
		units = arg.toLowerCase()[0];
	}
	else if (start) {
		date = new Date(arg);
	} else {
		start = new Date(arg);
	}
}

if (!start) {
	usage('Please provide a date string for the start date/time.');
}

showDaysBetween(start, date, units);
