// String.spec.js
// unit tests for string related utilities

'use strict'

import { expect } from '../setupTests'

import S, { shorten } from '../../src/es6/String'

const component = 'String'
    , s10 = shorten(10)
    , ELLIPSIS = '…'

describe(component
    , () => {
        describe('import'
            , () => {
                it('should provide access through individual function names'
                    , () => {
                        expect(typeof shorten)
                            .to.be.equal('function')
                    })

                it('should provide access through the default export'
                    , () => {
                        expect(typeof S.shorten)
                            .to.be.equal('function')
                    })

                it('should expose ellipsis as constant'
                    , () => {
                        expect(S.ELLIPSIS)
                            .to.be.equal(ELLIPSIS)
                    })
            }) // import

        describe('shorten()'
            , () => {
                it('should be curried so you can specify the length separately'
                    , () => {
                        expect(s10('1234'))
                            .to.be.equal('1234')
                    })

                it('should return the full string for length null'
                    , () => {
                        expect(shorten(void 0, '123'))
                            .to.be.equal('123')
                    })

                it('should return the full string for length undefined'
                    , () => {
                        expect(shorten(null, '123'))
                            .to.be.equal('123')
                    })

                it('should return the full string for length -1'
                    , () => {
                        expect(shorten(-1, '123'))
                            .to.be.equal('123')
                    })

                it('should be empty for length 0'
                    , () => {
                        expect(shorten(0, '123'))
                            .to.be.equal('')
                    })

                it('should return only the first letter when length 1'
                    , () => {
                        expect(shorten(1, '1234'))
                            .to.be.equal('1')
                    })

                it('should put ellipsis at end for length 2 (even length string)'
                    , () => {
                        expect(shorten(2, '1234'))
                           .to.be.equal('1' + ELLIPSIS)
                    })

                it('should put ellipsis at end for length 2 (odd length string)'
                    , () => {
                        expect(shorten(2, '123'))
                            .to.be.equal('1' + ELLIPSIS)
                    })

                it('should return the string itself when too short'
                    , () => {
                        expect(shorten(10, '1234'))
                            .to.be.equal('1234')
                    })

                it('should return the string itself when not too long'
                    , () => {
                        expect(shorten(10, '1234567890'))
                            .to.be.equal('1234567890')
                    })

                it('should insert ellipsis at the end of string when too long (even max length)'
                    , () => {
                        expect(shorten(10, '12345678901234567890'))
                            .to.be.equal('123456789' + ELLIPSIS)
                    })

                it('should insert ellipsis at the end of string when too long (odd max length)'
                    , () => {
                        expect(shorten(9, '12345678901234567890'))
                            .to.be.equal('12345678' + ELLIPSIS)
                    })
            }) // shorten()

        describe('voidOrTrimmed()'
            , () => {
                it('should be void 0 if undefined'
                    , () => {
                        expect(S.voidOrTrimmed())
                            .to.be.equal(void 0)
                    })

                it('should be void 0 if null'
                    , () => {
                        expect(S.voidOrTrimmed(null))
                            .to.be.equal(void 0)
                    })

                it('should be void 0 if whitespace only'
                    , () => {
                        expect(S.voidOrTrimmed('    \t   \n    '))
                            .to.be.equal(void 0)
                    })

                it('should be trimmed if not empty'
                    , () => {
                        expect(S.voidOrTrimmed('    \t  trimmed    '))
                            .to.be.equal('trimmed')
                    })
            }) // voidOrTrimmed()

        describe('emptyIfVoid()'
            , () => {
                it('should be empty string if undefined'
                    , () => {
                        expect(S.emptyIfVoid())
                            .to.be.equal('')
                    })

                it('should be empty string if null'
                    , () => {
                        expect(S.emptyIfVoid(null))
                            .to.be.equal('')
                    })

                it('should be the string if a string'
                    , () => {
                        expect(S.emptyIfVoid('a valid string'))
                            .to.be.equal('a valid string')
                    })

                it('should be made an empty string if zero'
                    , () => {
                        expect(S.emptyIfVoid(0))
                            .to.be.equal('')
                    })

                it('should be left alone if non-zero'
                    , () => {
                        expect(S.emptyIfVoid(42))
                            .to.be.equal(42)
                    })
            }) // emptyIfVoid()

        describe('stringify()'
            , () => {
                it('should be empty string if undefined'
                    , () => {
                        expect(S.stringify())
                            .to.be.equal('')
                    })

                it('should be empty string if null'
                    , () => {
                        expect(S.stringify(null))
                            .to.be.equal('')
                    })

                it('should be the string if a string'
                    , () => {
                        expect(S.stringify('a valid string'))
                            .to.be.equal('a valid string')
                    })

                it('should be made a string if zero'
                    , () => {
                        expect(S.stringify(0))
                            .to.be.equal('0')
                    })

                it('should be made a string if non-zero'
                    , () => {
                        expect(S.stringify(42))
                            .to.be.equal('42')
                    })

                it('should be made a string if NaN'
                    , () => {
                        expect(S.stringify(NaN))
                            .to.be.equal('NaN')
                    })

                it('should be made a string if -Infinity'
                    , () => {
                        expect(S.stringify(-Infinity))
                            .to.be.equal('-Infinity')
                    })

                it('should be made a string if Infinity'
                    , () => {
                        expect(S.stringify(Infinity))
                            .to.be.equal('Infinity')
                    })

                it('should be made a string if boolean false'
                    , () => {
                        expect(S.stringify(false))
                            .to.be.equal('false')
                    })

                it('should be made a string if boolean true'
                    , () => {
                        expect(S.stringify(true))
                            .to.be.equal('true')
                    })
            }) // stringify()

        describe('fullFileName'
            , () => {
                it('should construct full file name from name only'
                    , () => {
                        expect(S.fullFileName('just the name'))
                            .to.be.equal('just the name')
                    })

                it('should construct full file name from name and extension'
                    , () => {
                        expect(S.fullFileName('with the name and', 'extension'))
                            .to.be.equal('with the name and.extension')
                    })

                it('should construct full file name from just the extension'
                    , () => {
                        expect(S.fullFileName('', 'extension'))
                            .to.be.equal('.extension')
                    })
            }) // fullFileName()
    }) // unit tests

