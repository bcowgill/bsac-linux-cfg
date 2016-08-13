// MarkObject.spec.js
// unit tests for objects marked with an ID

'use strict'

import { expect, sinon } from '../setupTests'

import MarkObject from '../../src/es6/MarkObject'

const component = 'MarkObject'

function Shape () {
    this.xPos = 0
    this.yPos = 0
}

// superclass method
Shape.prototype.move = function (xPos, yPos) {
    this.xPos += xPos
    this.yPos += yPos
}

// Rectangle - subclass
function Rectangle () {
    Shape.call(this) // call super constructor.
    this.width = 1
    this.height = 1
}

// subclass extends superclass
Rectangle.prototype = Object.create(Shape.prototype)
Rectangle.prototype.constructor = Rectangle

describe(component
    , () => {
        beforeEach(function () {
            //            this.stub = sinon.stub(console, 'error')
        })

        afterEach(function () {
            if (this.stub) {
                this.stub.restore()
            }
        })

        it('should mark an object with an id'
            , () => {
                const testMe = {}
                , id = MarkObject.mark(testMe)

                expect(testMe.__).to.be.equal(id)
            })

        it('should mark another object with a different id'
            , () => {
                const testMe1 = {}
                , testMe2 = {}

                MarkObject.mark(testMe1)
                MarkObject.mark(testMe2)

                expect(testMe1.__).to.not.be.equal(testMe2.__)
            })

        it('should not mark the object with different ids if marked again'
            , () => {
                const testMe = {}
                    , id = MarkObject.mark(testMe)

                MarkObject.mark(testMe)

                expect(testMe.__).to.be.equal(id)
            })

        it('should not allow the mark id to be changed'
            , () => {
                const testMe = {}
                    , id = MarkObject.mark(testMe)
                try {
                    testMe.__ = 1
                }
                catch (error) {
                    void 0
                }

                expect(testMe.__).to.be.equal(id)
            })

        it('should give a new id when Object.assign used to clone an object'
            , () => {
                const testMe1 = { clone: 'me' }
                MarkObject.mark(testMe1)
                const testMe2 = Object.assign({}, testMe1)
                MarkObject.mark(testMe2)

                expect(testMe2.clone).to.be.equal(testMe1.clone)
                expect(testMe1.__).to.not.be.equal(testMe2.__)
            })

        it('should give a new id for an object when it inherits a prototype'
            , () => {
                const testMe1 = new Shape()
                MarkObject.mark(testMe1)
                const testMe2 = new Rectangle()
                MarkObject.mark(testMe2)

                expect(testMe2.__).to.not.be.equal(testMe1.__)
            })

        // it.skip('should give a new id for an object when its prototype has been marked'
        //     , () => {
        //         // This seems not possible
        //         MarkObject.mark(Shape.prototype)
        //         const testMe1 = new Shape()
        //         MarkObject.mark(testMe1)

        //         expect(testMe1.__).to.not.be.equal(Shape.prototype.__)
        //     })
        // it.skip('should apply a mark to object when first logged'
        //     , () => {
        //         const testMe1 = {}
        //             , testMe2 = {}
        //             , id = MarkObject.mark(testMe2)

        //         MarkObject.trace('location', testMe1, 'more stuff')

        //         expect(testMe1.__).to.be.equal(1 + id)
        //     })

        // it.skip('should log a marked object with id')
        // it.skip('should log a marked object with _inherits')
        // it.skip('should log a marked object with constructor name')
        // it.skip('should log a marked object with displayName')
    })
