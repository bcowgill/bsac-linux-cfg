#!/usr/bin/env node

// nvm use v17.9.1 assign-to-team.js tests/assign-to-team/in/team.txt
// TODO: extract the framework out into a jsscript-lite.js template like perl-lite.js

const util = require('util');
const path = require('path');

function usage(msg) {
	const cmd = findBin().script;

	if (msg) {
		say(`${msg}\n\n`)
	}
	say(`
usage: ${cmd} [--help|--man|-?] filename...

This will divide up story or task id's or lists among cross-functional teams created on an ad hoc basis.

filename    files to process instead of standard input.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

The files processed should define the roles and people available and the list of stories or tasks to divide up.

The format is quite simple.  A hash mark '#' comments out a line so it will be ignored.  For example if a given person is currently away.

A line that ends with a colon ':' defines a role type or begins a list of tasks to divide up.

Task lines are specified as task: tasks: story: or stories:

A line with end: stop: quit: or go: indicates that there is no more. The tasks will be divided up at this point.

Other lines will be added to the current context, either a role list or a task list.

Example:

Use existing team.txt file to divide up the tasks listed in tasks.txt

${cmd} team.txt tasks.txt

`);
	process.exit(msg
		? 1
		: 0);
} // usage()

const VERSION = 0.1;
const DEBUG = process.env.DEBUG || 0;

const IN = '   ';
const NLIN = `\n${IN}`;
const NLININ = `${NLIN}${IN}`;
const reArg = /^-/;
const reArgHelp = /--help|--man|-\?/;
const reEndLine = /(\x0d\x0a|\x0a|\x0d)$/;
const reEnd = /^\s*(end|stop|quit|go)\s*:\s*$/i;
const reTaskList = /^\s*(tasks?|stor(y|ies))\s*:\s*$/i;
const reRoleList = /^\s*([^:]+)\s*:\s*$/i;
const reMember = /^\s*(.+)\s*$/i;
const reBlank = /^\s*(\#|$)/;
const reTrimSpace = /\s\s+/;
const reStripRandom = /^\d+:/;

const Tasks = {};
const Roles = {};
const Teams = [];
let context;
let group;
let jobs = 0;

const ARGV = process
	.argv
	.slice(2);
const ARGF = ARGV.filter((arg) => !reArg.test(arg));
const ARGO = ARGV.filter((arg) => reArg.test(arg));

if (ARGV.length && reArgHelp.test(ARGV[0])) {
	usage();
}

function check_args() {
	if (ARGO.length) {
		usage("unrecognised command line options: " + ARGO.join(", "))
	}
}

function main() {
	check_args();
	try
	{
		say("specify 'end:' to end the input.\n");
		processData(() => processStreams(report, fatal), fatal);
	} catch (EVAL_ERROR) {
		fatal(EVAL_ERROR);
	}
} // main()

function fatal(error) {
	warn(error);
	process.exit(1);
}

function parse(line) {
	debug("parse:" + line);
	if (!reBlank.test(line)) {
		chomp(line);
		debug(line, 2);
		let params;
		if (params = reMatchParams(line, reTaskList)) {
			context = 'task';
			group   = ucfirst(params[1]);
			++jobs;
			debug(`begin ${context}/${group}` // reTaskList
			)
		} else if (params = reMatchParams(line, reEnd)) {
			report( // reEnd
			);
		} else if (params = reMatchParams(line, reRoleList)) {
			context = 'role';
			group   = ucfirst(params[1]);
			debug(`begin ${context}/${group}` // reRoleList
			)
		} else if (params = reMatchParams(line, reMember)) {
			let member = ucfirst(params[1]);
			member = member.replace(new RegExp(reTrimSpace, 'g'), ' ');
			member = `${Math.floor(rand(10))}:${member}`;
			if (context === 'task') {
				pushKeyedItem(Tasks, group, member);
			} else {
				pushKeyedItem(Roles, group, member);
			}
			debug(`..add ${member} to ${context}/${group}` // reMember
			);
		} else {
			debug(`...${line}`);
		}
	} // reBlank
} // parse()

function report() {
	make_teams();
	assign_tasks();
	print_report();
	process.exit(0);
}

function make_teams() {
	const RoleNames = Object.keys(Roles);
	if (!jobs) {
		failure("You must specify one or more task: type lines to define what needs to be done by" +
				" the team.");
	}
	if (RoleNames.length < 1) {
		failure("You must specify one or more role: type lines to define the role types on the te" +
				"am.");
	}
	debug(`Roles: ${Dumper(RoleNames)}`, 3);
	let team = 1;
	let found;
	do {
		found = false;
		const Team = [];
		for (const role_type of RoleNames) {
			const [got,
				pick,
				named] = pick_one(role_type, Roles[role_type]);
			found += got;
			if (got) {
				Roles[role_type].splice(pick, 1);
				debug(`${role_type}: ${Dumper(Roles[role_type])}`, 3);
				Team.push(named);
			}
		}
		if (Team.length) {
			debug(`SORTING Team ${Dumper(Team)}`, 4);
			const Sorted = order_items(Team.sort());
			debug(`SORTING Sorted ${Dumper(Sorted)}`, 4);
			if (found === RoleNames.length) {
				Teams.push({
					assigned: {},
					members : Sorted,
					number  : team++
				});
			} else {
				const to_team = (team++ - 1) % Teams.length;
				Teams[to_team]
					.members
					.push(...Sorted);
			}
		}
	} while (found);
	debug(`Teams: ${Dumper(Teams)}`, 3);
} // make_teams()

function order_items(List) {
	return List.map((item) => {
		return item.replace(reStripRandom, '');
	});
}

function pick_one(type, List) {
	const items = List.length;
	debug(`pick $type ${Dumper(List)}`, 4);
	let got = 0;
	let pick = '';
	let named = '';
	if (items) {
		pick  = Math.floor(rand(items));
		named = `${List[pick]} (${type})`;
		got   = 1;
	}
	debug(`picked ${got}, ${pick}, ${named}`, 4);
	return [got, pick, named];
} // pick_one()

function assign_tasks() {
	debug(`Tasks: ${Dumper(Tasks)}`, 3);
	const teams = Teams.length;
	Jobs = Object.keys(Tasks);
	let number = 0;
	for (const type of Jobs) {
		const Items = Tasks[type];
		for (const todo of Items) {
			const pick = number++ % teams;
			pushKeyedItem(Teams[pick].assigned, type, todo);
		}
	}
	debug(`Assigned: ${Dumper(Teams)}`, 4);
} // assign_tasks()

function print_report() {
	for (const team of Teams) {
		say(`\nTeam${team.number}:\n`);
		const Jobs = Object.keys(team.assigned);
		say(`${IN}${team.members.join(NLIN)}\n`);
		for (const type of Jobs) {
			say(`${NLIN}${type}:\n`);
			const Items = order_items(team.assigned[type]);
			say(`${IN}${IN}${Items.join(NLININ)}\n`);
		}
	}
} // print_report()

// More Perlish features from perl-lite script, emulate perl __DATA__ parsing,
// and <> reading from command line arguments.

const fs = require('node:fs');
// TODO change from readline to other line by line reading?
const readline = require('node:readline');

function processData(fnNext, fnError) {
	const reDataMarker = /^__(DATA|END)__;?\s*$/;
	const reIgnore = /^(['"`;?]|\s*\*\/)/;
	const source = fs.createReadStream(findBin().full, {encoding: 'utf8'});
	let foundData = false;

	processByLine(source, (line) => {
		debug(`processData.line [${line}]`, 4);
		if (foundData && !reIgnore.test(line)) {
			parse(line);
		} else if (reDataMarker.test(line)) {
			foundData = true;
		}
	}, fnNext, fnError);
} // processData()

function processByLine(source, fnLine, fnNext, fnError = fnNext) {
	// https://nodejs.org/api/readline.html#event-close
	const rl = readline.createInterface({crlfDelay: Infinity, input: source});

	let finished = false;
	function done(fnNext, ...args) {
		if (!finished) {
			finished = true;
			fnNext(...args)
		}
	}
	rl.on('SIGINT', () => {
		debug("processByLine1", 2);
		done(fnNext)
	});
	rl.on('error', (...what) => {
		debug("processByLine2", 2);
		done(fnError, ...what)
	});
	rl.on('close', () => {
		debug("processByLine3", 2);
		done(fnNext)
	});

	rl.on('line', fnLine);
} // processByLine()

function processStreams(fnNext, fnError) {
	// create streams for files on command line if none, create stream for standard
	// input then process the streams with parse and call next when out, call fatal
	// if error.
	const Streams = [];
	debug("processStreams1: " + ARGV.length, 2);
	for (const arg of ARGV) {
		debug("processStreams: " + arg, 2);
		const source = fs.createReadStream(arg, {encoding: 'utf8'});
		Streams.push(source);
	}
	if (!Streams.length) {
		Streams.push(process.stdin);
	}

	const {PassThrough} = require('stream');

	const concatStreams = (streamArray, streamCounter = streamArray.length) => streamArray.reduce((mergedStream, stream) => {
		// pipe each stream of the array into the merged stream prevent the automated
		// 'end' event from firing
		mergedStream = stream.pipe(mergedStream, {end: false});
		// rewrite the 'end' event handler Every time one of the stream ends, the
		// counter is decremented. Once the counter reaches 0, the mergedstream can emit
		// its 'end' event.
		stream.once('end', () => --streamCounter === 0 && mergedStream.emit('end'));
		return mergedStream;
	}, new PassThrough());

	const source = concatStreams(Streams);
	processByLine(source, parse, fnNext, fnError);
} // processStreams()

// make tabs 3 spaces
function tab(message) {
	const THREE_SPACES = '   ';
	message = message.replace(/\t/g, THREE_SPACES);
	return message;
} // tab()

function failure(error) {
	throw new Error(`ERROR: ${tab(error)}\n`); // at line
} // failure()

function debug(msg, level) {
	level = level || 1;
	let message;

	//	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	if (DEBUG >= level) {
		message = tab(msg) + "\n";
		console.log(chomp(message)); // use a stream??
	}
	return message
} // debug()

function warning(message) {
	const msg = `WARN: ${tab(message)}\n`;
	warn(msg);
	return msg;
} // warning()

// Perlish functions used by my perl-lite template script

function warn(message) {
	console.warn(message); // at line NN
}

function say(message) {
	console.log(chomp(message)); // use stream
	return message;
}

function findBin() {
	const findBinFull = process.mainModule.filename;
	const findBin = path.dirname(findBinFull);
	const findBinScript = path.basename(findBinFull);

	return {bin: findBin, full: findBinFull, script: findBinScript};
} // findBin()

// perl auto-vivifies, JS does not
function pushKeyedItem(obj, key, ...values) {
	if (key in obj) {
		obj[key].push(...values);
	} else {
		obj[key] = [...values];
	}
} // pushKeyedItem()

// strip off newline character from string if present.
function chomp(line) {
	return line.replace(reEndLine, '');
}

function ucfirst(string) {
	return string
		.substring(0, 1)
		.toUpperCase() + string.substring(1)
}

// Like perl $string =~ m{some (regex) match}; assigning $1 $2 etc
function reMatchParams(string, regex) {
	let matched;
	let matches = [];

	try {
		string
			.replace(regex, function matcher(match, ...args/* offset, original */) {
				matched = true;
				matches = matches
					.push(match, ...args)
					.slice(-2);
				debug(`reMatchParams "${string}" =~ ${regex.toString()} <` + args.join("> <") + ">", 5);
				throw new Error('stop regex');
			});
	} finally {
		debug(`reMatchParams return [${matched
			? Dumper(matches)
			: matched}]`, 4)
		return matched
			? matches
			: matched;
	}
} // reMatchParams()

const inspectOptions = {
	colors    : true,
	compact   : false,
	depth     : Infinity,
	showHidden: false, // true to show non-enumerable
	sorted    : true
};
function Dumper(thing) {
	return util.inspect(thing, inspectOptions);
}

// Pseudo Random Number Generator (not for crypto)
// https://stackoverflow.com/questions/521295/seeding-the-random-number-generator
// -in-javascript
// Also java-random package if your random sequence should be compatible with a java random sequence
let rand = Math.random;

// Generate seed for PRNG
function _cyrb128(str) {
	let h1 = 1779033703,
		h2 = 3144134277,
		h3 = 1013904242,
		h4 = 2773480762;
	for (let i = 0, k; i < str.length; i++) {
		k  = str.charCodeAt(i);
		h1 = h2 ^ Math.imul(h1 ^ k, 597399067);
		h2 = h3 ^ Math.imul(h2 ^ k, 2869860233);
		h3 = h4 ^ Math.imul(h3 ^ k, 951274213);
		h4 = h1 ^ Math.imul(h4 ^ k, 2716044179);
	}
	h1 = Math.imul(h3 ^ (h1 >>> 18), 597399067);
	h2 = Math.imul(h4 ^ (h2 >>> 22), 2869860233);
	h3 = Math.imul(h1 ^ (h3 >>> 17), 951274213);
	h4 = Math.imul(h2 ^ (h4 >>> 19), 2716044179);
	return [
		(h1 ^ h2 ^ h3 ^ h4) >>> 0,
		(h2 ^ h1) >>> 0,
		(h3 ^ h1) >>> 0,
		(h4 ^ h1) >>> 0
	];
} // _cyrb128()

// Simple Fast Counter PRNG http://pracrand.sourceforge.net/
function _sfc32(a, b, c, d) {
	return function () {
		a >>>= 0;
		b >>>= 0;
		c >>>= 0;
		d >>>= 0;
		var t = (a + b) | 0;
		a = b ^ b >>> 9;
		b = c + (c << 3) | 0;
		c = (c << 21 | c >>> 11);
		d = d + 1 | 0;
		t = t + d | 0;
		c = c + t | 0;
		return (t >>> 0) / 4294967296;
	}
} // _sfc32()

function _initRand() {
	const seed = _cyrb128(new Date().toString());
	debug(`PRNG seed: ${Dumper(seed)}`);
	// Four 32-bit component hashes provide the seed for sfc32.
	rand0 = _sfc32(seed[0], seed[1], seed[2], seed[3]);
	for (let count = 16; count; --count) {
		rand0()
	}
	rand = function (range) {
		return range * rand0();
	}
	debug(`rand(6) ${rand(6)}`);
	debug(`rand(63) ${rand(63)}`);
} // _initRand()

_initRand();
main();

// const cmdTyped = process.env._; // from bash const cwd = process.env.PWD;
// const cmdPath = process.argv[1]; both full expanded path name to this script.
// console.log('cmdPath', cmdPath); console.log('ARGV', ARGV); what the user
// typed on the command line kind of ./assign-to-team.js => ./assign-to-team.js
// node ./assign-to-team.js  => /home/me/.nvm/versions/node/v6.11.4/bin/node
// Windows?? console.log('cmdTyped', cmdTyped); console.log('cwd', cwd);

`
/*
__END__
# Example data structure for files parsed:
# use hash marker to exclude people who are currently away.
# indentation optional
#front:
#	peter
#	paul
#	mary
#back:
#	fred
#	wilma
#	betty
#test:
#	george
#	elroy
#	jane
#stories:
#ID-001
#ID-002
#ID-003
#ID-004
#ID-005
#ID-006
#ID-007
# optional end marker to begin dividing tasks now
#end:
*/
`
