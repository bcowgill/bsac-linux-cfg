// MarkObject.js
// A debugging aid to mark an object with an ID value and log/trace it

'use strict'

let id = 58008

function generateId () { return id++ }

function addReadOnlyProperty (_this, name, value) {
    Object.defineProperty(_this
        , name
        , {
            value: value
            , writable: false
            , enumerable: false
            , configurable: false
        })
}

const MarkObject = {
    mark: function (_this) {
        if (!('__' in _this)) {
            const newId = generateId()
            addReadOnlyProperty(_this, '__', generateId())
        }
        return _this.__
    }

    , trace: function (where, object, more) {
        object = object || {}
        if (typeof more === 'undefined') {
            more = ''
        }
        const identity = this.mark(object)
        console.error(where, object.__, more)
    }
}

export default MarkObject

// ;(function() {
//     let id = 0

//     function generateId() { return id++; }

//     Object.prototype.__who_the_f_ck_am_i__ = function() {
//         let newId = generateId()

//         this.__who_the_f_ck_am_i__ = function() { return newId; }

//         return newId
//     }
// })()

//function logme(object) {
    // console.error(object.__who_the_f_ck_am_i__())
//}
