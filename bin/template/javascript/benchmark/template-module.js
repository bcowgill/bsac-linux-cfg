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

// Your module code goes here...

	/*--------------------------------------------------------------------------*/

	// Export the ... function or object.
	var exportMe = MyExport;
	var exportName = 'GlobalName';

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
