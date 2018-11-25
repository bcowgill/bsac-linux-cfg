import has from 'lodash/has'
import trim from 'lodash/trim'
import isValidDate from './isValidDate'
import isPossibleDate from './isPossibleDate'

function length(thing) {
	return thing.length
	//  return has(thing, 'length') ? thing.length : false;
}

const identifiers = [
	['isUndefined', require('lodash/isUndefined')],
	['isNull', require('lodash/isNull')],
	['isBoolean', require('lodash/isBoolean')],
	['isNumber', require('lodash/isNumber')],
	['isString', require('lodash/isString')],
	['isSymbol', require('lodash/isSymbol')],
	['isObject', require('lodash/isObject')],
	['\n'],
	['isPlainObject', require('lodash/isPlainObject')],
	['isObjectLike', require('lodash/isObjectLike')],
	['isFunction', require('lodash/isFunction')],
	['\n'],
	['isError', require('lodash/isError')],
	['isDate', require('lodash/isDate')],
	['isValidDate', isValidDate],
	['isPossibleDate', isPossibleDate],
	['isRegExp', require('lodash/isRegExp')],
	['isElement', require('lodash/isElement')],
	['\n'],
	['isNil', require('lodash/isNil')],
	['isEmpty', require('lodash/isEmpty')],
	['isNaN', require('lodash/isNaN')],
	['isInteger', require('lodash/isInteger')],
	['isSafeInteger', require('lodash/isSafeInteger')],
	['isLength', require('lodash/isLength')],
	['isFinite', require('lodash/isFinite')],
	['isNative', require('lodash/isNative')],
	['\n'],
	['isArguments', require('lodash/isArguments')],
	['isArray', require('lodash/isArray')],
	['isArrayLike', require('lodash/isArrayLike')],
	['isArrayLikeObject', require('lodash/isArrayLikeObject')],
	['isTypedArray', require('lodash/isTypedArray')],
	['isArrayBuffer', require('lodash/isArrayBuffer')],
	['isBuffer', require('lodash/isBuffer')],
	['\n'],
	['isMap', require('lodash/isMap')],
	['isSet', require('lodash/isSet')],
	['isWeakMap', require('lodash/isWeakMap')],
	['isWeakSet', require('lodash/isWeakSet')],
	['\n'],
	['_isIndex', require('lodash/_isIndex')],
	['_isKey', require('lodash/_isKey')],
	['_isKeyable', require('lodash/_isKeyable')],
	['_isPrototype', require('lodash/_isPrototype')],
	['_isStrictComparable', require('lodash/_isStrictComparable')],
	['_isFlattenable', require('lodash/_isFlattenable')],
	['_isIterateeCall', require('lodash/_isIterateeCall')],
	['_isLaziable', require('lodash/_isLaziable')],
	['_isMaskable', require('lodash/_isMaskable')],
	['_isMasked', require('lodash/_isMasked')],
	//   ["isEqual", require("lodash/isEqual")],
	//   ["isEqualWith", require("lodash/isEqualWith")],
	//   ["isMatch", require("lodash/isMatch")],
	//   ["isMatchWith", require("lodash/isMatchWith")],
]

function is(value, name, fn) {
	let result
	try {
		result = fn(value) ? name : ''
	} catch (ignored) {
		result = `err(${name})`
	}
	return result
}

function format(value, nameFn) {
	const name = nameFn[0]
	const fn = nameFn[1]
	return fn ? is(value, name, fn) : name
}

function nameLine(name) {
	return (line) => `${name}: ${line.trim().replace(/  */g, ' ')}`
}

function debug(name, value) {
	function classify(nameFn) {
		return format(value, nameFn)
	}
	const result = identifiers
		.map(classify)
		.join(' ')
		.split(/\n/)
		.map(trim)
		.filter(length)
		.map(nameLine(name))
	return result
}

export default function lodebug(name, value, konsole = console.log) {
	debug(name, value).map(konsole)
}
