#!/usr/bin/env node
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
// Show most useful information about the node process.

const NODE_ENV = Object.keys(process.env).filter(env => /^(NODE|N[VP]M|TMP|USER|HOME|SHELL|PATH|LOG|TERM|COLUMN|LINE|PWD|EDITOR|LANG|TZ)/.test(env)).sort();

console.log(`
node process object:
.title ${process.title}
.version ${process.version}
.platform ${process.platform}
.arch ${process.arch}
.pid ${process.pid}
.ppid ${process.ppid}
.debugPort ${process.debugPort}
.argv.length ${process.argv.length}
.argv0 ${process.argv0}
.execPath ${process.execPath}
.argv[0] ${process.argv[0]} == path to node
.argv[1] ${process.argv[1]} == path to javascript file
.mainModule.filename = ${process.mainModule.filename}
.mainModule.paths = ${process.mainModule.paths.join('\n  ')}
__filename ${__filename}
.cwd() ${process.cwd()}
.env node related:
  ${NODE_ENV.map(env => `${env}: ${process.env[env]}`).join('\n  ')}
`.trim());

if (process.argv[2] === 'dump') {
	console.log(process)
}
