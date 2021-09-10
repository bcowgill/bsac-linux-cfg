#!/usr/bin/env node
// BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
// TODO separate repo and install to node_modules/.bin
// Lint your package.json to ensure dependencies are locked down.
// npm install -g lint-package-json
// Node cmd arg processing: http://stackabuse.com/command-line-arguments-in-node-js/  try yargs, minimist modules

const fs = require('fs');

const DEBUG = false;

// argv array offsets
const NODE = 0;
const ME = 1;
const ARG1 = 2;

// exit error codes
const OK = 0;
const EUSAGE = 1;
const EREAD = 2;
const EWRITE = 3;
const ELINT = 4;
const ESYNTAX = 5;
const EUNKNOWN = 6;

// command line options
var strictLock = true;
var skipDev = false;
var allowGit = false;
var allowGithub = false;
var allowUrl = false;
var allowFile = false;
const allowTags = {};

var fileName;
var packageJson;
var inProgress = 0;
var errors = 0;
var syntax = 0;
var unknown = 0;
var devDepError;

main();

function usage (message)
{
	message = message || '';
	const help =
message +
'\nusage: ' + binname() + ' [options...] filename ...' +
'\n' +
'\nChecks your package.json to ensure that dependency versions are locked down so that continuous integration (CI) builds are stable.' +
'\nRequires node v6.0.0+.' +
'\n' +
'\n-d or --skip-dev        will skip checks on devDependencies.' +
'\n-f or --allow-file      will allow file URL\'s as dependencies.' +
'\n-g or --allow-git       will allow git URI\'s as dependencies as long as they specify a specific commit.' +
'\n-h or --allow-github    will allow github user/reponame as dependencies as long as they specify a specific commit.' +
'\n-r or --allow-tag=name  will allow a specifically named release tag as a dependency version.' +
'\n-t or --no-strict       will allow ~semver as a dependency version. [t=tilde]' +
'\n-u or --allow-url       will allow URL\'s as dependencies.' +
'\n-? or --help            shows program help.' +
'\n' +
'\nsee also: https://docs.npmjs.com/files/package.json' +
'\n'.trim();

	console.log(help);
	process.exit(message.length ? EUSAGE : OK);
}

function main () {
	if (process.argv.length > ARG1)
	{
		var idx;
		const files = [];
		for (idx = ARG1; idx < process.argv.length; idx++)
		{
			var filename = process.argv[idx];
			if (!processArg(filename))
			{
				files.push(filename);
			}
		}
		files.forEach(function loopLint (filename) {
			lintFile(filename);
		});

	}
	else
	{
		usage();
	}
}

function onComplete () {
	if (--inProgress) {
		return;
	}
	if (syntax) {
		process.exit(ESYNTAX);
	}
	if (unknown) {
		process.exit(EUNKNOWN);
	}
	if (errors) {
		if (devDepError) {
			console.log(devDepError);
		}
		console.log('Please lock down the above dependency versions to an exact number'
			+ (strictLock ? '.' : ' or ~number.')
		);
		process.exit(ELINT);
	}
	console.log('Package dependencies are sufficiently exact.');
	process.exit(OK);
}

function lintFile (filename) {
	fileName = filename;
	if (/^[^\.\/~]/.test(fileName)) {
		fileName = './' + fileName;
	}

	++inProgress;
	willReadFileToString(fileName, function lintWhenRead (packageRaw) {
		try
		{
			packageJson = JSON.parse(packageRaw);
			if (DEBUG) {
				console.log('package:', fileName, packageJson);
			}
			checkLockDown('dependencies');
			if (!skipDev) {
				checkLockDown('devDependencies');
			}
		}
		catch (exception)
		{
			if (handleSyntaxError('' + exception, filename, packageRaw)) {
				++syntax;
			}
			else {
				++unknown;
				console.error("exception: ", exception);
			}
		}
		onComplete();
	});
}

function handleSyntaxError (exception, fileName, packageRaw) {
	// exception:  SyntaxError: /home/me/workspace/play/bsac-linux-cfg/bin/package.json: Unexpected string in JSON at position 679
	// Unexpected token , in JSON at position 0
	// SyntaxError: Unexpected string

	const regex = /^.+: (.+) in JSON at position (\d+).*$/;
	const regexNoPos = /^SyntaxError: (.+)/;
	var error;
	if (regex.test(exception)) {
		error = exception.replace(regex, '$1');
		const position = exception.replace(regex, '$2');
		showSyntaxError(fileName, packageRaw, position, error);
		return true;
	}
	else if (regexNoPos.test(exception)) {
		error = exception.replace(regexNoPos, '$1');
		console.error('SyntaxError: ' + fileName + ' ' + error);
		return true;
	}
	return false;
}

function showSyntaxError (filename, raw, position, error) {
	var before = raw.substr(0, position);
	const line = lineNumber(before);
	before = back2Lines(before);
	const after = keep2Lines(raw.substr(position));
	console.error('SyntaxError: ' + filename + ' @' + position + ', line ' + line + ' ' + error + ' indicated by <HERE> below.');
	console.error(before + '<HERE>' + after);
}

function lineNumber (text) {
	text = normalizeNewlines(text);
	return text.split('\n').length;
}

function back2Lines(text) {
	text = ('\n\n' + normalizeNewlines(text)).split('\n').slice(-2).join('\n');
	return text;
}

function keep2Lines(text) {
	text = (normalizeNewlines(text) + '\n\n').split('\n').slice(0, 2).join('\n');
	return text;
}

function normalizeNewlines (text) {
	text = text.replace(/(\x0d\x0a|\x0d|\x0a)/g, '\n');
	return text;
}

function processArg (arg)
{
	if (arg === '-?' || arg === '--help')
	{
		usage();
	}
	else if (arg === '-d' || arg === '--skip-dev')
	{
		skipDev = true;
		return true;
	}
	else if (arg === '-f' || arg === '--allow-file')
	{
		allowFile = true;
		return true;
	}
	else if (arg === '-g' || arg === '--allow-git')
	{
		allowGit = true;
		return true;
	}
	else if (arg === '-h' || arg === '--allow-github')
	{
		allowGithub = true;
		return true;
	}
	else if (arg === '-t' || arg === '--no-strict')
	{
		strictLock = false;
		return true;
	}
	else if (arg === '-u' || arg === '--allow-url')
	{
		allowUrl = true;
		return true;
	}
	else if (/^-(r|-allow-tag)=/.test(arg))
	{
		const tag = arg.split('=')[1];
		allowTags[tag] = true;
		return true;
	}
	else if (arg.substr(0, 1) === '-')
	{
		usage('Unknown option specified: ' + arg);
	}
	else
	{
		return false;
	}
}

function binname ()
{
	const LEAD_DIRSEP = /^[\/\\]/;
	return __filename.replace(__dirname, '').replace(LEAD_DIRSEP, '');
}

function error (dependencies, name, version, message) {
	console.log(fileName + ': ' + dependencies + '.' + name + ' [' + version + '] ' + message);
	++errors;
	return true;
}

function checkLockDown (dependencies) {
	if (packageJson[dependencies]) {
		Object.keys(packageJson[dependencies]).forEach(function checkDependencyVersion (name) {
			var version = packageJson[dependencies][name];
			if (allowGit && /^git.*:\/\/.+\#semver\:/.test(version)) {
				version = version.replace(/^git.+#semver:/, '');
			}
			if (checkVersion(dependencies, name, version)) {
				if (dependencies === 'devDependencies') {
					devDepError = 'specify --skip-dev to ignore version checks on devDependencies';
				}
			}
		});
	}
}

function checkVersion (dependencies, name, version) {
	if (/^git.*:\/\//.test(version)) {
		if (allowGit) {
			if (!/#./.test(version)) {
				return error(dependencies, name, version, 'git dependencies must specify a commitish: i.e. #v1.0.2');
			}
		}
		else {
			return error(dependencies, name, version, 'git dependencies are forbidden. [--allow-git to allow.]');
		}
	}
	else if (/^\w+\/\w+/.test(version)) {
		if (allowGithub) {
			if (!/#./.test(version)) {
				return error(dependencies, name, version, 'github dependencies must specify a commitish: i.e. #v1.0.2');
			}
		}
		else {
			return error(dependencies, name, version, 'github dependencies are forbidden. [--allow-github to allow.]');
		}
	}
	else if (/^https?:\/\//.test(version)) {
		if (!allowUrl) {
			return error(dependencies, name, version, 'http dependencies are forbidden. [--allow-url to allow.]');
		}
	}
	else if (/^file:/.test(version)) {
		if (!allowFile) {
			return error(dependencies, name, version, 'file dependencies are forbidden. [--allow-file to allow.]');
		}
	}
	else if (/^(\*|$)/.test(version)) {
		return error(dependencies, name, version, 'matches any version.');
	}
	else if (/(>|<| - |\||\.x)/.test(version)) {
		return error(dependencies, name, version, 'matches a range of versions.');
	}
	else if (/^[a-zA-Z]/.test(version) && !(version in allowTags)) {
		return error(dependencies, name, version, 'matches a release tag name. [--allow-tag=' + version + ' to allow.]');
	}
	else if (/^\^/.test(packageJson[dependencies][name])) {
		return error(dependencies, name, version, 'matches versions too loosely.');
	}
	else if (strictLock) {
		if (/^~/.test(version)) {
			return error(dependencies, name, version, 'matches versions too loosely. [--no-strict to allow.]');
		}
	}
	return false;
}

function willReadFileToString(filename, cb)
{
	const stream = fs.createReadStream(filename, { encoding: 'utf8' });
	willReadStreamToString(stream, cb);
}

function willReadStreamToString(stream, cb)
{
	const chunks = [];
	stream.on('data', function onStreamData (chunk) {
		chunks.push(chunk.toString());
	});
	stream.on('end', function onStreamEnd () {
		cb(chunks.join(''));
	});
	stream.on('error', function onStreamError (error) {
		fileError(error);
	})
}

function fileError (error, mode)
{
	mode = mode || 'Read';
	// error = { Error: ENOENT: no such file or directory, open 'that.js' errno: -2, code: 'ENOENT', syscall: 'open', path: 'that.js' }
	if (error)
	{
		const dir = process.cwd();
		console.error(error.path + ': ' + mode + ' ' + error.toString() + ' [current dir ' + dir + ']');
		process.exit(mode === 'Read' ? EREAD : EWRITE);
	}
}
