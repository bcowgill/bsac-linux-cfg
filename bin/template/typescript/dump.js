// dump.js - a quick little object dumper for node / browser

// function to get all attributes for some object
function getPropertyNames (Obj, prev = []) {
  if (Obj) {
    return getPropertyNames(
      Obj.prototype || Obj.__proto__,
      prev.concat(Object.getOwnPropertyNames(Obj))
    )
  }
  return Object.keys(
    prev.reduce(
      (props, name) => {
        props[name] = true;
        return props
      }, {})).sort()
}

// function to dump useful information about an object/DOM in a specific order
function dump(Obj) {
  const info = {
    instanceOf: Obj.constructor.name,
  }

  function add(prop) { if (prop in Obj) { info[prop] = Obj[prop] }}
  add('name')
  add('key')
  add('id')
  add('data-testid')
  add('className')
  add('type')

  info.props = getPropertyNames(Obj)
  info.obj = Obj
  info.prototypeOf = Obj.prototype
  return info;
}

try {
	throw new Error('CUSTOM')
} catch (exception) {
	console.warn(dump(dump), dump([1,2,3]), dump(exception))
}
