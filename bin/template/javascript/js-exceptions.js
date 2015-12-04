// js-exceptions.js
// standard javascript functions which throw errors instead of return codes
/* global window */

(function(exports, global) {
	'use strict';

	function _keysOf (object) {
		var keys = [];
		Object.keys(object).forEach(function (type) {
			if (type.match(/^[a-z]/i)) {
				keys.push(type);
			}
		});
		return keys.sort();
	}

	function _methodNamesOf (object) {
		var keys = [];
		Object.keys(object).forEach(function (type) {
			if (type.match(/^[a-z]/i) && 'function' === typeof object[type]) {
				keys.push(type);
			}
		});
		return keys.sort();
	}

	function _objectNamesOf (object) {
		var keys = [];
		Object.keys(object).forEach(function (type) {
			if (type.match(/^[a-z]/i) && 'object' === typeof object[type]) {
				keys.push(type);
			}
		});
		return keys.sort();
	}

	exports.exceptional = {

		'augment': function (typeName) {
			if (!typeName) {
				_objectNamesOf(exports.exceptional).forEach(function (type) {
					exports.exceptional.augment(type);
				});
				return;
			}

			var prototype, methods = exports.exceptional[typeName];
			if ('object' !== typeof methods) {
				throw new TypeError('cannot augment ' + typeName + '.prototype');
			}

			prototype = global[typeName].prototype;
			_methodNamesOf(methods).forEach(function (method) {
				var _super = method + 'Ex';

				if (prototype.hasOwnProperty(_super)) {
					throw new TypeError('cannot augment ' + typeName + '.prototype with method ' + _super + ' as that would overwrite an existing method');
				}
				prototype[_super] = function () {
					var args = Array.prototype.slice.call(arguments);
					args.unshift(this);
					return methods[method].apply(null, args);
				};
			});
			return prototype;
		},

		'unaugment': function (typeName) {
			if (!typeName) {
				_objectNamesOf(exports.exceptional).forEach(function (type) {
					exports.exceptional.unaugment(type);
				})
				return;
			}

			var prototype, methods = exports.exceptional[typeName];
			if ('object' !== typeof methods) {
				throw new TypeError('cannot unaugment ' + typeName + '.prototype');
			}

			prototype = global[typeName].prototype;
			_methodNamesOf(methods).forEach(function (method) {
				var _super = method + 'Ex';

				delete prototype[_super];
			});
			return prototype;
		},

		'String': {
			charAt: function (str, pos) {
				if (pos < 0 || pos >= str.length) {
					throw new RangeError('position given is outside the string: ' + pos);
				}
				return str.charAt(pos);
			},

			charCodeAt: function (str, pos) {
				if (pos < 0 || pos >= str.length) {
					throw new RangeError('position given is outside the string: ' + pos);
				}
				return str.charCodeAt(pos);
			},

			indexOf: function (str, find) {
				var where = str.indexOf(find);
				if (-1 === where) {
					throw new RangeError('string not found within target string: ' + find);
				}
				return where;
			},

			lastIndexOf: function (str, find) {
				var where = str.lastIndexOf(find);
				if (-1 === where) {
					throw new RangeError('string not found within target string: ' + find);
				}
				return where;
			},

			match: function (str, regex) {
				var matches = str.match(regex);
				if (!matches) {
					throw new RangeError('regex not found within target string: ' + regex);
				}
				return matches;
			},

			replace: function (str, regex, replace, flags) {
				var matched = false,
					fnReplace = typeof replace === 'function' ?
						function () {
							matched = true;
							return replace.apply(this, arguments);
						} :
						function () {
							matched = true;
							return replace;
						},
					replacement = str.replace(regex, fnReplace, flags);

				if (!matched) {
					throw new RangeError('regex not found within target string: ' + regex);
				}
				return replacement;
			},

			'-': '-'
		}
	};
})(typeof module === 'object' && typeof module.exports === 'object' ? module.exports : window, typeof global === 'object' ? global: window);
