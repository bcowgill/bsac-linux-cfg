// comes from tslangorg.txt, tscompiler.txt, tsrunner.ts as a stand alone quick test...
/**
 * answers with the thing provided or the global object if found.
 * @param thing {undefined | unknown}
 * @returns {any} the thing if not null or undefined, otherwise tries to return the globalThis, global or window object.
 */
function getGlobal(thing) {
    return (typeof thing !== 'undefined' && thing !== null) ? thing : typeof globalThis !== 'undefined' ? globalThis : typeof global !== 'undefined' ? global : typeof window !== 'undefined' ? window : undefined;
    // return (typeof thing !== 'undefined' && thing !== null) ? thing : typeof globalThis !== 'undefined' ? globalThis : typeof global !== 'undefined' ? global : undefined;
}
/**
 * answers true if the script is running within bun
 * @returns {boolean} true if bun is detected with process.versions.bun
 * @note tested in version MUSTDO
 * @example bun run detect.ts
 */
/* export */ function isBun(bun) {
    let result = false;
    const thing = getGlobal(bun);
    if (!thing) {
        return false;
    }
    try {
        result = 'Bun' in thing && 'process' in thing && !!thing.process.versions && !!thing.process.versions.bun;
    }
    catch (_unused) {
        // console.error(`EXCEPTION isBun `, _unused);
    }
    return result;
} // isBun()
/**
 * answers true if the script is running within deno
 * @returns {boolean} true if deno is detected with global Deno and process.versions.deno
 * @note tested in version 1.40.3 MUSTDO deno 2.x
 * TRACE: isBun:false isDeno:true isTsx:false isNode:false isBrowser:false
 * @example deno run --allow-read detect.ts
 */
/* export */ function isDeno(deno) {
    let result = false;
    const thing = getGlobal(deno);
    if (!thing) {
        return false;
    }
    try {
        result = 'Deno' in thing;
    }
    catch (_unused) {
        // console.error(`EXCEPTION isBun `, _unused);
    }
    return result;
} // isDeno()
/**
 * answers true if the script is running within node
 * @returns {boolean} true if node is detected from process.versions.node
 * @note tested in version 21.6.1 and 6.11.4 (4.9.1 fails, 'let' not supported)
 * TRACE: isBun:false isDeno:false isTsx:false isNode:true isBrowser:false
 * @example node detect.ts
 */
/* export */ function isNode(node) {
    let result = false;
    const thing = getGlobal(node);
    if (!thing) {
        return false;
    }
    try {
        result = !isDeno(node) && !isBun(node) && 'process' in thing && !!thing.process.versions && !!thing.process.versions.node;
    }
    catch (_unused) {
        // console.error(`EXCEPTION isBun `, _unused);
    }
    return result;
} // isNode()
/**
 * answers true if script is running with tsx (which runs on node)
 * @returns {boolean} true if tsx is detected by process.execArgv containing 'node_modules/tsx/'
 * @note tested in version 4.19.3 MUSTDO newer version?
 * TRACE: isBun:false isDeno:false isTsx:true isNode:true isBrowser:false
 * @example npx tsx detect.ts
 */
/* export */ function isTsx(node) {
    let result = false;
    const thing = getGlobal(node);
    if (!isNode(node)) {
        return false;
    }
    try {
        result = !!('process' in thing && thing.process.execArgv?.find((path) => path.indexOf('node_modules/tsx/') >= 0));
    }
    catch (_unused) {
        // console.error(`EXCEPTION isBun `, _unused);
    }
    return result;
} // isTsx()
/**
 * answers true if script is not running in deno, bun or node, so it must be a browser version...
 * @returns {boolean} true if running in a browser
 * @note tested at https://www.typescriptlang.org/play/?module=1
 * TRACE: isBun:false isDeno:false isTsx:false isNode:false isBrowser:true"
 */
/* export */ function isBrowser(win) {
    return !isDeno(win) && !isBun(win) && !isNode(win); // tsx is also node, so no check needed.
}
// MUSTDO put in tslangorg.txt
/**
 * answer with a new object that can be JSON.stringified.
 * @param thing {Record<string, unknown>} an object which cannot be stringified.
 * @returns {Record<string, unknown>} a new object with values that cannot be stringified marked as cyclic.
 * @example window contains cyclic references so cannot be stringified, try to make a dumpable object
 * i.e. when trying to console.log(window) on https://www.typescriptlang.org/play/?target=9&module=1
 */
function getDumpableObject(thing) {
    const dumpable = {};
    Object.keys(thing).sort().forEach((key) => {
        if (Object.hasOwn(thing, key)) {
            if (typeof thing[key] !== 'object') {
                dumpable[key] = thing[key];
            }
            else {
                try {
                    if (JSON.stringify(thing[key])) {
                        dumpable[key] = thing[key];
                    }
                }
                catch (_unused) {
                    dumpable[key] = `CYCLIC REF: ${Object.getPrototypeOf(thing[key])}`;
                }
            }
        }
    });
    return dumpable;
} // getDumpableObject()
console.warn(`TRACE: isBun:${isBun()} isDeno:${isDeno()} isTsx:${isTsx()} isNode:${isNode()} isBrowser:${isBrowser()}`);
const gg = getGlobal();
const dumpable = getDumpableObject(gg);
console.log(`dumpable global ${typeof gg} ${Object.getPrototypeOf(gg)}`, dumpable);
console.log(`real global`, gg);
