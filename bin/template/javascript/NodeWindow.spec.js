// NodeWindow.spec.js
// unit tests for providing a window global in node test environment

'use strict'

import { expect } from '../setupTests'

import NodeWindow from './NodeWindow'
import FakeBrowser from './FakeBrowser'

const component = 'NodeWindow'
    , PROPS = [
        'console'
        , 'document'
        , 'history'
        , 'location'
        , 'navigator'
        , 'localStorage'
        , 'sessionStorage'
        , '_inherits'
        , 'frames'
        , 'parent'
        , 'self'
        , 'top'
        , 'window'
    ]

describe(component
    , () => {
        it('should be an object'
            , () => {
                expect(NodeWindow).to.be.an( 'object' )
            })

        it('should have _inherits property'
            , () => {
                expect(NodeWindow._inherits).to.be.deep.equal( [component] )
            })

        it('should have all expected properties'
            , () => {
                expect(Object.keys(NodeWindow).sort())
                    .to.be.deep.equal(PROPS.sort())
            })

        it('should have access to window.history'
            , () => {
                expect(NodeWindow.history)
                    .to.be.equal(FakeBrowser.getInstance().getHistory())
            })

        it('should have access to window.navigator'
            , () => {
                expect(NodeWindow.navigator)
                    .to.be.equal(FakeBrowser.getInstance().getNavigator())
            })

        it('should have access to window.document'
            , () => {
                expect(NodeWindow.document)
                    .to.be.equal(FakeBrowser.getInstance().getDocument())
            })

        it('should have access to window.location'
            , () => {
                expect(NodeWindow.location)
                    .to.be.equal(FakeBrowser.getInstance().getLocation())
            })

        it('should have access to window.localStorage'
            , () => {
                expect(NodeWindow.localStorage)
                    .to.be.equal(FakeBrowser.getInstance().getLocalStorage())
            })

        it('should have access to window.sessionStorage'
            , () => {
                expect(NodeWindow.sessionStorage)
                    .to.be.equal(FakeBrowser.getInstance().getSessionStorage())
            })

        it('should have access to window.console'
            , () => {
                expect(NodeWindow.console)
                    .to.be.equal(FakeBrowser.getInstance().getConsole())
            })

        // MUSTDO jsdom bug https://github.com/tmpvar/jsdom/issues/1562
        // needs fixing before this can pass
        // it('should have identical window.console'
        //     , () => {
        //         expect(FakeBrowser.getInstance().getWindow().console)
        //             .to.be.equal(FakeBrowser.getInstance().getConsole())
        //     })
    })
