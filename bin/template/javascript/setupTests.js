// setupTests.js
// set up testing libraries for easy import to tests

// for example you can simply:
// import { expect, sinon } from 'setupTests';

'use strict'

import chai, { assert, expect } from 'chai'
import { shallow } from 'enzyme'
import sinon from 'sinon'
import sinonChai from 'sinon-chai'
import FakeAjax from './es6/FakeAjax' // MUSTDO remove...
import FakeFetcher from './es6/FakeFetcher'
import FakeBrowser from './es6/FakeBrowser'
import ValueMask from './es6/ValueMask'
import checkVisible from './es6/checkVisible'
import pickProps from './es6/util/pickProps' // MUSTDO move to es6
import setupClickMe from './es6/setupClickMe'
import util from 'util'

// https://github.com/domenic/sinon-chai
// http://sinonjs.org/docs/#assertions
// sinon-chai not ready for sinon 2 yet so attach nicer sinon asserts to
// chai's assert in the mean time so failures are easier to understand.
// though, I am using it so far without any problems. be prepared
// to convert expect(Stub).to.have.been.Assert(...)
// into assert.spyAssert(Stub,...) if there are issues.
sinon.assert.expose(assert, { prefix: 'spy' })

chai.use(sinonChai)

// fakeClock :: * →  FakeTimer
// Test plans default to date:
// Sun May 01 2016 00:00:00 GMT+0100 (BST)
const fakeClock = () => { return sinon.useFakeTimers(1462057200000) }

// deepLog :: string →  object →  *
const deepLog = function (name, object) {
    const showHidden = true
        , fullDepth = null
        , colorize = true
    if (typeof object === 'undefined') {
        object = name
        name = 'deepLog:'
    }
    console.error(name, util.inspect(object, showHidden, fullDepth, colorize))
}

// requireJson :: string → [a] | a
// synchronously load in JSON test data, supports arrays
// which require() does not. Note the path will be relative to the runtime
// directory, not the module required from.
const requireJson = function (jsonPath) {
    //    console.error('requireJson: ' + jsonPath + ' cwd: ' + process.cwd())
    const filesys = require('fs')
        , json = JSON.parse(filesys.readFileSync(jsonPath, 'utf8'))
    return json
}

// examineKeys :: string → [a] | a | [{ subkey: [a] | a }]→ [keys a]
// examine the keys of all objects in an array of things
const examineKeys = function (subKey, arrayOfThings) {
    const keys = {}

    if (Array.isArray(subKey)) {
        arrayOfThings = subKey
        subKey = 0
    }

    if (!Array.isArray(arrayOfThings)) {
        arrayOfThings = [arrayOfThings]
    }

    arrayOfThings.forEach(function (thing) {
        if (subKey) {
            thing = thing[subKey]
        }
        if (Array.isArray(thing)) {
            thing.forEach(function (subThing) {
                Object.assign(keys, subThing)
            })
        }
        else
        {
            Object.assign(keys, thing)
        }
    })

    return Object.keys(keys)
}

// MUSTDO failed attempt to get unit tests for mixpanel working.
// if (global && !('window' in global)) {
//     global.window = FakeBrowser.getInstance().getWindow()
//     global.document = FakeBrowser.getInstance().getDocument()
// }

export {
    chai
    , deepLog
    , sinon
    , fakeClock
    , assert
    , expect
    , shallow
    , FakeAjax
    , FakeFetcher
    , ValueMask
    , requireJson
    , examineKeys
    , checkVisible
    , pickProps
    , setupClickMe
}
