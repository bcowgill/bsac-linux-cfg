// A tiny little tool for tracing through promises
export default function promiseTracer(group = 'Promise', traceOn = false) {
  const log = console;
  const identity = v => v;
  const make = traceOn ? identity : fn => identity;

  const label = make((l) => {
    return (v) => { log.debug(`${group}@${l}`, v); return v; };
  });

  const warn = make((l) => {
    return (v) => { log.warn(`${group}@${l}`, v); return v; };
  });

  const error = make((l) => {
    return (v) => { log.error(`${group}@${l}`, v); return v; };
  });

  const trap = make((fn, l) => {
    return (v) => {
      let out;
      label(`${l} in`)(v);
      try {
        out = fn(v);
        label(`${l} out`)(out);
      }
      catch (exception)
      {
        error(`${l} throws`)(exception);
        throw exception;
      }
      return out;
    };
  });

  const trace = make((fn, l) => {
    if ('function' === typeof fn) {
      return trap(fn, l);
    }
    return label(fn);
  });

  const capture = make((fn, l) => {
    return (v) => {
      let out;
      warn(`${l} in`)(v);
      try {
        out = fn(v);
        warn(`${l} out`)(out);
      }
      catch (exception)
      {
        error(`${l} throws`)(exception);
        throw exception;
      }
      return out;
    };
  });

  const caught = make((fn, l) => {
    if ('function' === typeof fn) {
      return capture(fn, l);
    }
    return error(fn);
  });

  return { trace, caught, label, error, warn };
}
