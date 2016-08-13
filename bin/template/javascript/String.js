// String.js
// string related utilities

'use strict'

import { curry } from 'ramda'

const ELLIPSIS = '…'

// shorten a string by eliding characters from the end of the string
// and substituting an ellipsis character
export const shorten = curry(function (maxLength, string) {
    if (maxLength !== null && maxLength !== void 0 && maxLength >= 0) {
        if (maxLength <= 1) {
            string = string.substring(0, maxLength)
        }
        if (string.length > maxLength) {
            string = string.substring(0, maxLength - 1)
                + ELLIPSIS
        }
    }
    return string
})

// ensure a string is either void 0 or a trimmed string
export const voidOrTrimmed = function (string) {
    string = string || void 0
    if (string) {
        string = string.trim()
        string = string.length <= 0 ? void 0 : string
    }
    return string
}

// ensure that void data is treated as an empty string
export const emptyIfVoid = function (string) {
    string = string || ''
    return string
}

// ensure something is a string or empty string if void data
export const stringify = function (string) {
    if (typeof string === 'number' || typeof string === 'boolean') {
        string = String(string)
    }
    string = string || ''
    return string
}

export function fullFileName (name, extension) {
    let fullName = emptyIfVoid(name)
    extension = emptyIfVoid(extension)
    if (extension.length) {
        fullName += '.' + extension
    }
    return fullName
}

export default {
    ELLIPSIS: ELLIPSIS
    , shorten: shorten
    , voidOrTrimmed: voidOrTrimmed
    , emptyIfVoid: emptyIfVoid
    , stringify: stringify
    , fullFileName: fullFileName
}
