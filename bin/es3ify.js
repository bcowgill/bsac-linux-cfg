#!/usr/bin/env node
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
// Convert javascript to ES3 for object property names and trailing commas.
// npm install -g es3ify
// Node cmd arg processing: http://stackabuse.com/command-line-arguments-in-node-js/  try yargs, minimist modules

const fs = require('fs');

// argv array offsets
const NODE = 0;
const ME = 1;
const ARG1 = 2;

// exit error codes
const EUSAGE = 1;
const EREAD = 2;
const EWRITE = 3;

try
{
	require('es3ify');
}
catch (exception)
{
	console.error("exception: ", exception);
	console.error("process.argv", process.argv);
	console.error("process.env.NODE", process.env.NODE);
	console.error("process.env.NVM_PATH", process.env.NVM_PATH);
	console.error("process.env.NVM_DIR", process.env.NVM_DIR);
	console.error("process.env.NVM_BIN", process.env.NVM_BIN);
	usage('This program requires es3ify: npm install -g es3ify\n');
}

function usage (message = '')
{
	const help = `
${message}
usage: ${binname()} [-i] filename ...

Reads a javascript file and converts to ES3.
Default operation is to show the output to standard output.
-i or --inplace overwrites the file with the ES3 output.

Example processing.
	var x = {class: 2,};
	x.class = [3, 4,];

becomes:
	var x = {"class": 2};
	x["class"] = [3, 4];
`.trim();

	console.log(help);
	process.exit(EUSAGE);
}

const processES3 = require('es3ify');

function binname ()
{
	const LEAD_DIRSEP = /^[\/\\]/;
	return __filename.replace(__dirname, '').replace(LEAD_DIRSEP, '');
}

function willReadFileToString(filename, cb)
{
	const stream = fs.createReadStream(filename, { encoding: 'utf8' });
	willReadStreamToString(stream, cb);
}

function fileError (error, mode = 'Read')
{
	// error = { Error: ENOENT: no such file or directory, open 'that.js' errno: -2, code: 'ENOENT', syscall: 'open', path: 'that.js' }
	if (error)
	{
		const dir = process.cwd();
		console.error(`${error.path}: ${mode} ${error.toString()} [current dir ${dir}]`);
		process.exit(mode === 'Read' ? EREAD : EWRITE);
	}
}

function willWriteStringToFile(filename, content, cb)
{
	fs.writeFile(filename, content, { encoding: 'utf8' }, (error) => {
		fileError(error, 'Write');
	});
}

function willReadStreamToString(stream, cb)
{
	const chunks = [];
	stream.on('data', (chunk) => {
		chunks.push(chunk.toString());
	});
	stream.on('end', () => {
		cb(chunks.join(''));
	});
	stream.on('error', (error) => {
		fileError(error);
	})
}

function es3ifyToStdout (filename)
{
	willReadFileToString(filename, (content) => {
		console.log(processES3.transform(content));
	});
}

function es3ifyInPlace (filename)
{
	willReadFileToString(filename, (content) => {
		const es3 = processES3.transform(content);
		willWriteStringToFile(filename, es3);
	});
}

function processArg (options, arg)
{
	if (arg === '-i' || arg === '--inplace')
	{
		options.inplace = true;
		return true;
	}
	else
	{
		return false;
	}
}

if (process.argv.length > ARG1)
{
	let idx;
	const options = {};
	const files = [];
	for (idx = ARG1; idx < process.argv.length; idx++)
	{
		const filename = process.argv[idx];
		if (!processArg(options, filename))
		{
			files.push(filename);
		}
	}
	files.forEach((filename) => {
		if (options.inplace)
		{
			es3ifyInPlace(filename);
		}
		else
		{
			es3ifyToStdout(filename);
		}
	});
}
else
{
	usage();
}

