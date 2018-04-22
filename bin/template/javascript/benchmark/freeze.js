var assert = require('assert');

function describe (description, fnTest) {
	console.log(description);
	fnTest();
}

function it (description, fnTest) {
	try {
		fnTest();
		console.log('   ✔ ' + description);
	}
	catch (exception) {
		console.error('   ✖ ' + description);
		console.error('      ' + exception.name + ' ' + exception.operator);
		console.error('      expected: ', exception.expected);
		console.error('           got: ', exception.actual);
		// console.error(exception);
    }
}

function getObj () {
	var obj = {
		x: 13,
		list: [1,2,3],
		props: { a: 12, b: 34 },
	};
	return obj;
}

/**
 * Iterates over an object's own properties, executing the `callback` for each.
 *
 * @private
 * @param {Object} object The object/array to iterate over.
 * @param {Function} callback The function executed per own property.
 */
function forOwn(object, callback) {
	for (var key in object) {
		if (hasOwnProperty.call(object, key)) {
			callback(object[key], key, object);
		}
	}
}

function freeze (obj) {
	Object.freeze(obj);
	return obj;
}

function deepFreeze (obj) {
	if (obj !== null && typeof obj === 'object') {
		forOwn(obj, function freezeEach (value) {
			deepFreeze(value);
		});
	}
	Object.freeze(obj);
	return obj;
}

function clone (obj) {
	return Object.assign({}, obj);
}

function deepClone (obj) {
	var newObj = obj;
	// return JSON.parse(JSON.stringify(obj));
	if (obj !== null && typeof obj === 'object') {
		newObj = Array.isArray(obj) ? [] : {};
		forOwn(obj, function cloneEach (value, key) {
			newObj[key] = deepClone(value);
		});
	}
	return newObj;
}

function tryMe (fn) {
	try {
		fn();
	}
	catch (exception) {
		console.error('      ' + exception);
	}
}

function pokeTest (obj, desc, fnMutate) {
	tryMe(fnMutate(obj));
	it(desc, function testPoke () {
		assert.deepEqual(obj, getObj());
	});
}

function pokeOkTest (obj, desc, fnMutate, fnTest) {
	tryMe(fnMutate(obj));
	it(desc, function testPokeOk () {
		fnTest();
	});
}

function poke (obj) {
	pokeTest(obj, 'should be frozen for .x = 23', function setX (obj) {
		return (function setObjX () { obj.x = 23; });
	});

	pokeTest(obj, 'should be frozen for .list[1] = 88', function changeList (obj) {
		return (function changeObjList () { obj.list[1] = 88; });
	});

	pokeTest(obj, 'should be frozen for .list.push 5', function pushList (obj) {
		return (function pushObjList () { obj.list.push(5); });
	});

	pokeTest(obj, 'should be frozen for .props.b = 1', function setProp (obj) {
		return (function setObjProp () { obj.props.b = 1; });
	});

	pokeTest(obj, 'should be frozen for .props.c = 12', function addProp (obj) {
		return (function addObjProp () { obj.props.c = 12; });
	});

	pokeTest(obj, 'should be frozen for delete .props.a', function delProp (obj) {
		return ( function delObjProp () { delete obj.props.a; });
	});
}

function pokeOk (obj) {
	pokeOkTest(obj, 'should be mutable for .x = 23', function setXOk (obj) {
		return (function setObjX () { obj.x = 23; });
	}, function testSetXOk () {
		assert.equal(obj.x, 23);
	});

	pokeOkTest(obj, 'should be mutable for .list[1] = 88', function changeList (obj) {
		return (function changeObjList () { obj.list[1] = 88; });
	}, function testChangeObjListOk () {
		assert.equal(obj.list[1], 88);
	});

	pokeOkTest(obj, 'should be mutable for .list.push 5', function pushList (obj) {
		return (function pushObjList () { obj.list.push(5); });
	}, function testPushObjListOk () {
		assert.equal(obj.list[obj.list.length - 1], 5);
	});

	pokeOkTest(obj, 'should be mutable for .props.b = 1', function setProp (obj) {
		return (function setObjProp () { obj.props.b = 1; });
	}, function testSetPropOk () {
		assert.equal(obj.props.b, 1);
	});

	pokeOkTest(obj, 'should be mutable for .props.c = 12', function addProp (obj) {
		return (function addObjProp () { obj.props.c = 12; });
	}, function testAddPropOk () {
		assert.equal(obj.props.c, 12);
	});

	pokeOkTest(obj, 'should be mutable for delete .props.a', function delProp (obj) {
		return ( function delObjProp () { delete obj.props.a; });
	}, function testDelPropOk () {
		assert.equal('a' in obj.props, false);
	});
}

describe('suite getObj', function suiteGetObj () {
	it('should return object', function testGetObj () {
		assert.deepEqual(getObj(), {
			x: 13,
			list: [1,2,3],
			props: { a: 12, b: 34 },
		});
	});
});

describe('suite freeze', function suiteFreeze () {
	it('should return frozen null', function testFreezeNull () {
		assert.equal(
			freeze(null),
			null);
	});
	it('should return frozen undefined', function testFreezeUndefined () {
		assert.equal(
			freeze(),
			void 0);
	});
	it('should return frozen NaN', function testFreezeNaN () {
		assert.ok(
			isNaN(freeze(NaN))
		);
	});
	it('should return frozen Infinity', function testFreezeInfinity () {
		assert.equal(
			freeze(Infinity),
			Infinity);
	});
	it('should return frozen string', function testFreezeString () {
		assert.equal(
			freeze(''),
			'');
	});
	it('should return frozen true', function testFreezeTrue () {
		assert.equal(
			freeze(true),
			true);
	});
	it('should return frozen number', function testFreezeNumber () {
		assert.equal(
			freeze(42),
			42);
	});
});

describe('suite freeze obj [not recursively immutable]', function suiteFreezeObj () {
	poke(freeze(getObj()));
});

describe('suite deepFreeze obj [immutable all the way down]', function suiteDeepFreezeObj () {
	poke(deepFreeze(getObj()));
});

describe('suite clone obj [not recursively separate]', function suiteCloneObj () {
	var obj = getObj();
	pokeOk(clone(obj));
	it('should leave original object as is', function testOriginal () {
		assert.deepEqual(obj, getObj());
	});
});

describe('suite deepClone obj [completely separate objects]', function suiteDeepCloneObj () {
	var obj = getObj();
	pokeOk(deepClone(obj));
	it('should leave original object as is', function testOriginalDeep () {
		assert.deepEqual(obj, getObj());
	});
});
