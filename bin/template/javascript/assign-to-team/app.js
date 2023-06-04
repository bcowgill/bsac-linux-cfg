#!/usr/bin/env node
// nvm use v17.9.1

const VERSION = 0.1
const DEBUG = (typeof process !== 'undefined' && process.env && process.env.DEBUG) || 0

const IN = '   '
const NLIN = `\n${IN}`
const NLININ = `${NLIN}${IN}`
const reNewLine = /\n/
const reEndLine = /(\x0d\x0a|\x0a|\x0d)$/
const reEnd = /^\s*(end|stop|quit|go)\s*:\s*$/i
const reTaskList = /^\s*(tasks?|stor(y|ies))\s*:\s*$/i
const reRoleList = /^\s*([^:]+)\s*:\s*$/i
const reMember = /^\s*(.+)\s*$/i
const reBlank = /^\s*(\#|$)/
const reTrimSpace = /\s\s+/
const reStripRandom = /^\d+:/

if (typeof document === 'undefined') {
	// if using node to run outside a browser, simulate what we need.
	document = {
		getElementById: (id) => {
			let value = ''
			if (id === 'role-list') {
				value = teamInputX
			}
			if (id === 'task-list') {
				value = taskInputX
			}
			return { className: '', innerHTML: '', value }
		}
	}
	window = { document }
}

let Tasks = {}
let Roles = {}
let Teams = []
let context
let group
let jobs = 0
let refreshed = false

const teamInput = ''
const teamInputX = `
# Example format for textarea parsed:
# use hash marker to exclude people who are currently away.
# indentation optional
front:
	peter
	paul
	mary
back:
	fred
	wilma
	betty
test:
	george
	elroy
	jane
`

const taskInput = ''
const taskInputX = `
stories:
ID-001
ID-002
ID-003
ID-004
ID-005
ID-006
ID-007
task:
skip to the loo
climb the hill
jump over the moon
run away with the spoon
# optional end marker to begin dividing tasks now
end:
`

const elApp = document.getElementById('controls')
const elRoleList = document.getElementById('role-list')
const elTaskList = document.getElementById('task-list')
const elErrors = document.getElementById('errors')
const elOutput = document.getElementById('team-assignments')

function go() {
	try
	{
		// Reset all the parsing and reporting variables
		Tasks              = {}
		Roles              = {}
		Teams              = []
		context            = void 0
		group              = void 0
		jobs               = 0
		refreshed          = false

		// Reset all the HTML rendering states
		elErrors.innerHTML = ''
		elOutput.innerHTML = ''
		elOutput.className = addClass(elOutput.className, 'hidden')
		HTML               = ''

		processInput()
		report()
	} catch (EVAL_ERROR) {
		fatal(EVAL_ERROR)
	}
} // go()

function main() {
	// Show initially hidden app section
	elApp.className = ''
	getState()
	go()
} // main()

function fatal(error) {
	warn(error)
	elErrors.innerHTML = error
		.toString()
		.replace(/Error:\s*/gi, '')
	elErrors.className = removeClass(elErrors.className, 'hidden')
	elOutput.className = addClass(elOutput.className, 'hidden')
}

function parse(line) {
	debug("parse:" + line)
	if (!reBlank.test(line)) {
		chomp(line)
		debug(line, 2)
		let params
		if (params = reMatchParams(line, reTaskList)) {
			context = 'task'
			group   = ucfirst(params[1])
			++jobs
			debug(`begin ${context}/${group}`)
		} else if (params = reMatchParams(line, reEnd)) {
			report()
		} else if (params = reMatchParams(line, reRoleList)) {
			context = 'role'
			group   = ucfirst(params[1])
			debug(`begin ${context}/${group}`)
		} else if (params = reMatchParams(line, reMember)) {
			let member = ucfirst(params[1])
			member = member.replace(new RegExp(reTrimSpace, 'g'), ' ')
			member = `${Math.floor(rand(10))}:${member}`
			if (context === 'task') {
				pushKeyedItem(Tasks, group, member)
			} else {
				pushKeyedItem(Roles, group, member)
			}
			debug(`..add ${member} to ${context}/${group}`)
		} else {
			debug(`...${line}`)
		}
	} // reBlank
} // parse()

function report() {
	if (!refreshed) {
		make_teams()
		assign_tasks()
		print_report()
		writeHtml()
		refreshed = true
	}
}

function make_teams() {
	const RoleNames = Object.keys(Roles)
	if (!jobs) {
		failure("You must specify one or more task: type lines to define what needs to be done by" +
				" the team.")
	}
	if (RoleNames.length < 1) {
		failure("You must specify one or more role: type lines to define the role types on the te" +
				"am.")
	}
	debug(`Roles: ${Dumper(RoleNames)}`, 3)
	let team = 1
	let found
	do {
		found = false
		const Team = []
		for (const role_type of RoleNames) {
			const [got,
				pick,
				named] = pick_one(role_type, Roles[role_type])
			found += got
			if (got) {
				Roles[role_type].splice(pick, 1)
				debug(`${role_type}: ${Dumper(Roles[role_type])}`, 3)
				Team.push(named)
			}
		}
		if (Team.length) {
			debug(`SORTING Team ${Dumper(Team)}`, 4)
			const Sorted = order_items(Team.sort())
			debug(`SORTING Sorted ${Dumper(Sorted)}`, 4)
			if (found === RoleNames.length) {
				Teams.push({
					assigned: {},
					members : Sorted,
					number  : team++
				})
			} else {
				const to_team = (team++ - 1) % Teams.length
				Teams[to_team]
					.members
					.push(...Sorted)
			}
		}
	} while (found)
	debug(`Teams: ${Dumper(Teams)}`, 3)
} // make_teams()

function order_items(List) {
	return List.map((item) => {
		return item.replace(reStripRandom, '')
	})
}

function pick_one(type, List) {
	const items = List.length
	debug(`pick $type ${Dumper(List)}`, 4)
	let got = 0
	let pick = ''
	let named = ''
	if (items) {
		pick  = Math.floor(rand(items))
		named = `${List[pick]} (${type})`
		got   = 1
	}
	debug(`picked ${got}, ${pick}, ${named}`, 4)
	return [got, pick, named]
} // pick_one()

function assign_tasks() {
	debug(`Tasks: ${Dumper(Tasks)}`, 3)
	const teams = Teams.length
	Jobs = Object.keys(Tasks)
	let number = 0
	for (const type of Jobs) {
		const Items = Tasks[type]
		for (const todo of Items) {
			const pick = number++ % teams
			pushKeyedItem(Teams[pick].assigned, type, todo)
		}
	}
	debug(`Assigned: ${Dumper(Teams)}`, 4)
} // assign_tasks()

function print_report() {
	for (const team of Teams) {

		say(`\nTeam${team.number}:\n`)
		html(`<h1>Team${team.number}:</h1>`)

		const Jobs = Object.keys(team.assigned)

		say(`${IN}${team.members.join(NLIN)}\n`)
		html(`<ul>`)
		html(`${team.members.map((name) => `<li>${name}</li>`).join("")}\n`)
		html(`</ul>`)

		for (const type of Jobs) {
			say(`${NLIN}${type}:\n`)
			html(`<h2>${type}:</h2>`)

			const Items = order_items(team.assigned[type])

			say(`${IN}${IN}${Items.join(NLININ)}\n`)
			html(`<ul>`)
			html(`${Items.map((name) => `<li>${name}</li>`).join("")}`)
			html(`</ul><br/>`)
		}
		html(`<br/>`)
	}
} // print_report()

function processInput() {
	// get from textarea in HTML
	const source = `${elRoleList.value}\n${elTaskList.value}`
	debug(`processInput: [${source}]`)
	processByLine(source, parse)
} // processInput()

function processByLine(source, fnLine) {
	const Lines = source.split(new RegExp(reNewLine, 'gms'))

	for (const line of Lines) {
		fnLine(line)
	}
} // processByLine()

// make tabs 3 spaces
function tab(message) {
	const THREE_SPACES = '   '
	message = message.replace(/\t/g, THREE_SPACES)
	return message
} // tab()

function failure(error) {
	throw new Error(`ERROR: ${tab(error)}\n`); // at line
} // failure()

function debug(msg, level) {
	level = level || 1
	let message

	//	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n"
	if (DEBUG >= level) {
		message = tab(msg) + "\n"
		console.log(chomp(message))
	}
	return message
} // debug()

function warning(message) {
	const msg = `WARN: ${tab(message)}\n`
	warn(msg)
	return msg
} // warning()

// Perlish functions used by my perl-lite template script

function warn(message) {
	console.warn(message); // at line NN
}

function say(message) {
	console.log(chomp(message))
	return message
}

let HTML = ''
function html(raw) {
	if (raw) {
		HTML += raw
	}
	return HTML
}

function writeHtml() {
	debug(`HTML: ${HTML}`)
	if (elOutput) {
		elOutput.innerHTML = HTML
		elOutput.className = removeClass(elOutput.className, 'hidden')
	} else {
		fatal("Cannot write buffered HTML to page.")
	}
}

// perl auto-vivifies, JS does not
function pushKeyedItem(obj, key, ...values) {
	if (key in obj) {
		obj[key].push(...values)
	} else {
		obj[key] = [...values]
	}
} // pushKeyedItem()

// strip off newline character from string if present.
function chomp(line) {
	return line.replace(reEndLine, '')
}

function ucfirst(string) {
	return string
		.substring(0, 1)
		.toUpperCase() + string.substring(1)
}

// Like perl $string =~ m{some (regex) match}; assigning $1 $2 etc
function reMatchParams(string, regex) {
	let matched
	let matches = []

	try {
		string
			.replace(regex, function matcher(match, ...args/* offset, original */) {
				matched = true
				matches = matches
					.push(match, ...args)
					.slice(-2)
				debug(`reMatchParams "${string}" =~ ${regex.toString()} <` + args.join("> <") + ">", 5)
				throw new Error('stop regex')
			})
	} finally {
		debug(`reMatchParams return [${matched
			? Dumper(matches)
			: matched}]`, 4)
		return matched
			? matches
			: matched
	}
} // reMatchParams()

const inspectOptions = [null, 2]
function Dumper(thing) {
	return JSON.stringify(thing, ...inspectOptions)
}

// Browser hosted version functions

function onClick() {
	try {
		saveState(elRoleList.value, elTaskList.value)
		go()
	} catch (exception) {}
}

function trace(item) {
	console.log('item', item)
	return item
}

let noSave = true
function getState() {
	if ('localStorage' in window) {
		try {
			const {roles, tasks} = JSON.parse(localStorage.getItem("rolesAndTasks") ?? '{}')
			noSave           = false
			elRoleList.value = roles ?? ''
			elTaskList.value = tasks ?? ''
		} catch (exception) {}
	}
}

function saveState(roles, tasks) {
	if ('localStorage' in window) {
		try {
			const packed = JSON.stringify({roles, tasks})
			debug(`saveState ${packed}`)
			localStorage.setItem("rolesAndTasks", packed)
		} catch (exception) {
			noSave = true
		}
	}
}

function updateSaveState(disabled) {
	saveMessage.innerText = disabled
		? '(cannot save)'
		: '(saved automatically)'
}

function addClass(classes, className) {
	return classes.replace(new RegExp(className.trim(), 'g'), '').trim() + ' ' + className.trim()
}

function removeClass(classes, className) {
	return classes.replace(new RegExp(className.trim(), 'g'), '').trim()
}

// Better random number functions Pseudo Random Number Generator (not for
// crypto)
// https://stackoverflow.com/questions/521295/seeding-the-random-number-generato
// r -in-javascript Also java-random package if your random sequence should be
// compatible with a java random sequence
let rand = Math.random

// Generate seed for PRNG
function _cyrb128(str) {
	let h1 = 1779033703,
		h2 = 3144134277,
		h3 = 1013904242,
		h4 = 2773480762
	for (let i = 0, k; i < str.length; i++) {
		k  = str.charCodeAt(i)
		h1 = h2 ^ Math.imul(h1 ^ k, 597399067)
		h2 = h3 ^ Math.imul(h2 ^ k, 2869860233)
		h3 = h4 ^ Math.imul(h3 ^ k, 951274213)
		h4 = h1 ^ Math.imul(h4 ^ k, 2716044179)
	}
	h1 = Math.imul(h3 ^ (h1 >>> 18), 597399067)
	h2 = Math.imul(h4 ^ (h2 >>> 22), 2869860233)
	h3 = Math.imul(h1 ^ (h3 >>> 17), 951274213)
	h4 = Math.imul(h2 ^ (h4 >>> 19), 2716044179)
	return [
		(h1 ^ h2 ^ h3 ^ h4) >>> 0,
		(h2 ^ h1) >>> 0,
		(h3 ^ h1) >>> 0,
		(h4 ^ h1) >>> 0
	]
} // _cyrb128()

// Simple Fast Counter PRNG http://pracrand.sourceforge.net/
function _sfc32(a, b, c, d) {
	return function () {
		a >>>= 0
		b >>>= 0
		c >>>= 0
		d >>>= 0
		var t = (a + b) | 0
		a = b ^ b >>> 9
		b = c + (c << 3) | 0
		c = (c << 21 | c >>> 11)
		d = d + 1 | 0
		t = t + d | 0
		c = c + t | 0
		return (t >>> 0) / 4294967296
	}
} // _sfc32()

function _initRand() {
	const seed = _cyrb128(new Date().toString())
	debug(`PRNG seed: ${Dumper(seed)}`)
	// Four 32-bit component hashes pride the seed for sfc32.
	rand0 = _sfc32(seed[0], seed[1], seed[2], seed[3])
	for (let count = 16; count; --count) {
		rand0()
	}
	rand = function (range) {
		return range * rand0()
	}
	debug(`rand(6) ${rand(6)}`)
	debug(`rand(63) ${rand(63)}`)
} // _initRand()

_initRand()
main()
