// FakeBrowser.js
// singleton access to a Fake browser for unit testing

'use strict'

// until our custom MockBrowser is submitted to the source repo
// we comment out the old code.
import mockBrowser from 'mock-browser'
//import MockBrowser from './MockBrowser'
import Browser from '../../src/es6/Browser'
import Konsole from '../../app/utils/Konsole'
import fetch from 'node-fetch'

const displayName = 'FakeBrowser'
    , DEBUG = false
    , konsole = Konsole.of({})
    , log = DEBUG ? console : konsole
    , MockBrowser = mockBrowser.mocks.MockBrowser
//    , theWindow = MockBrowser.createWindow()
    , theMockBrowser = new MockBrowser({
        /*        window: theWindow*/
    })

theMockBrowser.getPerformance = function () {
    /*dbg:*/ log.error(displayName + '.getPerformance()')
    return {
        now: function () {
            const now = Date.now() - 1464089764689
            return now
        }
    }
}

theMockBrowser.getFetcher = function () {
    /*dbg:*/ log.error(displayName + '.getFetcher()')
    return fetch
}

theMockBrowser.getConsole = function () {
    /*dbg:*/ log.error(displayName + '.getConsole()')
    return konsole
}

if (DEBUG) {
    /*dbg:*/ log.error(displayName + ' mockBrowser')
    /*dbg:*/ log.dir(mockBrowser, {depth: null}) // on node, deep log
    /*dbg:*/ log.error(displayName + ' theMockBrowser')
    /*dbg:*/ log.dir(theMockBrowser, {depth: null})
}

// Inject the mock browser into the Browser singleton
const FakeBrowser = Browser.getInstance(void 0, theMockBrowser)

if (DEBUG) {
    /*dbg:*/ log.error(displayName + ' theMockBrowser console is real?', console === theMockBrowser.getConsole())
    /*dbg:*/ log.error(displayName + ' console is real?', console === Browser.getInstance().getConsole())
}

// note, NOT returning FakeBrowser
export default Browser
