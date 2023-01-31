#!/usr/bin/env node
/* source: https://www.builder.io/blog/structured-clone
What are the pros and cons of each method of cloning an object?
1. { ...obj }
  or Object.create(obj)
  or Object.assign({}, obj)
   con: deep structures/Date, Regex, Map, Error end up referring to same objects
   con: circular object copied but does not self-refer
   pro/con: functions preserved
   pro: prototype chain preserved
   pro: object types (Date, Regex, etc) are preserved

2. JSON.parse(JSON.stringify(obj))
   con: object types (Date, etc) lost, convert to string
   con: circular object will throw an error cannot be cloned
   con: prototype chain is lost in copied object
   con: objects like RegExp, Set, Map etc become empties: {}
   pro/con: functions are lost in copy
   pro: Error objects do not refer to the original
   pro: deep structures are isolated from each other

3. _.cloneDeep(obj)
   con: requires an import of 5.3k+
   con: Error objects refer to the same Error in the copy
   pro/con: functions are kept in copy
   pro: object types (Date, Regex, etc) are preserved
   pro: circular object is cloned and refers to itself
   pro: prototype chain preserved
   pro: objects like RegExp, Set, Map are preserved as is
   pro: deep structures/Date, Regex, Map are isolated from each other

4. structuredClone(obj)
   con: functions in the object cause an error to be thrown
   con: DOM nodes, property get/set and some other types in the object cause an error to be thrown
   con: prototype chain is lost in copied object
   pro: object types (Date, Regex, Error, Map, etc) are preserved
   pro: circular object is cloned and refers to itself
   pro: deep structures/Date, Regex, Map, Error are isolated from each other

*/

const util = require('util')
const cloneDeep = require('lodash/cloneDeep')

// deepLog :: string →  object →  *
const deepLog = function (name, object) {
    const showHidden = true
        , fullDepth = null
        , colorize = true
        , sorted = true
        , getters = true
    if (typeof object === 'undefined') {
        object = name
        name = 'deepLog:'
    }
    const options = {
        showHidden,
        depth: fullDepth,
        colors: colorize,
        sorted,
        getters,
    }
    console.error(name, util.inspect(object, options))
}

const isa = function (name, object) {
    console.log(name + " isa", typeof object, object.constructor)
}

const isInstanceOf = function (name, konstructor, copy) {
    console.log(name + " instanceof ", konstructor, "?", copy instanceof konstructor)
}

const isAType = function (name, konstructor, copy) {
    console.log(name + " is constructed by", konstructor, "?", konstructor === copy.constructor)
    isInstanceOf(name, konstructor, copy)
}

const isSame = function (name, source, copy) {
    console.log(name + " is same object?", source === copy)
}

const isCircular = function (name, source, circle) {
    console.log(name + " refers to itself?", source === circle)
}

const fn = function () { return 42 }

const shallow = function (object) {
    // return { ...object }
    // return Object.assign({}, object)
    return Object.create(object)
}

const cloneJson = function (object) {
  return JSON.parse(JSON.stringify(object))
}

class MyClass {
  foo = 'bar'
  myMethod() { foo += foo  }
}
const myClass = new MyClass()

const calendarEvent = {
  title: "Meeting of the minds",
  date: new Date(123),
  attendees: ["Steve"]
}

const kitchenSink = {
  set: new Set([1, 3, 3]),
  map: new Map([[1, 2]]),
  regex: /foo/,
  deep: { array: [
    // new File(someBlobData, 'file.txt')
    new RegExp('file.txt', 'gi')
  ] },
  error: new Error('Hello!')
}
kitchenSink.circular = kitchenSink

const kitchenSinkWithoutFn = structuredClone(kitchenSink)
kitchenSink.fn = fn

// 😍
const copied = structuredClone(calendarEvent)
let ccc = copied

deepLog("=== structuredClone copy:", ccc)
isAType("calendarEvent.date", Date, calendarEvent.date)
isa("calendarEvent.date", calendarEvent.date)
isa("copied.date", ccc.date)
isSame(".attendees", calendarEvent.attendees, ccc.attendees)
console.log("");

// ✅ All good, fully and deeply copied! 🚩 but must not include functions, DOM, etc in it.
const clonedSink = structuredClone(kitchenSinkWithoutFn)
ks = kitchenSinkWithoutFn
ccc = clonedSink

console.log("Objects with functions, DOM nodes, property get/set, cannot be cloned this way. Throws error!")
deepLog("=== structuredClone kitchenSink:", ccc)
console.log(".fn", typeof ccc.fn)
isSame(".fn", kitchenSink.fn, ccc.fn)
isSame(".circular", kitchenSink.circular, ccc.circular)
isCircular("kitchenSink.circular", ks, ks.circular)
isCircular("copied.circular", ccc, ccc.circular)
isAType("copied.set", Set, ccc.set)
isAType("copied.map", Map, ccc.map)
isAType("copied.regex", RegExp, ccc.regex)
isAType("copied.error", Error, ccc.error)
isSame(".set", ks.set, ccc.set)
isSame(".map", ks.map, ccc.map)
isSame(".regex", ks.regex, ccc.regex)
isSame(".error", ks.error, ccc.error)
console.log("");

// 🚩 loses prototype chain!
const clonedMyClass = structuredClone(myClass)
ccc = clonedMyClass

deepLog("=== structuredClone myClass:", ccc)
isAType("myClass", MyClass, myClass)
isAType("copied", MyClass, ccc)
console.log("");

ks = kitchenSink

// ✅ lodash clones just as well but ⚠️  a large import size 5.3k gzipped
const lodashCopy = cloneDeep(calendarEvent)
ccc = lodashCopy

deepLog("=== lodash/cloneDeep copy:", ccc)
isAType("calendarEvent.date", Date, calendarEvent.date)
isa("calendarEvent.date", calendarEvent.date)
isa("copied.date", ccc.date)
isSame(".attendees", calendarEvent.attendees, ccc.attendees)
console.log("");

// ✅ All good, fully and deeply copied!
const lodashSink = cloneDeep(kitchenSink)
ccc = lodashSink

deepLog("=== lodash/cloneDeep kitchenSink:", ccc)
console.log(".fn", typeof ccc.fn)
isSame(".fn", kitchenSink.fn, ccc.fn)
isSame(".circular", kitchenSink.circular, ccc.circular)
isCircular("kitchenSink.circular", kitchenSink, kitchenSink.circular)
isCircular("copied.circular", ccc, ccc.circular)
isAType("copied.set", Set, ccc.set)
isAType("copied.map", Map, ccc.map)
isAType("copied.regex", RegExp, ccc.regex)
isAType("copied.error", Error, ccc.error)
isSame(".set", kitchenSink.set, ccc.set)
isSame(".map", kitchenSink.map, ccc.map)
isSame(".regex", kitchenSink.regex, ccc.regex)
isSame(".error", kitchenSink.error, ccc.error)
console.log("");

// ✅ lodash keeps prototype chain
const lodashMyClass = cloneDeep(myClass)
ccc = lodashMyClass

deepLog("=== lodash/cloneDeep myClass:", ccc)
isAType("myClass", MyClass, myClass)
isAType("copied", MyClass, ccc)
console.log("");

// 🚩 oops - date, attendees array referenced twice...
const shallowCopy = shallow(calendarEvent)
ccc = shallowCopy

deepLog("--- shallow copy:", ccc)
isAType(".date", Date, ccc.date)
isSame(".date", calendarEvent.date, ccc.date)
isSame(".attendees", calendarEvent.attendees, ccc.attendees)
console.log("");

// 🚩 oops - more duplicated references
const shallowCircle = shallow(kitchenSink)
ccc = shallowCircle

deepLog("--- kitchenSink shallow copy:", ccc)
console.log(".fn", typeof ccc.fn)
isSame(".fn", kitchenSink.fn, ccc.fn)
isSame(".circular", kitchenSink.circular, ccc.circular)
isCircular("kitchenSink.circular", kitchenSink, kitchenSink.circular)
isCircular("copied.circular", ccc, ccc.circular)
isAType("copied.set", Set, ccc.set)
isAType("copied.map", Map, ccc.map)
isAType("copied.regex", RegExp, ccc.regex)
isAType("copied.error", Error, ccc.error)
isSame(".set", kitchenSink.set, ccc.set)
isSame(".map", kitchenSink.map, ccc.map)
isSame(".regex", kitchenSink.regex, ccc.regex)
isSame(".error", kitchenSink.error, ccc.error)
console.log("");

// ✅ shallow copy keeps prototype chain
const shallowMyClass = shallow(myClass)
ccc = shallowMyClass

deepLog("=== myClass shallow copy:", ccc)
isAType("myClass", MyClass, myClass)
isAType("copied", MyClass, ccc)
console.log("");

// 🚩 oops - date is no longer a Date object, but a string...
const jsonCopy = cloneJson(calendarEvent)
ccc = jsonCopy

deepLog("=== JSON copy:", ccc)
isAType(".date", Date, ccc.date)
isSame(".date", calendarEvent.date, ccc.date)
console.log(".date", typeof ccc.date)
isSame(".attendees", calendarEvent.attendees, ccc.attendees)
console.log("");

// 🚩 oops - cannon clone circular structures from here on out...
kitchenSink.circular = null;

// 🚩 oops - more duplicated references
const jsonCircle = cloneJson(kitchenSink)
ccc = jsonCircle

console.log(".circular Objects cannot be cloned this way.")
deepLog("=== kitchenSink JSON copy:", ccc)
console.log(".fn", typeof ccc.fn)
isSame(".fn", kitchenSink.fn, ccc.fn)
isAType("copied.set", Set, ccc.set)
isAType("copied.map", Map, ccc.map)
isAType("copied.regex", RegExp, ccc.regex)
isAType("copied.error", Error, ccc.error)
isSame(".set", kitchenSink.set, ccc.set)
isSame(".map", kitchenSink.map, ccc.map)
isSame(".regex", kitchenSink.regex, ccc.regex)
isSame(".error", kitchenSink.error, ccc.error)
console.log("");

// 🚩 oops - json copy loses prototype chain!
const jsonMyClass = cloneJson(myClass)
ccc = jsonMyClass

deepLog("=== myClass JSON copy:", ccc)
isAType("myClass", MyClass, myClass)
isAType("copied", MyClass, ccc)
console.log("");

