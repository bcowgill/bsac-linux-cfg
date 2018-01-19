// A tiny little tool for tracing through promises

export default function promiseTracer(group = 'Promise', traceOn = false) {
  const log = console;
  const identity = v => v;
  const make = traceOn ? identity : fn => identity;

  const label = make((l) => {
    return (v) => { log.debug(`${group}@${l}`, v); return v; };
  });

  const error = make((l) => {
    return (v) => { log.error(`${group}@${l}`, v); return v; };
  });

  const trace = make((fn, l) => {
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

  return { trace, label, error };
}
