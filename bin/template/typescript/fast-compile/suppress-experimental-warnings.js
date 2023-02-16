/* eslint-env node */

const defaultEmit = process.emit

const message = /Custom ESM Loaders is an experimental feature./

// function to get all attributes for some object
function getPropertyNames(Obj, prev = []) {
	if (Obj) {
		return getPropertyNames(
			Obj.prototype || Obj.__proto__,
			prev.concat(Object.getOwnPropertyNames(Obj)),
		)
	}
	return Object.keys(
		prev.reduce((props, name) => {
			props[name] = true
			return props
		}, {}),
	).sort()
}

/*
// hidePII - Personally Identifiable Information
// sensitive info like a password is fully obscured like ****.
// other info is partially o******d.
function hidePII(info, piiLevel) {
	let hidden = info
	if (piiLevel > 1) {
		// passwords obscure all
		hidden = info.replace(/./g, '*')
		// MUSTDO add random # of characters
	} else if (piiLevel > 0) {
		// non-password obscure insides
		hidden = info
			.replace(/\d/g, '0')
			.replace(/(\w)(\w*)(\w)/g, function hideInside() {
				return 'o******d'
			})
	}
	return hidden
}
*/

// function to dump useful information about an object/DOM in a specific order
// eslint-disable-next-line @typescript-eslint/no-unused-vars
function dump(Obj) {
	const info = {
		instanceOf: Obj.constructor.name,
	}

	function add(prop) {
		if (prop in Obj) {
			info[prop] = Obj[prop]
		}
	}
	add('name')
	add('key')
	add('id')
	add('data-testid')
	add('className')
	add('type')

	info.props = getPropertyNames(Obj)
	info.obj = Obj
	info.prototypeOf = Obj.prototype
	return info
}

process.emit = function (...args) {
	const error = args[1]
	if (error.name === 'ExperimentalWarning' && message.test(error.message)) {
		// console.warn(dump(error))
		return undefined
	}

	return defaultEmit.call(this, ...args)
}
