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

function StudentRecordClosure(name, major, gpa) {
	return function printStudent(){
		return name + ', Major: ' + major + ', GPA: ' + gpa.toFixed(1);
	};
}

//-------------------------------------
function StudentRecord(){
	return this.name + ', Major: ' + this.major + ', GPA: ' + this.gpa.toFixed(1);
}

function StudentRecordObject(name, major, gpa) {
	var student = StudentRecord.bind({
		name: name,
		major: major,
		gpa: gpa
	});
	return student;
}

//-------------------------------------
function StudentRecordNew(name, major, gpa) {
	this.name = name;
	this.major = major;
	this.gpa = gpa;
}
StudentRecordNew.prototype.studentInfo = StudentRecord;

//-------------------------------------
function StudentRecordPrivate(name, major, gpa) {
	return {
		studentInfo: function () {
			return name + ', Major: ' + major + ', GPA: ' + gpa.toFixed(1);
        }
	};
}

//-------------------------------------
class StudentRecordClass {
	constructor (name, major, gpa) {
		this.name = name;
		this.major = major;
		this.gpa = gpa;
	}
	studentInfo () {
		return this.name + ', Major: ' + this.major + ', GPA: ' + this.gpa.toFixed(1);
	}
}

// Your module code goes here...
var Tests = [
	{
	    'Closure#objcreate': function ObjectCreateClosureTest () {
			StudentRecordClosure('John Smith', 'PH', 3.2)();
	    },
	    'Object#objcreate': function ObjectCreateObjectTest () {
			StudentRecordObject('John Smith', 'PH', 3.2)();
	    },
	    'Constructor#objcreate': function ObjectCreateConstructorTest () {
			var student = new StudentRecordNew('John Smith', 'PH', 3.2);
			student.studentInfo();
	    },
	    'Private#objcreate': function ObjectCreatePrivateTest () {
			var student = StudentRecordPrivate('John Smith', 'PH', 3.2);
			student.studentInfo();
	    },
	    'Class#objcreate': function ObjectCreateClassTest () {
			var student = new StudentRecordClass('John Smith', 'PH', 3.2);
			student.studentInfo();
	    }
	},
	{
	    'Closure10#objcreate': function ObjectCreateClosureCall10Test () {
			var studentInfo = StudentRecordClosure('John Smith', 'PH', 3.2);
			var result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
	    },
	    'ObjectCall10#objcreate': function ObjectCreateCbjectCall10Test () {
			var studentInfo = StudentRecordObject('John Smith', 'PH', 3.2);
			var result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
	    },
	    'ConstructorCall10#objcreate': function ObjectCreateConstructorCall10Test () {
			var student = new StudentRecordNew('John Smith', 'PH', 3.2);
			var result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
	    },
	    'PrivateCall10#objcreate': function ObjectCreatePrivateCall10Test () {
			var student = StudentRecordPrivate('John Smith', 'PH', 3.2);
			var result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
	    },
	    'ClassCall10#objcreate': function ObjectCreateClassCall10Test () {
			var student = new StudentRecordClass('John Smith', 'PH', 3.2);
			var result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
	    }
	}
];

	/*--------------------------------------------------------------------------*/

	// Export the ... function or object.
	var exportMe = Tests;
	var exportName = 'TestClosureObj';

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
