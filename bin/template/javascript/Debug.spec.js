// Debug.spec.js
// unit tests for dynamic debugging control

'use strict'

import { expect, sinon } from '../setupTests'

import Debug from '../../src/es6/Debug'
import FakeBrowserTestFactory from './factory/FakeBrowserTestFactory'

const component = 'Debug'
    , browserFactory = FakeBrowserTestFactory
    , getKonsole = browserFactory.getConsole

describe(component
    , () => {
        describe('module statics'
            , () => {
                it('should have a static _inherits property'
                    , () => {
                        expect(Debug._inherits)
                            .to.be.deep.equal([component])
                    })

                it('should have a static functional .of() constructor'
                    , () => {
                        expect(typeof Debug.of).to.be.equal('function')
                    })
            }) // module statics

        describe('_globalSearch'
            , () => {
                it('should read search param from document location'
                    , function (asyncDone) {
                        browserFactory.willMakeDocumentUrl(
                            'http://localhost:3000?this=that&debug=frank&apple'
                            , function (error) {
                                expect(error).to.be.equal(null)
                                expect(Debug._globalSearch())
                                    .to.be.equal('?this=that&debug=frank&apple')
                                expect(Debug.config)
                                    .to.be.equal('frank')
                                asyncDone()
                            }.bind(this))
                    })
            }) // _globalSearch

        describe('isDebug static property'
            , () => {
                beforeEach(function () {
                    this.stub = sinon.stub(
                        Debug
                        , '_globalSearch')
                })

                afterEach(function () {
                    if (this.stub) {
                        this.stub.restore()
                    }
                })

                it('should be false when no debug in url search term'
                    , function () {
                        this.stub.returns('?this=that&my=name')

                        const testMe = Debug.isDebug
                        expect(testMe).to.be.equal( false )
                    })

                it('should be false when debug=0 in url search term'
                    , function () {
                        this.stub.returns('?debug=0')

                        const testMe = Debug.isDebug
                        expect(testMe).to.be.equal( false )
                    })

                it('should be false when debug= in url search term'
                    , function () {
                        this.stub.returns('?debug=&this=that')

                        const testMe = Debug.isDebug
                        expect(testMe).to.be.equal( false )
                    })

                it('should be false when debug=false in url search term'
                    , function () {
                        this.stub.returns('?debug=false')

                        const testMe = Debug.isDebug
                        expect(testMe).to.be.equal( false )
                    })

                it('should be true when debug=42 in url search term'
                    , function () {
                        this.stub.returns('?debug=42')

                        const testMe = Debug.isDebug
                        expect(testMe).to.be.equal( true )
                    })

                it('should be true when debug=true in url search term'
                    , function () {
                        this.stub.returns('?debug=true')

                        const testMe = Debug.isDebug
                        expect(testMe).to.be.equal( true )
                    })

                it('should be true when debug=some,list in url search term'
                    , function () {
                        this.stub.returns('?debug=some,list')

                        const testMe = Debug.isDebug
                        expect(testMe).to.be.equal( true )
                    })
            }) // isDebug property

        describe('config static property'
            , () => {
                beforeEach(function () {
                    this.stub = sinon.stub(
                        Debug
                        , '_globalSearch')
                })

                afterEach(function () {
                    if (this.stub) {
                        this.stub.restore()
                    }
                })

                it('should be null if no debug config'
                    , function () {
                        this.stub.returns('?this=that')

                        const testMe = Debug.config
                        expect(testMe).to.be.equal( void 0 )
                    })

                it('should be null if no debug config'
                    , function () {
                        this.stub.returns('?debug=')

                        const testMe = Debug.config
                        expect(testMe).to.be.equal( void 0 )
                    })

                it('should be the debug setting string if one present'
                    , function () {
                        this.stub.returns('?debug=frank,channel')

                        const testMe = Debug.config
                        expect(testMe).to.be.equal( 'frank,channel' )
                    })
            }) // config()

        describe('static isDebugOn()'
            , () => {
                beforeEach(function () {
                    this.stub = sinon.stub(
                        Debug
                        , '_globalSearch')
                })

                afterEach(function () {
                    if (this.stub) {
                        this.stub.restore()
                    }
                })

                it('should be false if named channel not in debug string'
                    , function () {
                        this.stub.returns('?debug=frank')

                        const testMe = Debug.isDebugOn('channel')
                        expect(testMe).to.be.equal( false )
                    })

                it('should be true if named channel is in debug string'
                    , function () {
                        this.stub.returns('?debug=frank,channel')

                        const testMe = Debug.isDebugOn('channel')
                        expect(testMe).to.be.equal( true )
                    })
            }) // isDebugOn()

        describe('static traceChanges'
            , () => {
                beforeEach(function () {
                    const konsole = getKonsole()
                    this.stub = sinon.stub(konsole, 'debug')
                    this.watchMe = Debug.traceChanges(
                        {}
                        , 'peek'
                        , 42)
                })

                afterEach(function () {
                    if (this.stub) {
                        this.stub.restore()
                    }
                })

                it('should console.debug on property access'
                    , function () {
                        const see = this.watchMe.peek

                        expect(this.stub)
                            .to.have.callCount(1)
                        expect(this.stub)
                            .to.have.been.calledWith(
                                'property peek accessed = 42'
                                , { peek: 42})
                    })

                it('should console.debug on property change'
                    , function () {
                        this.watchMe.peek = 13

                        expect(this.stub)
                            .to.have.callCount(1)
                        expect(this.stub)
                            .to.have.been.calledWith(
                                'property peek changed from 42 to 13'
                                , { peek: 13 })
                    })
            }) // traceChanges

        describe('stringify'
            , () => {
                it('should stringify an object comma first'
                    , function () {
                        expect(Debug.stringify({ant: 1,bed: 2}))
                        .to.be.equal('{\n    ant: 1\n    , bed: 2\n}')
                    })
            }) // stringify
    }) // component
