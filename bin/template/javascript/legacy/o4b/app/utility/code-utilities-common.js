// code-utilities-common.js - utilities for functions without ordered arguments

// a single point for an empty Object or Array
export const EST = '';
export const EOB = {};
export const EAR = [];

// visible - return it if it's a visible value
// a valid number or a non-blank string
export function visible(thing) {
  const type = typeof thing;
  if (type === 'string') {
    return thing.trim() === EST ? EST : thing;
  }
  if (type === 'number') {
    return !isFinite(thing) ? EST : `${thing}`;
  }
  return EST;
}

// nulls() - convert undefined to null everywhere
export function nulls(param) {
  let result;
  if (Array.isArray(param)) {
    result = param.reduce(function omitNullItems(out, item) {
      out.push(nulls(item));
      return out;
    }, []);
  } else if (param !== null && typeof param === 'object') {
    result = Object.keys(param).reduce(function omitNullValues(out, name) {
      out[name] = nulls(param[name]);
      return out;
    }, {});
  } else {
    result = param === undefined ? null : param;
  }
  return result;
}

// omit() - omit nulls and undefined everywhere
export function omit(param) {
  let result;
  if (Array.isArray(param)) {
    result = param.reduce(function pruneInvalidItems(out, item) {
      const value = omit(item);
      if (value) {
        out.push(value);
      }
      return out;
    }, []);
  } else if (param !== null && typeof param === 'object') {
    result = Object.keys(param).reduce(function pruneInvalidValues(out, name) {
      const value = omit(param[name]);
      if (value) {
        out[name] = value;
      }
      return out;
    }, {});
  } else {
    result = param === undefined || param === null ? undefined : param;
  }
  return result;
}

// its() - get something that's not null
export function its(param) {
  return param === null ? undefined : param;
}

// obj() - ensure something is an object
export function obj(into = EOB) {
  const param = its(into);
  return typeof param === 'object' ? param : EOB;
}

// objThrow() - ensure something is an object, throwing an error if not
export function objThrow(into = EOB) {
  const param = its(into);
  const type = typeof param;
  if (param !== undefined && !/^object$/.test(type)) {
    throw new TypeError(
      `you passed a parameter [${into}] by position into a function which expects an Object (it = EOB)`
    );
  }
  return type === 'object' ? param : EOB;
}

// fnOrObj() - ensure something is a function or an object
export function fnOrObj(into = EOB) {
  const param = its(into);
  return typeof param === 'function' || typeof param === 'object' ? param : EOB;
}

// nameOf() - return the name of the function or other thing that it is
export function nameOf(fnIn = EOB) {
  const fn = its(fnIn) || EOB;
  return fn
    .toString()
    .split('\n')[0]
    .replace(/^function\s+([^\s(]*).+$/, '$1')
    .replace(/^$/, 'anon')
    .replace(/^\[object Object\]$/, 'object')
    .replace(/^/, '[')
    .replace(/$/, ']');
}

// overrideParameter() - reduce() callback for overriding values in an object
export function overrideParameter(into, defaults) {
  return function overrideDefaults(out, name) {
    if (its(into[name]) !== undefined) {
      out[name] = into[name];
    } else {
      out[name] = its(defaults[name]);
    }
    return out;
  };
}
