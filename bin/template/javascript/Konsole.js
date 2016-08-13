// Konsole.js
// Ensure that there is a console object to log to supporting all known
// console methods in any javascript engine.

'use strict'

let our
const displayName = 'Konsole'
    , nativeConsole = ('undefined' === typeof console) ? {} : console
    , LOGGERS = [
        'count'
        , 'debug'
        , 'dir'
        , 'dirxml'
        , 'error'
        , 'group'
        , 'info'
        , 'profile'
        , 'profileEnd'
        , 'time'
        , 'timeEnd'
        , 'trace'
        , 'warn'
    ]
    , METHODS = [
        'clear'
        , 'groupCollapsed'
        , 'groupEnd'
        , 'timeStamp'
    ]
    , noop = function konsoleNoOp () { return void 0; }

function ensure (konsole, name, handler) {
    if (!(name in this)) {
        const method = konsole[name] || handler || noop
        this[name] = method.bind(konsole)
    }
}

function konsoleAssert () {
    if (arguments[0]) {
        this.error.apply(this, arguments)
    }
}

class Konsole {
    constructor (konsole = nativeConsole) {
        let idx

        ensure.call(this, konsole, 'log')
        ensure.call(this, konsole, 'assert', konsoleAssert)
        for (idx = 0; idx < METHODS.length; idx++) {
            ensure.call(this, konsole, METHODS[idx])
        }
        for (idx = 0; idx < LOGGERS.length; idx++) {
            ensure.call(this, konsole, LOGGERS[idx], this.log)
        }
        ensure.call(this, konsole, 'table', this.dir)
        ensure.call(this, konsole, '_exception', this.error)
    }

    get _native () {
        return nativeConsole
    }
}

our = our || Konsole

our.of = function (props) {
    return new Konsole(props)
}

export default our
