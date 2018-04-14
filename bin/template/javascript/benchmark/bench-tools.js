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

// Env.js -- subset
// Detecting your environment and getting access to the global object
// http://stackoverflow.com/questions/17575790/environment-detection-node-js-or-browser
// https://developer.mozilla.org/en-US/docs/Web/API/Window/self

var makeGet = function (globalVar) {
	return 'try { __global = __global || ' + globalVar + '} catch (exception) {}'
}

// eslint-disable-next-line no-new-func
var getGlobal = new Function(
	'var __global;'
	+ makeGet('window')
	+ makeGet('global')
	+ makeGet('WorkerGlobalScope')
	+ 'return __global;'
)

function _getOutputDiv (document, id) {
	var div;
	try {
		div = document.getElementById(id);
		if (!div) {
			var newDiv = document.createElement('div');
			newDiv.id = id;
			document.body.insertBefore(newDiv, document.body.firstChild);
			div = document.getElementById(id);
		}
	}
	finally { void 0 }
	return div;
}

function _addElement (document, message) {
	try {
		var newDiv = document.createElement('div')
			, newContent = document.createTextNode(message)
			, div = _getOutputDiv(document, 'spray-output-div');

		newDiv.appendChild(newContent)
		div.appendChild(newDiv);
	}
	finally { void 0 }
}

// Show a message in every possible place.
var spray = function () {
	var which = 'log';
	var ALERT_OK = false;

	var global = getGlobal()
		, args = Array.prototype.slice.call(arguments)
	if (global.document && global.document.body) {
		_addElement(global.document, args.join())
	}

	if (global.console && global.console[which]) {
		global.console[which].apply(global.console, args)
	}

	if (ALERT_OK && global.alert) {
		global.alert.apply(global, args)
	}
}
// End of Env.js subset

var Benchmark;
try {
	Benchmark = require('benchmark');
} catch (exception) {
	var global = getGlobal();
	Benchmark = global.Benchmark;
}

function runBenchmark (Tests, async, print) {
	print = print || spray;
	print('Benchmarks performed on ' + Benchmark.platform.description);

	var suite = new Benchmark.Suite;

	// add tests
	Object.keys(Tests).forEach(function AddTest (name) {
		suite.add(name, Tests[name]);
	});
	// add listeners
	suite.on('cycle', function(event) {
		print(String(event.target));
	})
	.on('complete', function() {
		print('Fastest is ' + this.filter('fastest').map('name'));
		print('.');
	})
	// run async
	.run({ 'async': !!async });
}

	/*--------------------------------------------------------------------------*/

	// Export the runBenchmark function.
	var exportMe = runBenchmark;
	var exportName = 'runBenchmark';

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
