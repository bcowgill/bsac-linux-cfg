// code-utilities.prod.js - utilities for functions without ordered arguments

// webpack includes this file in production using:
// import { from, empty, EOB } from 'code-utilities'

import {
  obj,
  EOB,
  fnOrObj,
  objThrow,
  overrideParameter
} from './code-utilities-common';

// from() - get function parameters from an object with defaults
// NOTE: unlike the spread operator, this will not let null/undefined
// override a default value
export function from(fnIn = EOB, intoIn = EOB) {
  const fn = fnOrObj(fnIn);
  const into = objThrow(intoIn);
  const defaults = obj(fn.defaults || fn.defaultProps || fn);
  const params = Object.keys(defaults).reduce(
    overrideParameter(into, defaults),
    {}
  );

  return params;
}

// empty() - get empty parameters based on existing parameters
// preserves the debug/trace option only.
export function empty(/* ...params */) {
  return {};
}

export function traceCalls(/* fn, params, intoIn */) {}

export * from './code-utilities-common';
