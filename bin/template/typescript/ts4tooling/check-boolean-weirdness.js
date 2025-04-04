// This shows how Javascript primitives true/false and Boolean() wrapper object does
// not behave as you might expect when trying to negate or cat to boolean primitive.

// Proper way to negate a boolean:
function notB(me /* : boolean | Boolean */)/* : boolean */ {
	return me.constructor === Boolean && !me.valueOf();
}
// Proper way to cast to boolean:
function isB(me /* : boolean | Boolean */)/* : boolean */ {
	return me.constructor === Boolean && me.valueOf();
}

// Broken way to negate a boolean
function notBBroken(me /* : boolean | Boolean */)/* : boolean */ {
	return !me;
}
// Broken way to cast to a boolean
function isBBroken(me /* : boolean | Boolean */)/* : boolean */ {
	return !!me;
}

/*
typeof:boolean constr:Boolean inst:false not:false === false logicC:false  logicI:false me: true
typeof:object  constr:Boolean inst:true  not:false === false logicC:false  logicI:false me: [Boolean: true]
typeof:boolean constr:Boolean inst:false not:true  === true  logicC:true   logicI:false me: false
typeof:object  constr:Boolean inst:true  not:false === true  logicC:true   logicI:true me: [Boolean: false]
TRUE!! Not Falsy after all... me: [Boolean: false]
*/
/* eslint-disable @typescript-eslint/restrict-template-expressions */
function check(me /* : boolean | Boolean */)/* : void */ {
	console.log(
		`typeof:${typeof me} constr:${me.constructor.name} inst:${
			me instanceof Boolean
		} not:${!me} === ${!me.valueOf()} logicC:${
			me.constructor === Boolean && !me.valueOf()
		}  logicI:${
			me instanceof Boolean && !me.valueOf()
		} me:`,
		me,
	)

	if (typeof me === 'object') {
		//    13:33  warning  Unnecessary conditional, value is always falsy  @typescript-eslint/no-unnecessary-condition
		if (me instanceof Boolean && !me.valueOf()) {
			console.log('TRUE!! Not Falsy after all... me:', me)
		}
	}
}

check(true)
check(new Boolean(true))

check(false)
check(new Boolean())

console.warn(`\nBroken  !!me`, isBBroken(true), isBBroken(new Boolean(true)), isBBroken(false), isBBroken(new Boolean(false)))
console.warn(`Broken   !me`, notBBroken(true), notBBroken(new Boolean(true)), notBBroken(false), notBBroken(new Boolean(false)))

console.warn(`\nWorking !!me`, isB(true), isB(new Boolean(true)), isB(false), isB(new Boolean(false)))
console.warn(`Working  !me`, notB(true), notB(new Boolean(true)), notB(false), notB(new Boolean(false)))

