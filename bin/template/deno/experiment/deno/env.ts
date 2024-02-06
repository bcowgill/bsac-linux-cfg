#!/usr/bin/env deno run -A

/**
 * a symbolic link file to test file stat info against.
 * @constant {string}
 */
const LINK = '.link-test'
/**
 * a plain file to test file stat info against.
 * @constant {string}
 */
const JSON = 'deno.jsonc'
/**
 * a directory to test file stat info against.
 * @constant {string}
 */
const DIR = '.'

/**
 * answers with a truncated amount of text from the given text.
 * @param {string} text the multiple line body of text to truncate.
 * @param {number} LIMIT then number of lines to limit the text to. Default is 5.
 * @returns {string} the truncated text with newline markers visible and ellipsis at end.
 */
function limitText(text: string, LIMIT?: number): string {
	const lined = text.split(/\n/g).slice(0, LIMIT || 5)
	return lined.join('␤\n   ').concat('␤ …')
}

/**
 * answers with a readable list of files and information in a given directory.
 * @param {string} dir Name of directory to get list of files from.
 * @returns {[string]} List of readable file name information, classifying them as DIR FILE or SYM and showing the destination of symbolic links.
 * @example the list might be something like:
 *  - DIR docs/
 *  - FILE zshrc
 *  - SYM .deno-cache -> ../deno-packages
 */
function getDirSync(dir: string) {
	const files = []
	const iterate = Deno.readDirSync(dir)
	for (const dir of iterate) {
		files.push(
			` - ${dir.isDirectory ? 'DIR ' : ''}${dir.isFile ? 'FILE ' : ''}${
				dir.isSymlink ? 'SYM ' : ''
			}${dir.name}${dir.isDirectory ? '/' : ''}${
				dir.isSymlink ? ' -> ' + Deno.readLinkSync(dir.name) : ''
			}`,
		)
	}
	return files
}

const OCTAL = 8
/**
 * answers with a readable line of file stat information.
 *
 * @param {string} file name of file to get stat information.
 * @param {(string) => Deno.FileInfo} statSync synchronous stat function to use. Defaults to Deno.statSync() which provides info about the file or the target of a link.
 * @returns {string} Readable file name information, classifying them as DIR FILE or SYM, BLK/CHR/FIFO and showing all other file status information.
 * @example the info might be something like:
 *    'DIR 040755 501:20 896b 0@512[4096] \@@16777220:0:4089260 #l:28 Wed Jan 10 2024 07:34:18 GMT+0000 (Greenwich Mean Time)/Wed Jan 10 2024 19:11:40 GMT+0000 (Greenwich Mean Time)/Wed Jan 10 2024 19:11:40 GMT+0000 (Greenwich Mean Time) .'
 *    'SYM 0120755 501:20 11b 0@512[4096] \@@16777220:0:4145181 #l:1 Wed Jan 10 2024 14:26:25 GMT+0000 (Greenwich Mean Time)/Wed Jan 10 2024 14:26:25 GMT+0000 (Greenwich Mean Time)/Wed Jan 10 2024 14:26:25 GMT+0000 (Greenwich Mean Time) .link-test'
 *    'FILE 0100644 501:20 2001b 8@512[4096] \@@16777220:0:4146746 #l:1 Wed Jan 10 2024 14:37:03 GMT+0000 (Greenwich Mean Time)/Wed Jan 10 2024 19:12:33 GMT+0000 (Greenwich Mean Time)/Wed Jan 10 2024 19:12:35 GMT+0000 (Greenwich Mean Time) deno.jsonc'
 */
function getStatSync(file: string, statSync = Deno.statSync): string {
	let info = ''
	try {
		const stat = statSync(file)
		info = `${stat.isDirectory ? 'DIR ' : ''}${stat.isFile ? 'FILE ' : ''}${
			stat.isSymlink ? 'SYM ' : ''
		}${stat.isBlockDevice ? 'BLK ' : ''}${stat.isCharDevice ? 'CHR ' : ''}${
			stat.isFifo ? 'FIFO ' : ''
		}0${
			stat.mode?.toString(OCTAL)
		} ${stat.uid}:${stat.gid} ${stat.size}b ${stat.blocks}@512[${stat.blksize}] @@${stat.dev}:${stat.rdev}:${stat.ino} #l:${stat.nlink} ${stat.birthtime}/${stat.mtime}/${stat.atime} ${file}`
	} catch (exception) {
		info = `${exception.toString()}: ${file}`
	}
	return info
}
/**
 * answers with a readable line of stat information about a file or the symlink itself (not the link target).
 *
 * @param {string} file name of symlink or file to get stat information.
 * @returns {string} Readable file name information, classifying them as DIR FILE or SYM, BLK/CHR/FIFO and showing all other file status information.
 */
function getLStatSync(file: string): string {
	return getStatSync(file, Deno.lstatSync)
}

// console.log(`Deno keys`, Object.keys(Deno).filter((name) => /Sync/.test(name)));
// console.log(`Deno keys`, Object.keys(Deno).filter((name) => !/Sync/.test(name)).sort());
console.log(`Deno.hostname()`, Deno.hostname())
console.log(`Deno.memoryUsage()`, Deno.memoryUsage())
console.log(`Deno.version`, Deno.version)
console.log(`Deno.build.os`, Deno.build.os)
console.log(`Deno.osRelease()`, Deno.osRelease())
console.log(`Deno.pid`, Deno.pid)
console.log(`Deno.ppid`, Deno.ppid)
console.log(`Deno.uid()`, Deno.uid())
console.log(`Deno.gid()`, Deno.gid())
console.log(`Deno.noColor`, Deno.noColor)
console.log(`Deno.realPathSync('..')`, Deno.realPathSync('..'))
console.log(`Deno.cwd()`, Deno.cwd())
console.log(`Deno.mainModule`, Deno.mainModule)
console.log(`Deno.args`, Deno.args)
// isatty() deprecated and removal in 2.0
if (Deno.stdin.isTerminal) {
	// deno 1.40.3 (release, x86_64-apple-darwin) deprecation warning
	console.log(
		`Deno.stdin.isTerminal()`,
		Deno.stdin.isTerminal(),
	)
	console.log(
		`Deno.stdout.isTerminal()`,
		Deno.stdout.isTerminal(),
	)
	console.log(
		`Deno.stderr.isTerminal()`,
		Deno.stderr.isTerminal(),
	)
} else {
	// deno 1.39.2 (release, x86_64-apple-darwin) has isatty
	console.log(`Deno.isatty(ttyId)`, [0, 1, 2].map((id) => Deno.isatty(id)))
}
console.log(
	`Deno.readLinkSync('${LINK}')`,
	Deno.readLinkSync(LINK),
)
console.log(
	`Deno.readTextFileSync('./deno.jsonc')`,
	limitText(Deno.readTextFileSync('./deno.jsonc')),
)

console.log(`Deno.readDirSync("${DIR}")`)
console.log(getDirSync(DIR).sort().join('\n'))

console.log(`Deno.statSync("${DIR}")`, getStatSync(DIR))
console.log(`Deno.lstatSync("${DIR}")`, getLStatSync(DIR))
console.log(`Deno.statSync("${JSON}")`, getStatSync(JSON))
console.log(`Deno.lstatSync("${JSON}")`, getLStatSync(JSON))
console.log(`Deno.statSync('${LINK}')`, getStatSync(LINK))
console.log(`Deno.lstatSync('${LINK}')`, getLStatSync(LINK))

console.log(`Deno.env.toObject()`, Deno.env.toObject())
console.log(`Deno.errors`, Deno.errors)
