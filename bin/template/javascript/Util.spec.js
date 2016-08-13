// Util.spec.js
// unit tests for utility methods

'use strict'

import { expect } from '../setupTests'

import U from '../../src/es6/Util'

const component = 'Util'

describe(component
    , () => {
        describe('import'
            , () => {
                it('should provide access through the default export'
                    , () => {
                        expect(typeof U)
                            .to.be.equal('object')
                    })
            })

        describe('hideProperty'
            , () => {
                beforeEach(function () {
                    this.testMe = U.hideProperty(
                        { visible: 43 }
                        , 'hidden'
                        , 'invisible')
                })

                it('should be able to access hidden value'
                    , function () {
                        expect(this.testMe.hidden)
                            .to.be.equal('invisible')
                    })

                it('should not list hidden in keys'
                    , function () {
                        expect(Object.keys(this.testMe))
                            .to.deep.equal(['visible'])
                    })

                it('should not normally be visible in object'
                    , function () {
                        expect(this.testMe)
                            .to.deep.equal({ visible: 43 })
                    })

                it('should NOT be able to change hidden value'
                    , function () {
                        expect(() => {
                            this.testMe.hidden = 'mutated'
                        }).to.throw(
                            TypeError
                            , 'Cannot assign to read only property')

                        expect(this.testMe.hidden)
                            .to.be.equal('invisible')
                    })

                it('should NOT be able to delete hidden value'
                    , function () {
                        expect(() => {
                            delete(this.testMe.hidden)
                        }).to.throw(
                            TypeError
                            , 'Cannot delete property')

                        expect(this.testMe.hidden)
                            .to.be.equal('invisible')
                    })

                // expected this to be possible, but nope.
                it('should NOT be able to hide an existing value'
                    , function () {
                        U.hideProperty(
                            this.testMe
                            , 'visible'
                            , 'invisible')

                        expect(this.testMe.visible)
                            .to.be.equal('invisible')

                        expect(this.testMe)
                            .to.deep.equal({ visible: 'invisible' })
                    })

                it('should be able to make hidden methods'
                    , function () {
                        U.hideProperty(
                            this.testMe
                            , 'spooky'
                            , function () { return this })

                        expect(this.testMe.spooky())
                            .to.deep.equal({ visible: 43 })
                    })
            }) // hideProperty

        describe('readOnly'
            , () => {
                beforeEach(function () {
                    this.testMe = U.readOnly(
                        { visible: 43 }
                        , 'readonly'
                        , 'visible')
                })

                it('should be able to access readonly value'
                    , function () {
                        expect(this.testMe.readonly)
                            .to.be.equal('visible')
                    })

                it('should list readonly in keys'
                    , function () {
                        expect(Object.keys(this.testMe))
                            .to.deep.equal(['visible', 'readonly'])
                    })

                it('should normally be visible in object'
                    , function () {
                        expect(this.testMe)
                            .to.deep.equal({
                                visible: 43
                                , readonly: 'visible'
                            })
                    })

                it('should NOT be able to change readonly value'
                    , function () {
                        expect(() => {
                            this.testMe.readonly = 'mutated'
                        }).to.throw(
                            TypeError
                            , 'Cannot set property readonly')

                        expect(this.testMe.readonly)
                            .to.be.equal('visible')
                    })

                it('should NOT be able to delete readonly value'
                    , function () {
                        expect(() => {
                            delete(this.testMe.readonly)
                        }).to.throw(
                            TypeError
                            , 'Cannot delete property')

                        expect(this.testMe.readonly)
                            .to.be.equal('visible')
                    })
            }) // readOnly

        describe('timeAgoFormatter'
            , () => {
                it('should abbreviate month as mo'
                    , () => {
                        expect(U.timeAgoFormatter(12, 'month', 'ago'))
                            .to.be.equal('12mo ago')
                    })

                it('should abbreviate months as mo'
                    , () => {
                        expect(U.timeAgoFormatter(12, 'months', 'ago'))
                            .to.be.equal('12mo ago')
                    })

                it('should abbreviate all other units with first letter'
                    , () => {
                        expect(U.timeAgoFormatter(4, 'days', 'from now'))
                            .to.be.equal('4d from now')
                    })
            }) // timeAgoFormatter

        describe('byNumber'
            , () => {
                it('reference normal sorting of number strings'
                    , () => {
                        expect([
                                '99'
                                , '0'
                                , '10'
                                , '1'
                                , '2'
                            ].sort())
                            .to.deep.equal([
                                '0'
                                , '1'
                                , '10'
                                , '2'
                                , '99'
                            ])
                    })

                it('should order numbers by number'
                    , () => {
                        expect([
                                99
                                , 0
                                , 10
                                , 1
                                , 2
                            ].sort(U.byNumber))
                            .to.deep.equal([
                                0
                                , 1
                                , 2
                                , 10
                                , 99
                            ])
                    })

                it('should order number strings by number'
                    , () => {
                        expect([
                                '99'
                                , '0'
                                , '10'
                                , '1'
                                , '2'
                            ].sort(U.byNumber))
                            .to.deep.equal([
                                '0'
                                , '1'
                                , '2'
                                , '10'
                                , '99'
                            ])
                    })

                it('reference will not order strings by number, use byLocale'
                    , () => {
                        expect([
                                '99 bottles'
                                , '0f beer'
                                , '10 things'
                                , '1 thing'
                                , '2 things'
                            ].sort(U.byNumber))
                            .to.deep.equal([
                                '99 bottles'
                                , '0f beer'
                                , '10 things'
                                , '1 thing'
                                , '2 things'
                            ])
                    })
            }) // byNumber

        describe('byLocale'
            , () => {
                it('should order numbers by value'
                    , () => {
                        expect([
                                99
                                , 0
                                , 10
                                , 1
                                , 2
                            ].sort(U.byLocale))
                            .to.deep.equal([
                                0
                                , 1
                                , 2
                                , 10
                                , 99
                            ])
                    })

                it('should order number strings by number'
                    , () => {
                        expect([
                                '99'
                                , '0'
                                , '10'
                                , '1'
                                , '2'
                            ].sort(U.byLocale))
                            .to.deep.equal([
                                '0'
                                , '1'
                                , '2'
                                , '10'
                                , '99'
                            ])
                    })

                it('should order by number, not characters for mixed data'
                    , () => {
                        expect([
                                '99 bottles'
                                , '0f beer'
                                , '10 things'
                                , 'things 10 are'
                                , 'things 2 are'
                                , '1 thing'
                                , '2 things'
                            ].sort(U.byLocale))
                            .to.deep.equal([
                                '0f beer'
                                , '1 thing'
                                , '2 things'
                                , '10 things'
                                , '99 bottles'
                                , 'things 2 are'
                                , 'things 10 are'
                            ])
                    })

                it('should ignore case and punctuation, not accents'
                    , () => {
                        expect([
                                'bottles'
                                , 'of Beer'
                                , 'bottles'
                                , 'of bëer'
                                , 'bottles'
                                , 'of bËer'
                                , 'Bottles'
                                , 'of beer'
                                , 'bottles'
                                , ',bottles'
                                , 'of bëer'
                                , 'bot,tles'
                                , 'of b:Ëer'
                                , 'Bot/tles'
                            ].sort(U.byLocale))
                            .to.deep.equal([
                                ',bottles'
                                , 'bot,tles'
                                , 'Bot/tles'
                                , 'bottles'
                                , 'bottles'
                                , 'bottles'
                                , 'Bottles'
                                , 'bottles'
                                , 'of b:Ëer'
                                , 'of Beer'
                                , 'of beer'
                                , 'of bËer'
                                , 'of bëer'
                                , 'of bëer'
                            ])
                    })
            }) // byLocale

        describe('anyMatchInObject'
            , () => {
                beforeEach(function () {
                    this.object = {
                        alpha: false
                        , beta: true
                        , charlie: 'bravo'
                        , zero: 0
                    }
                })
                it('should fail to match with empty array'
                    , function () {
                        const list = []
                        expect(U.anyMatchInObject(list, this.object))
                            .to.be.equal(false)
                    })

                it('should fail to match for non truthy values in object'
                    , function () {
                        const list = ['alpha', 'zero']
                        expect(U.anyMatchInObject(list, this.object))
                            .to.be.equal(false)
                    })

                it('should fail to match with null, void keys'
                    , function () {
                        const list = [null, void 0, NaN]
                        expect(U.anyMatchInObject(list, this.object))
                            .to.be.equal(false)
                    })

                it('should match for truthy string values in object'
                    , function () {
                        const list = ['alpha', 'zero', 'charlie']
                        expect(U.anyMatchInObject(list, this.object))
                            .to.be.equal(true)
                    })

                it('should match for truthy boolean values in object'
                    , function () {
                        const list = ['alpha', 'zero', 'beta']
                        expect(U.anyMatchInObject(list, this.object))
                            .to.be.equal(true)
                    })

                // untestable, short circuit on first found match
                // unless we benchmark it.
            })

        describe('allMatchInObject'
            , () => {
                beforeEach(function () {
                    this.object = {
                        alpha: false
                        , beta: true
                        , charlie: 'bravo'
                        , zero: 0
                    }
                })
                it('should fail to match with empty array'
                    , function () {
                        const list = []
                        expect(U.allMatchInObject(list, this.object))
                            .to.be.equal(false)
                    })

                it('should fail to match for non truthy boolean values in object'
                    , function () {
                        const list = ['beta', 'charlie', 'alpha']
                        expect(U.allMatchInObject(list, this.object))
                            .to.be.equal(false)
                    })

                it('should fail to match for any non truthy value in object'
                    , function () {
                        const list = ['beta', 'charlie', 'zero']
                        expect(U.allMatchInObject(list, this.object))
                            .to.be.equal(false)
                    })

                it('should match for all truthy values in object'
                    , function () {
                        const list = ['beta', 'charlie']
                        expect(U.allMatchInObject(list, this.object))
                            .to.be.equal(true)
                    })

                it('should match ignoring null, void keys'
                    , function () {
                        const list = [null, void 0, NaN, 'charlie']
                        expect(U.allMatchInObject(list, this.object))
                            .to.be.equal(true)
                    })

                // untestable, short circuit on first failed match
                // unless we benchmark it.
            }) // allMatchInObject
    })

