// id.js - some utilities for html element id's

// peek() - call the thing if it's a function
function peek(thing)
{
	let value;
	if (typeof thing === 'function')
	{
		value = thing();
	}
	return value;
}

// notObj() - return the thing if it's not strictly an object
function notObj(thing = {})
{
	let value;
	if (Array.isArray(thing))
	{
		value = thing;
	}
	else
	{
		value = typeof thing !== 'object' ? thing : value;
	}
	return value;
}

// prop() - return a named property from an object defaults to 'id' property
function prop(thing = {}, name = 'id')
{
	let value;
	if (thing !== null && typeof thing === 'object')
	{
		if (name in thing)
		{
			value = thing[name];
		}
	}
	return value;
}

// idArray() - convert an array into an id string
function idArray(list = [])
{
	return list.join('-').replace(/[^a-z0-9]/gi, '-').replace(/--+/g, '-').replace(/(-$|^-)/g, '');
}

// id() - convert all arguments into an id string
function id(...args)
{
	return idArray(args.map(function mapToId(thing) {
		return peek(thing) || prop(prop(thing, 'state')) || prop(prop(thing, 'props')) || prop(thing) || notObj(thing);
	}));
}

//=================================================================
// Tiny testing framework...

let testNumber = 0;
let passNumber = 0;
let failNumber = 0;

const SHORT = 32;
const ELLIPSIS = '...' // '…'

// stringme() - ensure something is a string so it can be compared/shortened/logged
function stringme(value)
{
	if (value === null)
	{
		return 'null';
	}
	if (typeof value === 'object')
	{
		if (value instanceof RegExp)
		{
			return value.toString();
		}
		return JSON.stringify(value);
	}
	return `${value}`;
}

// short() - shorten a string to fixed length inserting ELLIPSIS in the middle
function short(value)
{
	const show = stringme(value);
	const shorter = show.substr(0, SHORT);
	return show === shorter ? show : `${show.substr(0, SHORT / 2)}${ELLIPSIS}${show.substr(show.length - SHORT / 2)}`;
}

// ok() - show a test that passes
function ok(got, assertion = '', description = '')
{
	++testNumber;
	++passNumber;
	console.debug(`OK ${testNumber} ${assertion}(${short(got)}) ${description}`.trim());
}

// fail() - show a test that failed
function fail(got, expect, assertion = '', description = '')
{
	++testNumber;
	++failNumber;
	console.warn(`NOT OK ${testNumber} ${assertion}([${short(got)}], [${short(expect)}]) ${description}`.trim(), {
		expect, got
	});
}

// isSame() - assert that one thing is strictly the same as the other thing
function isSame(got, expect, description = '')
{
	if (got === expect)
	{
		ok(got, 'isSame', description);
	}
	else
	{
		fail(got, expect, 'isSame', description);
	}
}

//=================================================================

function getId(id)
{
	return () => id;
}

function test()
{
	const EAR = [];

	isSame(stringme(), 'undefined', 'stringme()');
	isSame(stringme(null), 'null', 'stringme(null)');
	isSame(stringme(42), '42', 'stringme(42)');
	isSame(stringme(NaN), 'NaN', 'stringme(NaN)');
	isSame(stringme({}), '{}', 'stringme({})');
	isSame(stringme([]), '[]', 'stringme([])');
	isSame(stringme(/^this$/i), '/^this$/i', 'stringme(regex)');
	isSame(stringme(new RegExp('^This$', 'gi')), '/^This$/gi', 'stringme(regex)');

	isSame(short(), 'undefined', 'short()')
	isSame(short(null), 'null', 'short(null)')
	isSame(short({}), '{}', 'short({})')
	isSame(short([]), '[]', 'short([])')
	isSame(short('message'), 'message', 'short(message)')
	isSame(short('messagesss123456789rA123456789B123456789C'), 'messagesss123456' + ELLIPSIS + '56789B123456789C', 'short(long...)')

	isSame(peek(), undefined, 'peek()');
	isSame(peek(null), undefined, 'peek(null)');
	isSame(peek(88), undefined, 'peek(88)');
	isSame(peek(getId(1002)), 1002, 'peek(()=>1002)');

	isSame(notObj(), undefined, 'notObj()');
	isSame(notObj(null), undefined, 'notObj(null)');
	isSame(notObj(43), 43, 'notObj(43)');
	isSame(notObj({id: 45}), undefined, 'notObj({id:45})');
	isSame(notObj(EAR, 'pid'), EAR, 'notObj([], pid)');

	isSame(prop(), undefined, 'prop()');
	isSame(prop(null), undefined, 'prop(null)');
	isSame(prop(43), undefined, 'prop(43)');
	isSame(prop({id: 45}), 45, 'prop({id:45})');
	isSame(prop({pid: 45}, 'pid'), 45, 'prop({pid:45}, pid)');
	isSame(prop([], 'pid'), undefined, 'prop([], pid)');
	isSame(prop([34], 0), 34, 'prop([34], 0)');

	isSame(idArray(), '', 'idArray()');
	isSame(idArray([1,2,,3]), '1-2-3', 'idArray([1,2,,3])');
	isSame(idArray([1,'_2-',,3]), '1-2-3', 'idArray([1,_2-,,3])');
	isSame(idArray([,,1,false,3,null]), '1-false-3', 'idArray([complex...])');

	isSame(id(), '', 'id()');
	isSame(id([1,2,,3], 'id', [3,[4]]), '1-2-3-id-3-4', 'id([1,2,,3],id,[3,4])');
	isSame(id([1,2,,3], 'id', {}, getId(1001), {id: 56, 3:4, props: {id: 453}, state: {id: 987}}), '1-2-3-id-1001-987', 'id([1,2,,3],id,object,function)');
	isSame(id([[1,2,,3], 'id', {}, getId(1001), {id: 56, 3:4, props: {id: 453}, state: {id: 987}}]), '1-2-3-id-1001-987', 'id([1,2,,3],id,object,function)');
}

test();
