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
		console.error(exception);
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
	return obj;
}

function tryMe (fn) {
	try {
		fn();
	}
	catch (exception) {
		console.error(exception);
	}
}

function poke (obj) {
	// console.log('obj', obj);

	tryMe(function setX () {
		obj.x = 23;
	});
	// console.log('obj after x = 23', obj);
	it('should be frozen for .x = 23', function testPokeX () {
		assert.deepEqual(obj, getObj());
	});

	tryMe(function changeList () {
		obj.list[1] = 88;
	});
	// console.log('obj after list change 1 = 88', obj);
	it('should be frozen for .list[1] = 88', function testPokeList () {
		assert.deepEqual(obj, getObj());
	});

	tryMe(function pushList () {
		obj.list.push(5);
	});
	// console.log('obj after list push 5', obj);
	it('should be frozen for .list.push 5', function testPokeListPush () {
		assert.deepEqual(obj, getObj());
	});

	tryMe(function setProp () {
		obj.props.b = 1;
	});
	// console.log('obj after props b = 1', obj);
	it('should be frozen for .props.b = 1', function testPokePropSet () {
		assert.deepEqual(obj, getObj());
	});

	tryMe(function addProp () {
		obj.props.c = 12;
	});
	// console.log('obj after props c = 12', obj);
	it('should be frozen for .props.c = 12', function testPokePropNew () {
		assert.deepEqual(obj, getObj());
	});

	tryMe(function delProp () {
		delete obj.props.a;
	});
	// console.log('obj after delete props a', obj);
	it('should be frozen for delete .props.a', function testPokePropDelete () {
		assert.deepEqual(obj, getObj());
	});
}

console.log('freeze obj');
poke(freeze(getObj()));

console.log('deepFreeze obj');
poke(deepFreeze(getObj()));

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
