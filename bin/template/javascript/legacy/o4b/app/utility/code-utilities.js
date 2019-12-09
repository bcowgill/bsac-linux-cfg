// code-utilities.js - utilities for functions without ordered arguments - development version with debug support

// webpack includes this file in development using:
// import { from, empty, EOB } from 'code-utilities'

import {
  obj,
  EOB,
  nameOf,
  fnOrObj,
  objThrow,
  overrideParameter
} from './code-utilities-common';

const TRACE_ALL = false; // true, or /MultiplePayment/i

// traceCalls() - logs a function call if TRACE_ALL or traceFrom has been set
export function traceCalls(fn, params, intoIn) {
  let debug = TRACE_ALL || params.traceFrom || params.spyFrom;
  if (debug) {
    const name = nameOf(fn);
    let copy = params;
    debug = '';
    if ('traceFrom' in params || 'spyFrom' in params) {
      debug = '*with debug*';
      copy = { ...params };
      delete copy.traceFrom;
      delete copy.spyFrom;
    }
    if (TRACE_ALL || params.traceFrom) {
      let trace = TRACE_ALL;
      if (TRACE_ALL instanceof RegExp) {
        trace = TRACE_ALL.test(name);
      }
      if (params.traceFrom instanceof RegExp) {
        if (params.traceFrom.test(name)) {
          trace = true;
        }
      } else if (params.traceFrom) {
        trace = true;
      }
      if (trace) {
        console.warn(`CALLED ${name}${debug}`, copy);
      }
    }
    if (params.spyFrom) {
      params.spyFrom(name, copy, intoIn);
    }
  }
}

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

  if ('traceFrom' in into) {
    params.traceFrom = into.traceFrom;
  }
  if ('spyFrom' in into) {
    params.spyFrom = into.spyFrom;
  }
  traceCalls(fn, params, intoIn);
  // END NOT IN PROD...

  return params;
}

// empty() - get empty parameters based on existing parameters
// preserves the debug/trace option only.
export function empty(...params) {
  const born = {};
  if (params) {
    params.reduceRight(function gatherDebugProps(out, intoIn) {
      const into = obj(intoIn);

      if (into !== EOB) {
        if ('traceFrom' in into && into.traceFrom) {
          out.traceFrom = into.traceFrom;
        }
        if ('spyFrom' in into && into.spyFrom) {
          out.spyFrom = into.spyFrom;
        }
      }
      return out;
    }, born);
  }
  // END NOT IN PROD...

  return born;
}

export * from './code-utilities-common';
