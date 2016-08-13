// Env.spec.js
// test plan for universal environment detector

'use strict'

import { expect } from '../setupTests'

import Env from '../../src/es6/Env'

const component = 'Env'

describe(component
    , () => {
        it('should be a singleton object'
            , () => {
                // just show info about the testing environnment
                Env.splatter(console.error.bind(console))

                expect(Env).to.be.an( 'object' )
            })

        it('should have all the correct methods'
            , () => {
                expect(Object.keys(Env).sort()).to.be.deep.equal([
                    'getGlobal'
                    , 'isBrowser'
                    , 'isKarma'
                    , 'isNode'
                    , 'isPhantomJS'
                    , 'isWebWorker'
                    , 'splatter'
                    , 'spray'
                ])
            })

        it('.isBrowser() should NOT be running browser'
            , () => {
                const testMe = Env.isBrowser()
                expect(testMe).to.be.an('boolean')
                expect(testMe).to.be.equal(false)
            })

        it('.isKarma() should NOT be running in karma'
            , () => {
                const testMe = Env.isKarma()
                expect(testMe).to.be.an('boolean')
                expect(testMe).to.be.equal(false)
            })

        it('.isNode() should be running in node'
            , () => {
                const testMe = Env.isNode()
                expect(testMe).to.be.an('boolean')
                expect(testMe).to.be.equal(true)
            })

        it('.isPhantomJS() should NOT be running in phantomjs'
            , () => {
                const testMe = Env.isPhantomJS()
                expect(testMe).to.be.an('boolean')
                expect(testMe).to.be.equal(false)
            })

        it('.isWebWorker() should NOT be running as a webworker'
            , () => {
                const testMe = Env.isWebWorker()
                expect(testMe).to.be.an('boolean')
                expect(testMe).to.be.equal(false)
            })
    }) // component

