// Browser.js
// singleton access to the Browser for all application or testing needs

'use strict'

import AbstractBrowser from 'mock-browser/lib/AbstractBrowser'
import Konsole from '../../app/utils/Konsole'
import MarkObject from './MarkObject'

let instance
    , theOneTrueInstance
    , decorateBrowser

const displayName = 'Browser'
    , DEBUG = false
    , isTest = process.env.NODE_ENV !== 'production'
    , log = DEBUG ? console.error.bind(console) : function () {}
    , Browser = function (options = {}) {
        /*dbg:*/ log(displayName + '() options', options)
        this._inherits = [displayName, 'AbstractBrowser']
        MarkObject.mark(this)
        /*dbg:*/ log(displayName + '.constructor()', this)

        AbstractBrowser.extend(this, options)

        // ensure console has all known methods
        const win = this.getWindow()
        /*dbg:*/ log(displayName + ' window', Object.keys(win))

        const konsole = win.console
        win.console = Konsole.of(konsole)
        /*dbg:*/ log(displayName + ' window.console augmented', Object.keys(win.console))
    }

Browser.getInstance = function (options, mockBrowser) {
    /*dbg:*/ log(displayName + '.getInstance()', arguments)

    if (mockBrowser) {
        MarkObject.mark(mockBrowser)
        /*dbg:*/ log(displayName + '.getInstance() from mock', mockBrowser.__, mockBrowser.getWindow().location.href)
        instance = decorateBrowser(mockBrowser)
    }

    if (!instance) {
        /*dbg:*/ log(displayName + '.getInstance() create instance from window/options', options)
        instance = decorateBrowser(new Browser(options))
    }

    MarkObject.mark(instance)
    if (!theOneTrueInstance) {
        theOneTrueInstance = instance
    }

    /*dbg:*/ log(displayName + '.getInstance() out', instance.__, instance.getWindow().location.href)
    return instance
}

decorateBrowser = function (thisInstance) {
    /*dbg:*/ log(displayName + '.decorateBrowser()', Object.keys(thisInstance))
    thisInstance.getFetcher = thisInstance.getFetcher || function () {
        /*dbg:*/ log(displayName + '.getFetcher()')
        return this.getWindow().fetch
    }
    thisInstance.getPerformance = thisInstance.getPerformance || function () {
        /*dbg:*/ log(displayName + '.getPerformance()')
        return this.getWindow().performance
    }
    thisInstance.getConsole = thisInstance.getConsole || function () {
        /*dbg:*/ log(displayName + '.getConsole()')
        return this.getWindow().console
    }
    log(displayName + '.decorateBrowser() out', Object.keys(thisInstance))
    return thisInstance
}

Browser.resetInstance = function () {
    /*dbg:*/ log(displayName + '.resetInstance()')
    instance = theOneTrueInstance
    log(displayName + '.resetInstance() out', instance.__, instance.getWindow().location.href)
}

if (!isTest) {
    Browser.resetInstance = function () {
        // MUSTDO choose better error type?
        throw new Error(
            displayName + ' not allowed to reset instance in production')
    }
}

export default Browser
