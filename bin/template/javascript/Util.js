// Util.js
// Utility methods for the app

'use strict'

import { curry, reduce, reduced } from 'ramda'

// hideProperty :: { k: v } → string → * → { k: v }
// make a hidden constant property on an object
export function hideProperty (object, name, value) {
    let options = hideProperty.options
        || (hideProperty.options = {
            configurable: false
            , enuymerable: false
            , writable: false
            , value: null
        })
    options.value = value
    return Object.defineProperty(object
        , name
        , options)
}

// readOnly :: { k: v } → string → * → { k: v }
// make a constant property on an object
export function readOnly (object, name, value) {
    let options = readOnly.options
        || (readOnly.options = {
            configurable: false
            , enumerable: true
            //            , writable: false
            //            , get: null
        })
    options.get = function () { return value }
    return Object.defineProperty(object
        , name
        , options)
}

// format time like 2mo ago or 1d ago
export function timeAgoFormatter (value, unit, suffix) {
    unit = (/^month/.test(unit)) ? 'mo' : unit[0]
    return String(value) + unit + ' ' + suffix
}

// a sorting callback to sort by number
export function byNumber (less, more) {
    return less - more
}

// a sorting callback to sort by locale, ignores case differences
// and number order is numeric
export function byLocale (less, more) {
    return String(less).localeCompare(more
        , void 0
        , {
            numeric: true
            , sensitivity: 'accent'
        })
}

// anyMatchInObject :: [a] → { a: * } → boolean
export const anyMatchInObject = curry(function (list, object) {
    return reduce((unused, key) => {
        return object[key] ? reduced(true) : false
    }
    , false
, list)
})

// allMatchInObject :: [a] → { a: * } → boolean
export const allMatchInObject = curry(function (list, object) {
    function ignoreNilKeys (key) {
        return key ? reduced(false) : true
    }
    return reduce((unused, key) => {
        return object[key] ? true : ignoreNilKeys(key)
    }
    , false
, list)
})

export default {
    hideProperty: hideProperty
    , readOnly: readOnly
    , timeAgoFormatter: timeAgoFormatter
    , byNumber: byNumber
    , byLocale: byLocale
    , anyMatchInObject: anyMatchInObject
    , allMatchInObject: allMatchInObject
}
