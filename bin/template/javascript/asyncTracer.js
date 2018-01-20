// A tiny little tool for tracing through node's asynchronous callbacks
module.exports = function asyncTracer(group = 'Async', traceOn = false) {
  const log = console;
  const identity = v => v;
  const make = traceOn ? identity : fn => identity;

  const label = make((l) => {
    return (v) => { log.info(`${group}@${l}`, v); return v; };
  });

  const warn = make((l) => {
    return (v) => { log.warn(`${group}@${l}`, v); return v; };
  });

  const error = make((l) => {
    return (v) => { log.error(`${group}@${l}`, v); return v; };
  });

  const trap = make((fn, l) => {
    return (err, data) => {
      let out;
      label(`${l} in`)('');
      if (err) {
        error(`${l} error`)(err);
      }
      else {
        label(`${l} data`)(data);
      }
      try {
        out = fn(err, data);
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

  return { trace, label, error, warn };
}
