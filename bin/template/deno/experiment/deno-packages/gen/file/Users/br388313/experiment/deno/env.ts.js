#!/usr/bin/env deno run -A
/**
 * a symbolic link file to test file stat info against.
 * @constant {string}
 */ const LINK = '.link-test';
/**
 * a plain file to test file stat info against.
 * @constant {string}
 */ const JSON = 'deno.jsonc';
/**
 * a directory to test file stat info against.
 * @constant {string}
 */ const DIR = '.';
/**
 * answers with a truncated amount of text from the given text.
 * @param {string} text the multiple line body of text to truncate.
 * @param {number} LIMIT then number of lines to limit the text to. Default is 5.
 * @returns {string} the truncated text with newline markers visible and ellipsis at end.
 */ function limitText(text, LIMIT) {
  const lined = text.split(/\n/g).slice(0, LIMIT || 5);
  return lined.join('␤\n   ').concat('␤ …');
}
/**
 * answers with a readable list of files and information in a given directory.
 * @param {string} dir Name of directory to get list of files from.
 * @returns {[string]} List of readable file name information, classifying them as DIR FILE or SYM and showing the destination of symbolic links.
 * @example the list might be something like:
 *  - DIR docs/
 *  - FILE zshrc
 *  - SYM .deno-cache -> ../deno-packages
 */ function getDirSync(dir) {
  const files = [];
  const iterate = Deno.readDirSync(dir);
  for (const dir of iterate){
    files.push(` - ${dir.isDirectory ? 'DIR ' : ''}${dir.isFile ? 'FILE ' : ''}${dir.isSymlink ? 'SYM ' : ''}${dir.name}${dir.isDirectory ? '/' : ''}${dir.isSymlink ? ' -> ' + Deno.readLinkSync(dir.name) : ''}`);
  }
  return files;
}
const OCTAL = 8;
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
 */ function getStatSync(file, statSync = Deno.statSync) {
  let info = '';
  try {
    const stat = statSync(file);
    info = `${stat.isDirectory ? 'DIR ' : ''}${stat.isFile ? 'FILE ' : ''}${stat.isSymlink ? 'SYM ' : ''}${stat.isBlockDevice ? 'BLK ' : ''}${stat.isCharDevice ? 'CHR ' : ''}${stat.isFifo ? 'FIFO ' : ''}0${stat.mode?.toString(OCTAL)} ${stat.uid}:${stat.gid} ${stat.size}b ${stat.blocks}@512[${stat.blksize}] @@${stat.dev}:${stat.rdev}:${stat.ino} #l:${stat.nlink} ${stat.birthtime}/${stat.mtime}/${stat.atime} ${file}`;
  } catch (exception) {
    info = `${exception.toString()}: ${file}`;
  }
  return info;
}
/**
 * answers with a readable line of stat information about a file or the symlink itself (not the link target).
 *
 * @param {string} file name of symlink or file to get stat information.
 * @returns {string} Readable file name information, classifying them as DIR FILE or SYM, BLK/CHR/FIFO and showing all other file status information.
 */ function getLStatSync(file) {
  return getStatSync(file, Deno.lstatSync);
}
// console.log(`Deno keys`, Object.keys(Deno).filter((name) => /Sync/.test(name)));
// console.log(`Deno keys`, Object.keys(Deno).filter((name) => !/Sync/.test(name)).sort());
console.log(`Deno.hostname()`, Deno.hostname());
console.log(`Deno.memoryUsage()`, Deno.memoryUsage());
console.log(`Deno.version`, Deno.version);
console.log(`Deno.build.os`, Deno.build.os);
console.log(`Deno.osRelease()`, Deno.osRelease());
console.log(`Deno.pid`, Deno.pid);
console.log(`Deno.ppid`, Deno.ppid);
console.log(`Deno.uid()`, Deno.uid());
console.log(`Deno.gid()`, Deno.gid());
console.log(`Deno.noColor`, Deno.noColor);
console.log(`Deno.realPathSync('..')`, Deno.realPathSync('..'));
console.log(`Deno.cwd()`, Deno.cwd());
console.log(`Deno.mainModule`, Deno.mainModule);
console.log(`Deno.args`, Deno.args);
console.log(`Deno.isatty(ttyId)`, [
  0,
  1,
  2
].map((id)=>Deno.isatty(id)));
console.log(`Deno.readLinkSync('${LINK}')`, Deno.readLinkSync(LINK));
console.log(`Deno.readTextFileSync('./deno.jsonc')`, limitText(Deno.readTextFileSync('./deno.jsonc')));
console.log(`Deno.readDirSync("${DIR}")`);
console.log(getDirSync(DIR).sort().join('\n'));
console.log(`Deno.statSync("${DIR}")`, getStatSync(DIR));
console.log(`Deno.lstatSync("${DIR}")`, getLStatSync(DIR));
console.log(`Deno.statSync("${JSON}")`, getStatSync(JSON));
console.log(`Deno.lstatSync("${JSON}")`, getLStatSync(JSON));
console.log(`Deno.statSync('${LINK}')`, getStatSync(LINK));
console.log(`Deno.lstatSync('${LINK}')`, getLStatSync(LINK));
console.log(`Deno.env.toObject()`, Deno.env.toObject());
console.log(`Deno.errors`, Deno.errors);
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImZpbGU6Ly8vVXNlcnMvYnIzODgzMTMvZXhwZXJpbWVudC9kZW5vL2Vudi50cyJdLCJzb3VyY2VzQ29udGVudCI6WyIjIS91c3IvYmluL2VudiBkZW5vIHJ1biAtQVxuXG4vKipcbiAqIGEgc3ltYm9saWMgbGluayBmaWxlIHRvIHRlc3QgZmlsZSBzdGF0IGluZm8gYWdhaW5zdC5cbiAqIEBjb25zdGFudCB7c3RyaW5nfVxuICovXG5jb25zdCBMSU5LID0gJy5saW5rLXRlc3QnXG4vKipcbiAqIGEgcGxhaW4gZmlsZSB0byB0ZXN0IGZpbGUgc3RhdCBpbmZvIGFnYWluc3QuXG4gKiBAY29uc3RhbnQge3N0cmluZ31cbiAqL1xuY29uc3QgSlNPTiA9ICdkZW5vLmpzb25jJ1xuLyoqXG4gKiBhIGRpcmVjdG9yeSB0byB0ZXN0IGZpbGUgc3RhdCBpbmZvIGFnYWluc3QuXG4gKiBAY29uc3RhbnQge3N0cmluZ31cbiAqL1xuY29uc3QgRElSID0gJy4nXG5cbi8qKlxuICogYW5zd2VycyB3aXRoIGEgdHJ1bmNhdGVkIGFtb3VudCBvZiB0ZXh0IGZyb20gdGhlIGdpdmVuIHRleHQuXG4gKiBAcGFyYW0ge3N0cmluZ30gdGV4dCB0aGUgbXVsdGlwbGUgbGluZSBib2R5IG9mIHRleHQgdG8gdHJ1bmNhdGUuXG4gKiBAcGFyYW0ge251bWJlcn0gTElNSVQgdGhlbiBudW1iZXIgb2YgbGluZXMgdG8gbGltaXQgdGhlIHRleHQgdG8uIERlZmF1bHQgaXMgNS5cbiAqIEByZXR1cm5zIHtzdHJpbmd9IHRoZSB0cnVuY2F0ZWQgdGV4dCB3aXRoIG5ld2xpbmUgbWFya2VycyB2aXNpYmxlIGFuZCBlbGxpcHNpcyBhdCBlbmQuXG4gKi9cbmZ1bmN0aW9uIGxpbWl0VGV4dCh0ZXh0OiBzdHJpbmcsIExJTUlUPzogbnVtYmVyKTogc3RyaW5nIHtcblx0Y29uc3QgbGluZWQgPSB0ZXh0LnNwbGl0KC9cXG4vZykuc2xpY2UoMCwgTElNSVQgfHwgNSlcblx0cmV0dXJuIGxpbmVkLmpvaW4oJ+KQpFxcbiAgICcpLmNvbmNhdCgn4pCkIOKApicpXG59XG5cbi8qKlxuICogYW5zd2VycyB3aXRoIGEgcmVhZGFibGUgbGlzdCBvZiBmaWxlcyBhbmQgaW5mb3JtYXRpb24gaW4gYSBnaXZlbiBkaXJlY3RvcnkuXG4gKiBAcGFyYW0ge3N0cmluZ30gZGlyIE5hbWUgb2YgZGlyZWN0b3J5IHRvIGdldCBsaXN0IG9mIGZpbGVzIGZyb20uXG4gKiBAcmV0dXJucyB7W3N0cmluZ119IExpc3Qgb2YgcmVhZGFibGUgZmlsZSBuYW1lIGluZm9ybWF0aW9uLCBjbGFzc2lmeWluZyB0aGVtIGFzIERJUiBGSUxFIG9yIFNZTSBhbmQgc2hvd2luZyB0aGUgZGVzdGluYXRpb24gb2Ygc3ltYm9saWMgbGlua3MuXG4gKiBAZXhhbXBsZSB0aGUgbGlzdCBtaWdodCBiZSBzb21ldGhpbmcgbGlrZTpcbiAqICAtIERJUiBkb2NzL1xuICogIC0gRklMRSB6c2hyY1xuICogIC0gU1lNIC5kZW5vLWNhY2hlIC0+IC4uL2Rlbm8tcGFja2FnZXNcbiAqL1xuZnVuY3Rpb24gZ2V0RGlyU3luYyhkaXI6IHN0cmluZykge1xuXHRjb25zdCBmaWxlcyA9IFtdXG5cdGNvbnN0IGl0ZXJhdGUgPSBEZW5vLnJlYWREaXJTeW5jKGRpcilcblx0Zm9yIChjb25zdCBkaXIgb2YgaXRlcmF0ZSkge1xuXHRcdGZpbGVzLnB1c2goXG5cdFx0XHRgIC0gJHtkaXIuaXNEaXJlY3RvcnkgPyAnRElSICcgOiAnJ30ke2Rpci5pc0ZpbGUgPyAnRklMRSAnIDogJyd9JHtcblx0XHRcdFx0ZGlyLmlzU3ltbGluayA/ICdTWU0gJyA6ICcnXG5cdFx0XHR9JHtkaXIubmFtZX0ke2Rpci5pc0RpcmVjdG9yeSA/ICcvJyA6ICcnfSR7XG5cdFx0XHRcdGRpci5pc1N5bWxpbmsgPyAnIC0+ICcgKyBEZW5vLnJlYWRMaW5rU3luYyhkaXIubmFtZSkgOiAnJ1xuXHRcdFx0fWAsXG5cdFx0KVxuXHR9XG5cdHJldHVybiBmaWxlc1xufVxuXG5jb25zdCBPQ1RBTCA9IDhcbi8qKlxuICogYW5zd2VycyB3aXRoIGEgcmVhZGFibGUgbGluZSBvZiBmaWxlIHN0YXQgaW5mb3JtYXRpb24uXG4gKlxuICogQHBhcmFtIHtzdHJpbmd9IGZpbGUgbmFtZSBvZiBmaWxlIHRvIGdldCBzdGF0IGluZm9ybWF0aW9uLlxuICogQHBhcmFtIHsoc3RyaW5nKSA9PiBEZW5vLkZpbGVJbmZvfSBzdGF0U3luYyBzeW5jaHJvbm91cyBzdGF0IGZ1bmN0aW9uIHRvIHVzZS4gRGVmYXVsdHMgdG8gRGVuby5zdGF0U3luYygpIHdoaWNoIHByb3ZpZGVzIGluZm8gYWJvdXQgdGhlIGZpbGUgb3IgdGhlIHRhcmdldCBvZiBhIGxpbmsuXG4gKiBAcmV0dXJucyB7c3RyaW5nfSBSZWFkYWJsZSBmaWxlIG5hbWUgaW5mb3JtYXRpb24sIGNsYXNzaWZ5aW5nIHRoZW0gYXMgRElSIEZJTEUgb3IgU1lNLCBCTEsvQ0hSL0ZJRk8gYW5kIHNob3dpbmcgYWxsIG90aGVyIGZpbGUgc3RhdHVzIGluZm9ybWF0aW9uLlxuICogQGV4YW1wbGUgdGhlIGluZm8gbWlnaHQgYmUgc29tZXRoaW5nIGxpa2U6XG4gKiAgICAnRElSIDA0MDc1NSA1MDE6MjAgODk2YiAwQDUxMls0MDk2XSBcXEBAMTY3NzcyMjA6MDo0MDg5MjYwICNsOjI4IFdlZCBKYW4gMTAgMjAyNCAwNzozNDoxOCBHTVQrMDAwMCAoR3JlZW53aWNoIE1lYW4gVGltZSkvV2VkIEphbiAxMCAyMDI0IDE5OjExOjQwIEdNVCswMDAwIChHcmVlbndpY2ggTWVhbiBUaW1lKS9XZWQgSmFuIDEwIDIwMjQgMTk6MTE6NDAgR01UKzAwMDAgKEdyZWVud2ljaCBNZWFuIFRpbWUpIC4nXG4gKiAgICAnU1lNIDAxMjA3NTUgNTAxOjIwIDExYiAwQDUxMls0MDk2XSBcXEBAMTY3NzcyMjA6MDo0MTQ1MTgxICNsOjEgV2VkIEphbiAxMCAyMDI0IDE0OjI2OjI1IEdNVCswMDAwIChHcmVlbndpY2ggTWVhbiBUaW1lKS9XZWQgSmFuIDEwIDIwMjQgMTQ6MjY6MjUgR01UKzAwMDAgKEdyZWVud2ljaCBNZWFuIFRpbWUpL1dlZCBKYW4gMTAgMjAyNCAxNDoyNjoyNSBHTVQrMDAwMCAoR3JlZW53aWNoIE1lYW4gVGltZSkgLmxpbmstdGVzdCdcbiAqICAgICdGSUxFIDAxMDA2NDQgNTAxOjIwIDIwMDFiIDhANTEyWzQwOTZdIFxcQEAxNjc3NzIyMDowOjQxNDY3NDYgI2w6MSBXZWQgSmFuIDEwIDIwMjQgMTQ6Mzc6MDMgR01UKzAwMDAgKEdyZWVud2ljaCBNZWFuIFRpbWUpL1dlZCBKYW4gMTAgMjAyNCAxOToxMjozMyBHTVQrMDAwMCAoR3JlZW53aWNoIE1lYW4gVGltZSkvV2VkIEphbiAxMCAyMDI0IDE5OjEyOjM1IEdNVCswMDAwIChHcmVlbndpY2ggTWVhbiBUaW1lKSBkZW5vLmpzb25jJ1xuICovXG5mdW5jdGlvbiBnZXRTdGF0U3luYyhmaWxlOiBzdHJpbmcsIHN0YXRTeW5jID0gRGVuby5zdGF0U3luYyk6IHN0cmluZyB7XG5cdGxldCBpbmZvID0gJydcblx0dHJ5IHtcblx0XHRjb25zdCBzdGF0ID0gc3RhdFN5bmMoZmlsZSlcblx0XHRpbmZvID0gYCR7c3RhdC5pc0RpcmVjdG9yeSA/ICdESVIgJyA6ICcnfSR7c3RhdC5pc0ZpbGUgPyAnRklMRSAnIDogJyd9JHtcblx0XHRcdHN0YXQuaXNTeW1saW5rID8gJ1NZTSAnIDogJydcblx0XHR9JHtzdGF0LmlzQmxvY2tEZXZpY2UgPyAnQkxLICcgOiAnJ30ke3N0YXQuaXNDaGFyRGV2aWNlID8gJ0NIUiAnIDogJyd9JHtcblx0XHRcdHN0YXQuaXNGaWZvID8gJ0ZJRk8gJyA6ICcnXG5cdFx0fTAke1xuXHRcdFx0c3RhdC5tb2RlPy50b1N0cmluZyhPQ1RBTClcblx0XHR9ICR7c3RhdC51aWR9OiR7c3RhdC5naWR9ICR7c3RhdC5zaXplfWIgJHtzdGF0LmJsb2Nrc31ANTEyWyR7c3RhdC5ibGtzaXplfV0gQEAke3N0YXQuZGV2fToke3N0YXQucmRldn06JHtzdGF0Lmlub30gI2w6JHtzdGF0Lm5saW5rfSAke3N0YXQuYmlydGh0aW1lfS8ke3N0YXQubXRpbWV9LyR7c3RhdC5hdGltZX0gJHtmaWxlfWBcblx0fSBjYXRjaCAoZXhjZXB0aW9uKSB7XG5cdFx0aW5mbyA9IGAke2V4Y2VwdGlvbi50b1N0cmluZygpfTogJHtmaWxlfWBcblx0fVxuXHRyZXR1cm4gaW5mb1xufVxuLyoqXG4gKiBhbnN3ZXJzIHdpdGggYSByZWFkYWJsZSBsaW5lIG9mIHN0YXQgaW5mb3JtYXRpb24gYWJvdXQgYSBmaWxlIG9yIHRoZSBzeW1saW5rIGl0c2VsZiAobm90IHRoZSBsaW5rIHRhcmdldCkuXG4gKlxuICogQHBhcmFtIHtzdHJpbmd9IGZpbGUgbmFtZSBvZiBzeW1saW5rIG9yIGZpbGUgdG8gZ2V0IHN0YXQgaW5mb3JtYXRpb24uXG4gKiBAcmV0dXJucyB7c3RyaW5nfSBSZWFkYWJsZSBmaWxlIG5hbWUgaW5mb3JtYXRpb24sIGNsYXNzaWZ5aW5nIHRoZW0gYXMgRElSIEZJTEUgb3IgU1lNLCBCTEsvQ0hSL0ZJRk8gYW5kIHNob3dpbmcgYWxsIG90aGVyIGZpbGUgc3RhdHVzIGluZm9ybWF0aW9uLlxuICovXG5mdW5jdGlvbiBnZXRMU3RhdFN5bmMoZmlsZTogc3RyaW5nKTogc3RyaW5nIHtcblx0cmV0dXJuIGdldFN0YXRTeW5jKGZpbGUsIERlbm8ubHN0YXRTeW5jKVxufVxuXG4vLyBjb25zb2xlLmxvZyhgRGVubyBrZXlzYCwgT2JqZWN0LmtleXMoRGVubykuZmlsdGVyKChuYW1lKSA9PiAvU3luYy8udGVzdChuYW1lKSkpO1xuLy8gY29uc29sZS5sb2coYERlbm8ga2V5c2AsIE9iamVjdC5rZXlzKERlbm8pLmZpbHRlcigobmFtZSkgPT4gIS9TeW5jLy50ZXN0KG5hbWUpKS5zb3J0KCkpO1xuY29uc29sZS5sb2coYERlbm8uaG9zdG5hbWUoKWAsIERlbm8uaG9zdG5hbWUoKSlcbmNvbnNvbGUubG9nKGBEZW5vLm1lbW9yeVVzYWdlKClgLCBEZW5vLm1lbW9yeVVzYWdlKCkpXG5jb25zb2xlLmxvZyhgRGVuby52ZXJzaW9uYCwgRGVuby52ZXJzaW9uKVxuY29uc29sZS5sb2coYERlbm8uYnVpbGQub3NgLCBEZW5vLmJ1aWxkLm9zKVxuY29uc29sZS5sb2coYERlbm8ub3NSZWxlYXNlKClgLCBEZW5vLm9zUmVsZWFzZSgpKVxuY29uc29sZS5sb2coYERlbm8ucGlkYCwgRGVuby5waWQpXG5jb25zb2xlLmxvZyhgRGVuby5wcGlkYCwgRGVuby5wcGlkKVxuY29uc29sZS5sb2coYERlbm8udWlkKClgLCBEZW5vLnVpZCgpKVxuY29uc29sZS5sb2coYERlbm8uZ2lkKClgLCBEZW5vLmdpZCgpKVxuY29uc29sZS5sb2coYERlbm8ubm9Db2xvcmAsIERlbm8ubm9Db2xvcilcbmNvbnNvbGUubG9nKGBEZW5vLnJlYWxQYXRoU3luYygnLi4nKWAsIERlbm8ucmVhbFBhdGhTeW5jKCcuLicpKVxuY29uc29sZS5sb2coYERlbm8uY3dkKClgLCBEZW5vLmN3ZCgpKVxuY29uc29sZS5sb2coYERlbm8ubWFpbk1vZHVsZWAsIERlbm8ubWFpbk1vZHVsZSlcbmNvbnNvbGUubG9nKGBEZW5vLmFyZ3NgLCBEZW5vLmFyZ3MpXG5jb25zb2xlLmxvZyhgRGVuby5pc2F0dHkodHR5SWQpYCwgWzAsIDEsIDJdLm1hcCgoaWQpID0+IERlbm8uaXNhdHR5KGlkKSkpXG5jb25zb2xlLmxvZyhcblx0YERlbm8ucmVhZExpbmtTeW5jKCcke0xJTkt9JylgLFxuXHREZW5vLnJlYWRMaW5rU3luYyhMSU5LKSxcbilcbmNvbnNvbGUubG9nKFxuXHRgRGVuby5yZWFkVGV4dEZpbGVTeW5jKCcuL2Rlbm8uanNvbmMnKWAsXG5cdGxpbWl0VGV4dChEZW5vLnJlYWRUZXh0RmlsZVN5bmMoJy4vZGVuby5qc29uYycpKSxcbilcblxuY29uc29sZS5sb2coYERlbm8ucmVhZERpclN5bmMoXCIke0RJUn1cIilgKVxuY29uc29sZS5sb2coZ2V0RGlyU3luYyhESVIpLnNvcnQoKS5qb2luKCdcXG4nKSlcblxuY29uc29sZS5sb2coYERlbm8uc3RhdFN5bmMoXCIke0RJUn1cIilgLCBnZXRTdGF0U3luYyhESVIpKVxuY29uc29sZS5sb2coYERlbm8ubHN0YXRTeW5jKFwiJHtESVJ9XCIpYCwgZ2V0TFN0YXRTeW5jKERJUikpXG5jb25zb2xlLmxvZyhgRGVuby5zdGF0U3luYyhcIiR7SlNPTn1cIilgLCBnZXRTdGF0U3luYyhKU09OKSlcbmNvbnNvbGUubG9nKGBEZW5vLmxzdGF0U3luYyhcIiR7SlNPTn1cIilgLCBnZXRMU3RhdFN5bmMoSlNPTikpXG5jb25zb2xlLmxvZyhgRGVuby5zdGF0U3luYygnJHtMSU5LfScpYCwgZ2V0U3RhdFN5bmMoTElOSykpXG5jb25zb2xlLmxvZyhgRGVuby5sc3RhdFN5bmMoJyR7TElOS30nKWAsIGdldExTdGF0U3luYyhMSU5LKSlcblxuY29uc29sZS5sb2coYERlbm8uZW52LnRvT2JqZWN0KClgLCBEZW5vLmVudi50b09iamVjdCgpKVxuY29uc29sZS5sb2coYERlbm8uZXJyb3JzYCwgRGVuby5lcnJvcnMpXG4iXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IjtBQUVBOzs7Q0FHQyxHQUNELE1BQU0sT0FBTztBQUNiOzs7Q0FHQyxHQUNELE1BQU0sT0FBTztBQUNiOzs7Q0FHQyxHQUNELE1BQU0sTUFBTTtBQUVaOzs7OztDQUtDLEdBQ0QsU0FBUyxVQUFVLElBQVksRUFBRSxLQUFjO0VBQzlDLE1BQU0sUUFBUSxLQUFLLEtBQUssQ0FBQyxPQUFPLEtBQUssQ0FBQyxHQUFHLFNBQVM7RUFDbEQsT0FBTyxNQUFNLElBQUksQ0FBQyxVQUFVLE1BQU0sQ0FBQztBQUNwQztBQUVBOzs7Ozs7OztDQVFDLEdBQ0QsU0FBUyxXQUFXLEdBQVc7RUFDOUIsTUFBTSxRQUFRLEVBQUU7RUFDaEIsTUFBTSxVQUFVLEtBQUssV0FBVyxDQUFDO0VBQ2pDLEtBQUssTUFBTSxPQUFPLFFBQVM7SUFDMUIsTUFBTSxJQUFJLENBQ1QsQ0FBQyxHQUFHLEVBQUUsSUFBSSxXQUFXLEdBQUcsU0FBUyxHQUFHLEVBQUUsSUFBSSxNQUFNLEdBQUcsVUFBVSxHQUFHLEVBQy9E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