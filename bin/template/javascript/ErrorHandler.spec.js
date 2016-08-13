// ErrorHandler.spec.js

'use strict'

import { expect, sinon, assert, FakeAjax, ValueMask } from '../setupTests'

import Browser from './FakeBrowser'
import ErrorHandler from '../../src/es6/ErrorHandler'
import ErrorHandlerTestFactory from './factory/ErrorHandlerTestFactory'
import NavigatorTestFactory from './factory/NavigatorTestFactory'
import FakeBrowserTestFactory from './factory/FakeBrowserTestFactory'

const object = 'ErrorHandler'
    , logger = 'con' + 'sole'
    , browser = Browser.getInstance()
    , errFactory = ErrorHandlerTestFactory
    , navFactory = NavigatorTestFactory
    , browserFactory = FakeBrowserTestFactory
    , getKonsole = browserFactory.getConsole

function restoreStubs () {
    if (this.stub) {
        this.stub.restore()
        this.stub = void 0
    }
    if (this.stub2) {
        this.stub2.restore()
        this.stub2 = void 0
    }
    Browser.resetInstance()
}

describe(object + ' unit tests'
    , () => {
        beforeEach(function () {
            this.xhr = new FakeAjax()
        })

        afterEach(function () {
            restoreStubs.call(this)
            if (this.xhr) {
                this.xhr.restore()
            }
        })

        describe('POST_URL'
            , () => {
                it('should have default url to post to'
                    , () => {
                        expect(ErrorHandler.POST_URL).to.be.equal('/api/log')
                    })
            })

        describe('installHandlers'
            , () => {
                beforeEach(function () {
                    this.stub = sinon.stub(ErrorHandler, 'logger')
                    this.stub2 = sinon.stub(ErrorHandler, 'backEndLogger')
                })

                afterEach(restoreStubs)

                it('should install both ' + logger + ' and back end loggers'
                    , function () {
                        ErrorHandler.installHandlers()
                        expect(this.stub).to.have.callCount(1)
                        expect(this.stub2).to.have.callCount(1)
                    })
            })

        describe('setVersionInfo'
            , () => {
                afterEach(function () {
                    ErrorHandler.setVersionInfo()
                })

                it('should initially have no version information'
                    , function () {
                        expect(ErrorHandler.getVersionInfo())
                            .to.be.equal(void 0)
                    })

                it('should set version information'
                    , function () {
                        const version = { version: 42 }

                        ErrorHandler.setVersionInfo(version)
                        expect(ErrorHandler.getVersionInfo())
                            .to.be.equal(JSON.stringify(version))
                    })
            })

        describe('logger'
            , () => {
                beforeEach(function () {
                    const window = Browser.getInstance().getWindow()
                    this.stub = sinon.stub(window, 'addEventListener')
                })

                afterEach(restoreStubs)

                it('should register a window event listener to log uncaught errors'
                   , function () {
                       ErrorHandler.logger()
                       expect(this.stub).to.have.callCount(1)
                       expect(this.stub).to.have.been.calledWith(
                           'error'
                           , ErrorHandler._logError
                       )
                   })
            })

        describe('backEndLogger'
            , () => {
                afterEach(restoreStubs)

                it('should register a window event listener for non-file protocols'
                   , function (asyncDone) {
                       browserFactory.willMakeDocumentProtocolHttp(function (error) {
                           expect(error).to.be.equal(null)

                           const window = Browser.getInstance().getWindow()
                           this.stub = sinon.stub(window, 'addEventListener')
                           expect(window.document.location.protocol)
                               .to.be.equal('http:')

                           ErrorHandler.backEndLogger()

                           expect(this.stub).to.have.callCount(1)
                           expect(this.stub).to.have.been.calledWith(
                               'error'
                               , ErrorHandler._logErrorBackEnd
                           )
                           asyncDone()
                       }.bind(this))
                   })

                it('should not register a window event listener for file protocol'
                   , function (asyncDone) {

                       browserFactory.willMakeDocumentProtocolFile(function (error) {
                           expect(error).to.be.equal(null)
                           const window = Browser.getInstance().getWindow()
                           this.stub = sinon.stub(window, 'addEventListener')
                           expect(window.document.location.protocol)
                               .to.be.equal('file:')

                           ErrorHandler.backEndLogger()

                           expect(this.stub).to.have.callCount(0)
                           asyncDone()
                       }.bind(this))
                   })
            })

        describe('getType'
            , () => {
                it('should return undefined'
                    , () => {
                        expect(ErrorHandler.getType())
                            .to.be.equal('undefined')
                    })

                it('should return null'
                    , () => {
                        expect(ErrorHandler.getType(null))
                            .to.be.equal('null')
                    })

                it('should return number for NaN'
                    , () => {
                        expect(ErrorHandler.getType(NaN))
                            .to.be.equal('number')
                    })

                it('should return number for Infinity'
                    , () => {
                        expect(ErrorHandler.getType(Infinity))
                            .to.be.equal('number')
                    })

                it('should return number'
                    , () => {
                        expect(ErrorHandler.getType(42))
                            .to.be.equal('number')
                    })

                it('should return Array'
                    , () => {
                        expect(ErrorHandler.getType([42]))
                            .to.be.equal('Array')
                    })

                it('should return Object'
                    , () => {
                        expect(ErrorHandler.getType({what: 42}))
                            .to.be.equal('Object')
                    })

                it('should return regex'
                    , () => {
                        expect(ErrorHandler.getType(/search/g))
                            .to.be.equal('RegExp')
                    })

                it('should return function'
                    , () => {
                        expect(ErrorHandler.getType(function () {}))
                            .to.be.equal('function')
                    })

                it('should return function with name'
                    , () => {
                        function getMe () {}
                        expect(ErrorHandler.getType(getMe))
                            .to.be.equal('function getMe')
                    })

                it('should return native function'
                    , () => {
                        expect(ErrorHandler.getType(console.error))
                            .to.be.equal('function native')
                    })

                it('should return native function with name'
                    , () => {
                        expect(ErrorHandler.getType(String))
                            .to.be.equal('function native String')
                    })

                it('should return Arguments'
                    , () => {
                        expect(ErrorHandler.getType(arguments))
                            .to.be.equal('Arguments')
                    })

                it('should return native function with name'
                    , () => {
                        expect(ErrorHandler.getType(String(42)))
                            .to.be.equal('string')
                    })
            })

        describe('logObject'
            , () => {
                beforeEach(function () {
                    const konsole = getKonsole()
                    this.stub = sinon.stub(konsole, 'log')
                    this.stub2 = sinon.stub(ErrorHandler, 'logBackEnd')
                })

                afterEach(restoreStubs)

                it('should log an object to the ' + logger + ' only'
                    , function () {
                        ErrorHandler.logObject('message', { object: true })

                        expect(this.stub).to.have.callCount(2)
                        expect(this.stub2).to.have.callCount(0)
                    })

                it('should log the object first, natively to show type'
                    , function () {
                        ErrorHandler.logObject('message', { object: true }, ['absent'])

                        expect(this.stub)
                            .to.have.been.calledWith('message [object Object]')
                    })

                it('should log the object second, by selected keys for non-enumerable properties'
                    , function () {
                        ErrorHandler.logObject('message', { object: true, number: 4 }, ['absent', 'object'])

                        expect(this.stub)
                            .to.have.been.calledWith('message {"object":true}')
                    })
            })

        describe('getLoggableObject'
            , () => {
                it('should return the object itself if no keys provided'
                    , () => {
                        const logMe = {one: 1, two: '2' }

                        expect(ErrorHandler.getLoggableObject(logMe))
                            .to.be.equal(logMe)
                    })

                it('should return the specific keys from the object'
                    , () => {
                        const logMe = {one: 1, two: '2', three: 'troi' }
                            , keys = ['three']

                        expect(ErrorHandler.getLoggableObject(logMe, keys))
                            .to.deep.equal({ three: 'troi' })
                    })
            })

        describe('getLoggableObjectApi'
            , () => {
                it('should return api for enumerable keys of object'
                    , () => {
                        const logMe = {one: 1, two: '2', bool: true, regex: /search/g }
                            , logMeApi = {one: 'number', two: 'string', bool: 'boolean', regex: 'RegExp' }

                        expect(ErrorHandler.getLoggableObjectApi(logMe))
                            .to.deep.equal(logMeApi)
                    })

                it('should return the api for specific keys from the object'
                    , () => {
                        const logMe = {one: 1, two: '2', three: 'troi' }
                            , keys = ['three', 'toString']
                            , logMeApi = {three: 'string', toString: 'function native toString' }

                        expect(ErrorHandler.getLoggableObjectApi(logMe, keys))
                            .to.deep.equal(logMeApi)
                    })
            })

        describe('logArrayBackEnd'
            , () => {
                beforeEach(function () {
                    const konsole = getKonsole()
                    this.stub = sinon.stub(konsole, 'log')
                    this.stub2 = sinon.stub(ErrorHandler, 'logBackEnd')
                })

                afterEach(restoreStubs)

                it('should log an array to the ' + logger + ' and back end'
                    , function () {
                        ErrorHandler.logArrayBackEnd('message', ['object', true])

                        expect(this.stub).to.have.callCount(1)
                        expect(this.stub2).to.have.callCount(1)
                    })

                it('should ' + logger + ' log the array, as JSON stringify'
                    , function () {
                        ErrorHandler.logArrayBackEnd('message', ['object', true])

                        expect(this.stub)
                            .to.have.been.calledWith('message ["object",true]')
                    })

                it('should back end log the array as JSON stringify'
                    , function () {
                        ErrorHandler.logArrayBackEnd('message', ['object', true, 'number', 4])

                        expect(this.stub2)
                            .to.have.been.calledWith('message ["object",true,"number",4]')
                    })
            })

        describe('logObjectBackEnd'
            , () => {
                beforeEach(function () {
                    const konsole = getKonsole()
                    this.stub = sinon.stub(konsole, 'log')
                    this.stub2 = sinon.stub(ErrorHandler, 'logBackEnd')
                })

                afterEach(restoreStubs)

                it('should log an object to the ' + logger + ' and back end'
                    , function () {
                        ErrorHandler.logObjectBackEnd('message', { object: true })

                        expect(this.stub).to.have.callCount(2)
                        expect(this.stub2).to.have.callCount(1)
                    })

                it('should ' + logger + ' log the object first, natively to show type'
                    , function () {
                        ErrorHandler.logObjectBackEnd('message', { object: true }, ['absent'])

                        expect(this.stub)
                            .to.have.been.calledWith('message [object Object]')
                    })

                it('should ' + logger + ' log the object second, by selected keys for non-enumerable properties'
                    , function () {
                        ErrorHandler.logObjectBackEnd('message', { object: true, number: 4 }, ['absent', 'object'])

                        expect(this.stub)
                            .to.have.been.calledWith('message {"object":true}')
                    })

                it('should back end log the object natively and by keys'
                    , function () {
                        ErrorHandler.logObjectBackEnd('message', { object: true, number: 4 }, ['absent', 'object'])

                        expect(this.stub2)
                            .to.have.been.calledWith('message [object Object]\n{"object":true}')
                    })
            })

        describe('logObjectApiBackEnd'
            , () => {
                beforeEach(function () {
                    const konsole = getKonsole()
                    this.stub = sinon.stub(konsole, 'log')
                    this.stub2 = sinon.stub(ErrorHandler, 'logBackEnd')
                })

                afterEach(restoreStubs)

                it('should log an object api to the ' + logger + ' and back end'
                    , function () {
                        ErrorHandler.logObjectApiBackEnd('message', { object: true })

                        expect(this.stub).to.have.callCount(1)
                        expect(this.stub2).to.have.callCount(1)
                    })

                it('should ' + logger + ' log the object api, to show data types'
                    , function () {
                        ErrorHandler.logObjectApiBackEnd(
                            'message'
                            , { object: true }
                            , ['absent', 'toString'])

                        expect(this.stub)
                            .to.have.been.calledWith(
                                'message Api {"absent":"undefined",'
                                + '"toString":"function native toString"}')
                    })

                it('should back end log the object api'
                    , function () {
                        ErrorHandler.logObjectApiBackEnd(
                            'message'
                            , { object: true, number: 4 }
                            , ['absent', 'object'])

                        expect(this.stub2)
                            .to.have.been.calledWith(
                                'message Api {"absent":"undefined",'
                                + '"object":"boolean"}')
                    })
            })

        describe('logNavigator'
            , () => {
                beforeEach(function () {
                    const konsole = getKonsole()
                    this.stub = sinon.stub(konsole, 'log')
                    this.stub2 = sinon.stub(ErrorHandler, 'logBackEnd')
                })

                afterEach(restoreStubs)

                it('should log the navigator object to the back end with default selected keys'
                    , function () {
                        const mockNavigator = navFactory.makeNavigator()

                        ErrorHandler.logNavigator(void 0, mockNavigator)

                        expect(this.stub2)
                            .to.have.been.calledWith(
                                'navigator [object Object]'
                                    + '\n{"appName":"Browser","appCodeName":'
                                    + '"acn","appVersion":"1.0",'
                                    + '"cookieEnabled":true,"language":'
                                    + '"en-GB","platform":"OS","product":'
                                    + '"p","productSub":"ps","userAgent":'
                                    + '"UA","vendor":"v","vendorSub":"vs"}')
                    })

                it('should log the navigator object to the back end with specified keys'
                    , function () {
                        const mockNavigator = navFactory.makeNavigator()

                        ErrorHandler.logNavigator('mymessage', mockNavigator, ['appName', 'cookieEnabled', 'absent'])

                        expect(this.stub2)
                            .to.have.been.calledWith(
                                'mymessage [object Object]'
                                + '\n{"appName":"Browser","cookieEnabled":true}')
                    })
            })

        describe('_getErrorLocation'
            , () => {
                it('should get location from Safari error'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromSafari()
                        expect(ErrorHandler._getErrorLocation(errorEvent))
                            .to.be.equal('http://10.40.3.11:3000/dist/docuzilla.js:84:37')
                    })

                it('should get location from Chrome error (which has none)'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromChrome()
                        expect(ErrorHandler._getErrorLocation(errorEvent))
                            .to.be.equal('')
                    })

                it('should get location from Chrome error (which has none)'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromChrome()
                        expect(ErrorHandler._getErrorLocation(errorEvent))
                            .to.be.equal('')
                    })

                it('should get location from Firefox error'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromFireFox()
                        expect(ErrorHandler._getErrorLocation(errorEvent))
                            .to.be.equal('file:///docuzilla.js:63:8')
                    })

                it('should get location from IE error'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromIE()
                        expect(ErrorHandler._getErrorLocation(errorEvent))
                            .to.be.equal('file:///docuzilla.js:63:8')
                    })
            })

        describe('_getLanguage'
            , () => {
                it('should get language from Safari browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromSafari()
                        expect(ErrorHandler._getLanguage(mockNavigator))
                            .to.be.equal('en-us')
                    })

                it('should get language from Chrome browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromChrome()
                        expect(ErrorHandler._getLanguage(mockNavigator))
                            .to.be.equal('en-GB')
                    })

                it('should get language from FireFox browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromFireFox()
                        expect(ErrorHandler._getLanguage(mockNavigator))
                            .to.be.equal('en-GB')
                    })

                it('should get language from IE9 browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromIE9()
                        expect(ErrorHandler._getLanguage(mockNavigator))
                            .to.be.equal('en-us,en-us,en-gb')
                    })

                it('should get language from IE10 browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromIE10()
                        expect(ErrorHandler._getLanguage(mockNavigator))
                            .to.be.equal('en-GB,en-US,en-GB')
                    })

                it('should get language from IE11 browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromIE11()
                        expect(ErrorHandler._getLanguage(mockNavigator))
                            .to.be.equal('en-GB,en-GB,en-US,en-GB')
                    })

                it('should get language from current browser navigator'
                    , () => {
                        expect(ErrorHandler._getLanguage())
                            .to.equal('')
                    })
            })

        describe('_formatBrowserIdentity'
            , () => {
                it('should format browser identity string from Safari browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromSafari()
                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatBrowserIdentity(mockNavigator))
                            .to.be.equal('cookies | en-us | MacIntel | Apple Computer, Inc. |  | Gecko | 20030107 | Netscape | Mozilla'
                                + '\nMozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17'
                                + '\n5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17')
                        //jscs:enable maximumLineLength
                    })

                it('should format browser identity string from Chrome browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromChrome()
                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatBrowserIdentity(mockNavigator))
                            .to.be.equal('cookies | en-GB | Linux x86_64 | Google Inc. |  | Gecko | 20030107 | Netscape | Mozilla'
                                + '\nMozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36'
                                + '\n5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36')
                        //jscs:enable maximumLineLength
                    })

                it('should format browser identity string from FireFox browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromFireFox()
                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatBrowserIdentity(mockNavigator))
                            .to.be.equal('cookies | en-GB | Linux x86_64 |  |  | Gecko | 20100101 | Netscape | Mozilla'
                                + '\nMozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:43.0) Gecko/20100101 Firefox/43.0'
                                + '\n5.0 (X11)')
                        //jscs:enable maximumLineLength
                    })

                it('should format browser identity string from IE9 browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromIE9()
                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatBrowserIdentity(mockNavigator))
                            .to.be.equal('cookies | en-us,en-us,en-gb | Win32 |  |  |  |  | Microsoft Internet Explorer | Mozilla'
                                + '\nMozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)'
                                + '\n5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)')
                        //jscs:enable maximumLineLength
                    })

                it('should format browser identity string from IE10 browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromIE10()
                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatBrowserIdentity(mockNavigator))
                            .to.be.equal('cookies | en-GB,en-US,en-GB | Win32 |  |  |  |  | Microsoft Internet Explorer | Mozilla'
                                + '\nMozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)'
                                + '\n5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)')
                        //jscs:enable maximumLineLength
                    })

                it('should format browser identity string from IE11 browser'
                    , () => {
                        const mockNavigator = navFactory.makeNavigatorFromIE11()
                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatBrowserIdentity(mockNavigator))
                            .to.be.equal('cookies | en-GB,en-GB,en-US,en-GB | Win32 |  |  | Gecko |  | Netscape | Mozilla'
                                + '\nMozilla/5.0 (Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; rv: 11.0) like Gecko'
                                + '\n5.0 (Windows NT 6.1; Trident/7.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; rv: 11.0) like Gecko')
                        //jscs:enable maximumLineLength
                    })

                it('should format browser identity string from current browser navigator'
                    , () => {
                        expect(ErrorHandler._formatBrowserIdentity())
                            .to.match(/^cookies \|/)
                    })
            })

        describe('_formatErrorEventLogMessage'
            , () => {
                it('should format log message for errorEvent using default prefix'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromFireFox()
                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatErrorEventLogMessage(errorEvent))
                            .to.be.equal('ErrorHandler: error 1461328707443 Error: test the handler. file:///docuzilla.js:63:8 ')
                        //jscs:enable maximumLineLength
                    })

                it('should format log message for errorEvent given a prefix'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromFireFox()

                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatErrorEventLogMessage(errorEvent, 'prefix'))
                            .to.be.equal('prefix error 1461328707443 Error: test the handler. file:///docuzilla.js:63:8 ')
                        //jscs:enable maximumLineLength
                    })
            })

        describe('_formatErrorEventLogMessageWithStack'
            , () => {
                beforeEach(function () {
                    ErrorHandler.setVersionInfo({ version: 42 })
                })

                afterEach(function () {
                    ErrorHandler.setVersionInfo()
                })

                it('should format log message with stack trace'
                    , () => {
                        const errorEvent = errFactory.makeErrorFromFireFox()
                            , mockNavigator = navFactory.makeNavigatorFromFireFox()

                        //jscs:disable maximumLineLength
                        expect(ErrorHandler._formatErrorEventLogMessageWithStack(errorEvent, mockNavigator))
                            .to.be.equal('[Browser Error] error 1461328707443 Error: test the handler. file:///docuzilla.js:63:8 '
                                + '\nApp Version Info: {"version":42}'
                                + '\ncookies | en-GB | Linux x86_64 |  |  | Gecko | 20100101 | Netscape | Mozilla'
                                + '\nMozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:43.0) Gecko/20100101 Firefox/43.0'
                                + '\n5.0 (X11)'
                                + '\n@file:///docuzilla.js:63:8__webpack_require__@file:///docuzilla.js:20:12@file:///docuzilla.js:40:18@file:///docuzilla.js:1:1')
                        //jscs:enable maximumLineLength
                    })
            })

        // MUSTDO this needs testing
        // describe.skip('logBackEnd - using mock browser, sinon need to '
        //     + 'work out how to intercept XHR to enable this test.'
        //     , () => {
        //         it('should submit a message to the back end logError url'
        //             , function () {

        //                 console.log('XHR?', Object.keys(Browser.getInstance().getWindow()))

        //                 ErrorHandler.logBackEnd('message for you')

        //                 expect(this.xhr.requests.length).to.be.equal(1)
        //                 expect(this.xhr.requests[0].method)
        //                     .to.be.equal('POST')
        //                 expect(this.xhr.requests[0].url)
        //                     .to.be.equal('/logError')
        //                 expect(this.xhr.requests[0].requestBody)
        //                     .to.be.equal('message for you')
        //             })
        //     })

        describe('_logErrorBackEnd'
            , function () {
                beforeEach(function () {
                    this.stub = sinon.stub(ErrorHandler, 'logBackEnd')
                })

                afterEach(restoreStubs)

                it('should invoke logBackEnd with formatted message'
                    , function () {
                        const errorEvent = errFactory.makeErrorFromChrome()
                            , mockNavigator = navFactory.makeNavigator()
                        ErrorHandler._logErrorBackEnd(errorEvent, mockNavigator)
                        // without sinon-chai:
                        //assert.spyCalledOnce(this.stub);
                        expect(this.stub).to.have.callCount(1)
                        expect(this.stub).to.have.been.calledWith(
                            '[Browser Error] error 1461328707443 Script error.  '
                            + '\ncookies | en-GB | OS | v | vs | p | ps | Browser | acn'
                            + '\nUA'
                            + '\n1.0')
                    })
            })

        describe('_logError'
            , () => {
                beforeEach(function () {
                    const konsole = getKonsole()
                    this.stub = sinon.stub(konsole, 'log')
                })

                afterEach(restoreStubs)

                it('should invoke ' + logger + '.log with formatted message'
                    , function () {
                        const errorEvent = errFactory.makeErrorFromChrome()

                        ErrorHandler._logError(errorEvent)
                        assert.spyCalledOnce(this.stub)
                    })
            })

        describe('NAV_KEYS'
            , () => {
                it('should have navigator key names for cross browser support'
                    , () => {
                        expect(ErrorHandler.NAV_KEYS.sort()).to.deep.equal([
                            'appCodeName'
                            , 'appName'
                            , 'appVersion'
                            , 'browserLanguage'
                            , 'cookieEnabled'
                            , 'doNotTrack'
                            , 'language'
                            , 'onLine'
                            , 'platform'
                            , 'product'
                            , 'productSub'
                            , 'systemLanguage'
                            , 'userAgent'
                            , 'userLanguage'
                            , 'vendor'
                            , 'vendorSub'
                        ])
                    })
            })

        describe('ERROR_EVENT_KEYS'
            , () => {
                it('should have ErrorEvent key names for cross browser support'
                    , () => {
                        expect(ErrorHandler.ERROR_EVENT_KEYS.sort()).to.deep.equal([
                            'colno'
                            , 'error'
                            , 'filename'
                            , 'lineno'
                            , 'message'
                            , 'timestamp'
                            , 'type'
                        ])
                    })
            })

        describe('ERROR_EVENT_ERROR_KEYS'
            , () => {
                it('should have ErrorEvent.error key names for cross browser support'
                    , () => {
                        expect(ErrorHandler.ERROR_EVENT_ERROR_KEYS.sort()).to.deep.equal([
                            'columnNumber'
                            , 'fileName'
                            , 'lineNumber'
                            , 'message'
                            , 'stack'
                        ])
                    })
            })
    })

