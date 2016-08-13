// Browser.spec.js
// unit tests for the singleton browser

'use strict'

import { expect } from '../setupTests'

import mockBrowser from 'mock-browser'

import Browser from '../../src/es6/Browser'
import FakeBrowser from './FakeBrowser'

const component = 'Browser'
    , AbstractBrowser = mockBrowser.delegates.AbstractBrowser

function browserMethodNames () {
    const methods = [
        'getDocument'
        , 'getWindow'
        , 'getHistory'
        , 'getLocation'
        , 'getNavigator'
        , 'getLocalStorage'
        , 'getSessionStorage'
        , 'getPerformance'
        , 'getFetcher'
        , 'getConsole'
    ]

    return methods.sort()
}

describe(component
    , () => {
        it('should be a Browser constructor function'
            , () => {
                expect(Browser).to.be.an( 'function' )
            })

        it('should have singleton access method'
            , () => {
                expect(Browser.getInstance).to.be.an( 'function' )
            })
    })

describe('Fake' + component
    , () => {
        beforeEach(function () {
            this.browser = FakeBrowser.getInstance()
        })

        it('should equate to Browser'
            , () => {
                expect(FakeBrowser).to.equal(Browser)
            })

        it('should return the same instance every time'
            , function () {
                expect(FakeBrowser.getInstance()).to.equal(this.browser)
            })

        it('should get a mock browser with all getters'
            , function () {
                const _this = this
                const methods = browserMethodNames()

                expect(Object.keys(_this.browser).sort())
                        .to.be.deep.equal(methods)
            })

        it('should get a mock browser with proper interface'
            , function () {
                const _this = this
                const methods = browserMethodNames()

                methods.forEach(function (method) {
                    expect(_this.browser[method])
                        .to.be.an('function')
                })
            })

        it('should get access to the window'
            , function () {
                expect(this.browser.getWindow).to.be.an('function')
                expect(typeof this.browser.getWindow()).to.be.equal('object')
            })

        it('should be the same window object every time'
            , function () {
                const shades = this.browser.getWindow()
                    , curtains = this.browser.getWindow()

                shades._xyzzy = 'drawn'
                expect(shades).to.be.equal(curtains)
                expect(curtains._xyzzy).to.be.equal('drawn')
            })

        it('should have a console on the window'
            , function () {
                const shades = this.browser.getWindow()
                    , konsole = shades.console

                konsole.log('is this mocked - yes?') // sent to the abyss

                expect(typeof konsole).to.be.equal('object')
                expect(typeof konsole.log).to.be.equal('function')
            })

        // MUSTDO still unable to get this working
        // it('should have all console methods on the window'
        //     , function () {
        //         const shades = this.browser.getWindow
        //             , konsole = shades.console

        //         // MUSTDO use my konsole object or advise author of some missing console methods here...
        //         expect(typeof konsole.groupCollapsed).to.be.equal('function')
        //     })

        it('should get access to the document'
            , function () {
                expect(this.browser.getConsole).to.be.an('function')
                expect(typeof this.browser.getConsole()).to.be.equal('object')
            })

        it('should not be a real console in the test environment'
            , function () {
                const konsole = this.browser.getConsole()

                konsole.error('ERROR If you see this on the console it is not working')
                expect(konsole.error).to.not.be.equal(console.error)
            })

        it('should have all console methods from getConsole'
            , function () {
                const konsole = this.browser.getConsole()

                expect(typeof konsole.groupCollapsed).to.be.equal('function')
            })

        it('should get access to the document'
            , function () {
                expect(this.browser.getDocument).to.be.an('function')
                expect(typeof this.browser.getDocument()).to.be.equal('object')
            })

        it('should be the same location for document and window'
            , function () {
                const location = this.browser.getWindow().location
                    , location2 = this.browser.getDocument().location
                expect(location).to.be.equal(location2)
            })

        it('should get same document every time'
            , function () {
                const doc1 = this.browser.getDocument()
                    , doc2 = this.browser.getDocument()
                expect(doc2).to.be.equal(doc1)
            })

        it('should have default document location'
            , function () {
                const doc = this.browser.getDocument()
                expect(doc.location.protocol).to.be.equal('about:')
            })

        it('should get access to the fetcher api'
            , function () {
                expect(this.browser.getFetcher).to.be.an('function')
                expect(this.browser.getFetcher()).to.be.an('function')
            })

        it('should get access to the performance api'
            , function () {
                expect(this.browser.getPerformance).to.be.an('function')
                expect(this.browser.getPerformance().now).to.be.an('function')
            })

        it('should get access to the history'
            , function () {
                expect(this.browser.getHistory).to.be.an('function')
                expect(this.browser.getHistory()).to.be.an('object')
            })

        it('should get access to the location'
            , function () {
                expect(this.browser.getLocation).to.be.an('function')
                expect(this.browser.getLocation().valueOf).to.be.an('function')
            })

        it('should get access to the navigator'
            , function () {
                expect(this.browser.getNavigator).to.be.an('function')
                expect(this.browser.getNavigator().userAgent).to.be.an('string')
            })

        it('should get access to the localStorage'
            , function () {
                expect(this.browser.getSessionStorage).to.be.an('function')
                expect(this.browser.getSessionStorage().setItem).to.be.an('function')
            })

        it('should get access to the sessionStorage'
            , function () {
                expect(this.browser.getLocalStorage).to.be.an('function')
                expect(this.browser.getLocalStorage().setItem).to.be.an('function')
            })
    })
