// Env.js
// Detecting your environment and getting access to the global object
// http://stackoverflow.com/questions/17575790/environment-detection-node-js-or-browser
// https://developer.mozilla.org/en-US/docs/Web/API/Window/self

'use strict'

let our
let SPRAY = false && (process.env.NODE_ENV !== 'production')

const displayName = 'Env'

const makeCheck = function (condition) {
    // eslint-disable-next-line no-new-func
    return new Function(
        'try { return '
        + condition
        + '; } catch (exception) { return false; }')
}

const makeGet = function (globalVar) {
    return 'try { __global = __global || ' + globalVar + '} catch (exception) {}'
}

const memoize = function (call) {
    let memory
    return function () {
        return memory === void 0 ? (memory = call()) : memory
    }
}

// eslint-disable-next-line no-new-func
const getGlobal = new Function(
    'var __global;'
    + makeGet('window')
    + makeGet('global')
    + makeGet('WorkerGlobalScope')
    + 'return __global;'
)

const isNode = memoize(makeCheck('this === global'))
const isKarma = memoize(makeCheck('"__karma__" in this'))
const isBrowser = memoize(makeCheck('this === window'))
const isWebWorker = memoize(makeCheck('this === WorkerGlobalScope'))

// http://engineering.shapesecurity.com/2015/01/detecting-phantomjs-based-visitors.html
const isPhantomJS = memoize(function () {
    let isPhantom = false
    let error
    // console.error("isPhantomJS")
    try {
        null[0]()
    }
    catch (exception) {
        // console.error("isPhantomJS catch ", exception, exception.stack)
        error = exception
    }
    if (error.stack.indexOf('phantomjs') > -1) {
        isPhantom = 'phantom stack'
    }
    else if (window && (window.callPhantom || window._phantom)) {
        isPhantom = 'phantom globals'
    }
    else if (navigator && (!(navigator.plugins instanceof PluginArray) || navigator.plugins.length == 0)) {
        isPhantom = 'phantom plugins'
    }
    else if (!Function.prototype.bind) {
        isPhantom = 'phantom bind1'
    }
    else if (Function.prototype.bind.toString().replace(/bind/g, 'Error') != Error.toString()) {
        isPhantom = 'phantom bind2'
    }
    else if (Function.prototype.toString.toString().replace(/toString/g, 'Error') != Error.toString()) {
        isPhantom = 'phantom bind3'
    }
    // console.log("isPhantomJS ", isPhantom)
    return !!isPhantom
})

function _addElement (document, message) {
    try {
        const newDiv = document.createElement('div')
            , newContent = document.createTextNode(message)

        newDiv.appendChild(newContent)

        document.body.insertBefore(newDiv, document.body.firstChild)
    }
    finally { void 0 }
}

// Show a message in every possible place.
const spray = function () {
    if (!SPRAY) {
        return
    }
    const global = getGlobal()
        , args = Array.prototype.slice.call(arguments)
    if (global.document && global.document.body) {
        _addElement(global.document, args.join())
    }
    if (global.console && global.console.error) {
        global.console.error.apply(global.console, args)
    }
    if (global.alert) {
        alert.call(null, args.join())
    }
}

const ignoreCase = function (less, more) {
    return String(less).localeCompare(more
        , void 0
        , {
            numeric: true
            , sensitivity: 'accent'
        })
}

const splatter = function (logger) {
    const log = logger || spray
    log(displayName + '.isNode()', our.isNode())
    log(displayName + '.isBrowser()', our.isBrowser())
    log(displayName + '.isWebWorker()', our.isWebWorker())
    log(displayName + '.isPhantomjs()', our.isPhantomJS())
    log(displayName + '.isKarma()', our.isKarma())
    log(displayName + '.getGlobal()', Object.keys(our.getGlobal()).sort(ignoreCase))
}

const Env = {
    getGlobal: getGlobal
    , isBrowser: isBrowser
    , isWebWorker: isWebWorker
    , isNode: isNode
    , isPhantomJS: isPhantomJS
    , isKarma: isKarma
    , spray: spray
    , splatter: splatter
}

our = our || Env

if (typeof module === 'object' && module.exports) {
    module.exports = our
}

splatter()
