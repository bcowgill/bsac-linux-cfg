/*
    ErrorHandler.js

    attach an error event listener to deal with any uncaught exceptions

    http://www.sitepoint.com/proper-error-handling-javascript/?utm_source=javascriptweekly&utm_medium=email

    This module will post to /logError for any unhandled errors.
    You can handle this on the server with the equivalent of:

    const bodyParser = require('body-parser');
    app.use(bodyParser.text({ type: 'text/plain' }))
    app.post('/logError'
        , function (request, response) {
            console.log('/logError', request.body);
    });
*/

'use strict'

import Browser from './Browser'
import { byLocale } from './Util'

let our
    , versionInfo
    , onErrorCallMe

const displayName = 'ErrorHandler'
    , dependency = {}
    , browser = Browser.getInstance()
, ErrorHandler = {

    POST_URL: '/api/log'

    , NAV_KEYS: [
        'appName'
        , 'appCodeName'
        , 'appVersion'
        , 'cookieEnabled'
        , 'language'
        , 'userLanguage' // IE
        , 'browserLanguage' // IE
        , 'systemLanguage' // IE
        , 'platform'
        , 'product'
        , 'productSub'
        , 'userAgent'
        , 'vendor'
        , 'vendorSub'
        , 'onLine'
        // , 'plugins' // too much info than needed
        // , 'mimeTypes'
        , 'doNotTrack'
    ]

    , ERROR_EVENT_KEYS: [
        'type'
        , 'message'
        , 'lineno'
        , 'colno'
        , 'filename'
        , 'error'
        , 'timestamp'
    ]

    , ERROR_EVENT_ERROR_KEYS: [
        'lineNumber'
        , 'columnNumber'
        , 'fileName'
        , 'message'
        , 'stack'
    ]

    , installHandlers: function () {
        this.logger()
        this.backEndLogger()
        return this
    }

    , logger: function () {
        this._globalWindow().addEventListener('error'
            , our._logError)
    }

    , backEndLogger: function () {
        if (this._globalProtocol() !== 'file:') {
            this._globalWindow().addEventListener('error'
                , our._logErrorBackEnd)
        }
    }

    , getVersionInfo: function () {
        return versionInfo ? JSON.stringify(versionInfo) : void 0
    }

    , setVersionInfo: function (versionObject) {
        versionInfo = versionObject
    }

    , setErrorListener: function (fnCallback) {
        onErrorCallMe = fnCallback
        return this
    }

    , getType: function (thing) {
        let type = typeof thing
        if (thing === null) {
            return 'null'
        }
        // handle [object RegExp]
        if (type === 'object') {
            type = Object.prototype.toString.call(thing)
                .replace('[object '
                    , '').replace(']'
                    , '')
        }
        else if (type === 'function') {
            // handle variants of function Named(...) { [native code] }
            const signature = thing.toString()
            if (/\[native code\]/.test(signature)) {
                type += ' native'
            }
            const name = signature
                  .replace(/\n/g
                      , ' ')
                  .replace(/\(.+$/
                      , '')
                  .replace(/\bfunction /
                      , '')
            if (name.length) {
                type += ' ' + name
            }
        }
        return type
    }

    , logObject: function (message, object, keys) {
        const konsole = our._globalConsole()
            , logObject = our.getLoggableObject(object, keys)
        konsole.log(message + ' ' + object)
        konsole.log(message + ' ' + JSON.stringify(logObject))
    }

    , getLoggableObject: function (object, keys) {
        let logObject = object
        if (keys) {
            logObject = {}
            for (let idx = 0; idx < keys.length; idx++) {
                const key = keys[idx]
                logObject[key] = object[key]
            }
        }
        return logObject
    }

    , getLoggableObjectApi: function (object, keys) {
        const logObject = {}
        let loopKeys = keys ? keys.sort(byLocale) : Object.keys(object).sort(byLocale)
        for (let idx = 0; idx < loopKeys.length; idx++) {
            const key = loopKeys[idx]
            logObject[key] = our.getType(object[key])
        }
        return logObject
    }

    , logNavigator: function (message = 'navigator', navObj, keys = our.NAV_KEYS) {
        navObj = this._globalNavigator(navObj)
        our.logObjectBackEnd(message, navObj, keys)
    }

    , logArrayBackEnd: function (message, array) {
        const konsole = our._globalConsole()
            , stringified = JSON.stringify(array)
        our.logBackEnd(message + ' ' + stringified
            , 'debug')
        konsole.log(message + ' ' + stringified)
    }

    , logObjectBackEnd: function (message, object, keys) {
        const konsole = our._globalConsole()
            , logObject = our.getLoggableObject(object, keys)
            , stringified = JSON.stringify(logObject)
        our.logBackEnd(
            message + ' ' + object + '\n' + stringified
            , 'debug')
        konsole.log(message + ' ' + object)
        konsole.log(message + ' ' + stringified)
    }

    , logObjectApiBackEnd: function (message, object, keys) {
        const konsole = our._globalConsole()
            , logObject = our.getLoggableObjectApi(object, keys)
            , stringified = JSON.stringify(logObject)
        our.logBackEnd(
            message + ' Api ' + stringified
            , 'debug')
        konsole.log(message + ' Api ' + stringified)
    }

    , logBackEnd: function (message, level = 'error') {
        const fetch = this._globalFetcher()
        return fetch(our.POST_URL, {
            method: 'POST'
            , headers: {
                'Content-Type': 'application/json'
            }
            , body: JSON.stringify({ message: message, level: 'debug' })
        })
    }

    , _logError: function (errorEvent) {
        const konsole = our._globalConsole()
        konsole.log(our._formatErrorEventLogMessage(errorEvent), errorEvent)
        if (onErrorCallMe) {
            onErrorCallMe(errorEvent)
        }
    }

    , _logErrorBackEnd: function (errorEvent, navObj) {
        // our.logObjectBackEnd('errorEvent natural', errorEvent);
        // our.logObjectBackEnd('errorEvent keys', errorEvent, our.ERROR_EVENT_KEYS);
        // if (errorEvent.error) {
        //     our.logObjectBackEnd(
        //         'errorEvent.error natural'
        //         , errorEvent.error);
        //     our.logObjectBackEnd(
        //         'errorEvent.error keys'
        //         , errorEvent.error
        //         , our.ERROR_EVENT_ERROR_KEYS);
        // }
        const message = our._formatErrorEventLogMessageWithStack(errorEvent, navObj)
        our.logBackEnd(message)
    }

    , _formatErrorEventLogMessageWithStack: function (errorEvent, navObj) {
        let message = our._formatErrorEventLogMessage(
            errorEvent
            , '[Browser Error]')
            + our._formatVersionInfo()
            + '\n' + our._formatBrowserIdentity(navObj)
        if (errorEvent.error) {
            message += '\n' + errorEvent.error.stack
        }
        return message
    }

    , _formatVersionInfo: function () {
        let message = ''
        if (our.getVersionInfo()) {
            message += '\nApp Version Info: ' + our.getVersionInfo()
        }
        return message
    }

    , _formatErrorEventLogMessage: function (errorEvent, prefix) {
        const message = [
            prefix || (`${displayName}:`)
            , errorEvent.type
            , errorEvent.timestamp
            , errorEvent.message
            , our._getErrorLocation(errorEvent)
        ].join(' ')
        return message + ' '
    }

    , _formatBrowserIdentity: function (navObj) {
        navObj = this._globalNavigator(navObj)
        let message = [
            (navObj.cookieEnabled ? 'cookies' : '!cookies')
            , our._getLanguage(navObj)
            , navObj.platform
            , navObj.vendor
            , navObj.vendorSub
            , navObj.product
            , navObj.productSub
            , navObj.appName
            , navObj.appCodeName
        ].join(' | ')
        message += '\n' + navObj.userAgent + '\n' + navObj.appVersion
        return message
    }

    , _getLanguage: function (navObj) {
        navObj = our._globalNavigator(navObj)
        const languages = []
        if (navObj.language) {
            languages.push(navObj.language)
        }
        if (navObj.languages) {
            navObj.languages.forEach(function (language) {
                languages.push(language)
            })
        }
        if (navObj.userLanguage) {
            languages.push(navObj.userLanguage)
        }
        if (navObj.browserLanguage) {
            languages.push(navObj.browserLanguage)
        }
        if (navObj.userLanguage) {
            languages.push(navObj.systemLanguage)
        }
        return languages.join(',')
    }

    , _getErrorLocation: function (errorEvent) {
        let location = ''
        if (errorEvent.filename.length) {
            location = errorEvent.filename
                + ':' + errorEvent.lineno
                + ':' + errorEvent.colno
        }
        return location
    }

    , _inherits: [displayName]

    // Browser Dependency accessors
    , _globalWindow: function () {
        return Browser.getInstance().getWindow()
    }

    , _globalProtocol: function () {
        return Browser.getInstance().getLocation().protocol
    }

    , _globalConsole: function () {
        return our._globalWindow().console
    }

    , _globalNavigator: function (navObj) {
        return navObj || Browser.getInstance().getNavigator()
    }

    , _globalFetcher: function () {
        const fetch = Browser.getInstance().getFetcher()
        return fetch
    }

}

our = our || ErrorHandler

export default our
