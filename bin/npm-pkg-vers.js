#!/usr/bin/env node

const fs = require('fs');

try
{
	require('glob');
}
catch (exception)
{
	console.error("exception: ", exception);
	console.error("process.argv", process.argv);
	console.error("process.env.NODE", process.env.NODE);
	console.error("process.env.NVM_PATH", process.env.NVM_PATH);
	console.error("process.env.NVM_DIR", process.env.NVM_DIR);
	console.error("process.env.NVM_BIN", process.env.NVM_BIN);
	usage('This program requires glob: npm install -g glob\nTo diagnose module loading use an exported environment variable NODE_DEBUG=module');
}

function usage (message = '')
{
	const help = `
${message}
Usage: ${binname()}

This program shows the version number of all modules installed in ./node_modules directory.
`.trim();

	console.log(help);
	process.exit(message ? 1 : 0);
}

function binname ()
{
	const LEAD_DIRSEP = /^[\/\\]/;
	return __filename.replace(__dirname, '').replace(LEAD_DIRSEP, '');
}

function readJSON (fileName) {
	const rawdata = fs.readFileSync(fileName);
	return JSON.parse(rawdata);
}

const glob = require('glob');

const testFolder = './node_modules';

function getVersionFromJSON(fileName) {
  let version;

  try {
    const package = readJSON(fileName);
    version = package.version;
  } catch (exception) {
    console.error('exception', exception);
  }
  return version;
}

const options = {};
glob(`${testFolder}/**/package.json`, options, function(error, files) {
  if (!error) {
    files.forEach((fileName) => {
      const file = fileName
        .replace(/\/package.json/, '')
        .replace(`${testFolder}/`, '');
      const version = getVersionFromJSON(fileName);
      if (version) {
        console.log(`${file} is_version ${version}`);
      } else {
        console.log(file, 'unknown');
      }
    });
  } else {
    console.error('error', error);
  }
});
