;(function() {
	'use strict';

	/** Used to determine if values are of the language type `Object`. */
	var objectTypes = {
		'function': true,
		'object': true
	};

	/** Used as a reference to the global object. */
	var root = (objectTypes[typeof window] && window) || this;

	/** Backup possible global object. */
	var oldRoot = root;

	/** Detect free variable `exports`. */
	var freeExports = objectTypes[typeof exports] && exports;

	/** Detect free variable `module`. */
	var freeModule = objectTypes[typeof module] && module && !module.nodeType && module;

	/** Detect free variable `global` from Node.js or Browserified code and use it as `root`. */
	var freeGlobal = freeExports && freeModule && typeof global == 'object' && global;
	if (freeGlobal && (freeGlobal.global === freeGlobal || freeGlobal.window === freeGlobal || freeGlobal.self === freeGlobal)) {
		root = freeGlobal;
	}

	/*--------------------------------------------------------------------------*/

// The data set to test against, shoule be representative of what the function really sees
// in the correct distribution
var Data = [
	'',
	'o',
	'ao',
	'aao',
	'aaao',
	'iaaao',
	'iiaaao',
	'iiiaaao',
	'iiiiaaao',
	'iiiiiaaao',
	'iiiiiiaaao',
	'Hello World!',
];

// Each test function should operate on the data set in sequence
function makeDataSetTest (fn) {
	var idx = -1;
	var length = Data.length;
	return function findProgressive () {
		++idx;
		return fn(Data[idx % length]);
	}
}

var Tests = {
	//'Baseline': makeDataSetTest(function NoopTest () {}),
	'RegExp#test': makeDataSetTest(function RegExpTest (string) {
		/o/.test(string);
	}),
	'String#indexOf': makeDataSetTest(function StringIndexOfTest(string) {
		string.indexOf('o') > -1;
	}),
	'String#match': makeDataSetTest(function StringMatchTest(string) {
		!!string.match(/o/);
	})
};

	/*--------------------------------------------------------------------------*/

	// Export the Tests object.
	var exportMe = Tests;
	var exportName = 'TestFind';

	/**
	* Iterates over an object's own properties, executing the `callback` for each.
	*
	* @private
	* @param {Object} object The object to iterate over.
	* @param {Function} callback The function executed per own property.
	*/
	function forOwn(object, callback) {
		for (var key in object) {
			if (hasOwnProperty.call(object, key)) {
				callback(object[key], key, object);
			}
		}
	}

	// Some AMD build optimizers, like r.js, check for condition patterns like the following:
	if (typeof define == 'function' && typeof define.amd == 'object' && define.amd) {
		// Expose our export on the global object to prevent errors when we are
		// loaded by a script tag in the presence of an AMD loader.
		// See http://requirejs.org/docs/errors.html#mismatch for more details.
		root[exportName] = exportMe;

		// Define as an anonymous module so our export can be aliased through path mapping.
		define(function() {
			return exportMe;
		});
	}
	// Check for `exports` after `define` in case a build optimizer adds an `exports` object.
	else if (freeExports && freeModule) {
		if (typeof exportMe !== 'object' || Array.isArray(exportMe) || exportMe === null) {
			freeModule.exports = exportMe;
		}
		else {
			// Export for CommonJS support.
			forOwn(exportMe, function(value, key) {
				freeExports[key] = value;
			});
		}
	}
	else {
		// Export to the global object.
		root[exportName] = exportMe;
	}
}.call(this));
