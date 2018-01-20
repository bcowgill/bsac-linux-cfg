// http://bevacqua.github.io/promisees/#code=%2F%2F+A+tiny+little+tool+for+tracing+through+promises%0A%0A%2F%2F+export+default%0Afunction+promiseTracer(group+%3D+'Promise'%2C+traceOn+%3D+false)+%7B%0A++const+log+%3D+console%3B%0A++const+identity+%3D+v+%3D%3E+v%3B%0A++const+make+%3D+traceOn+%3F+identity+%3A+fn+%3D%3E+identity%3B%0A%0A++const+label+%3D+make((l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B+log.debug(%60%24%7Bgroup%7D%40%24%7Bl%7D%60%2C+v)%3B+return+v%3B+%7D%3B%0A++%7D)%3B%0A%0A++const+warn+%3D+make((l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B+log.warn(%60%24%7Bgroup%7D%40%24%7Bl%7D%60%2C+v)%3B+return+v%3B+%7D%3B%0A++%7D)%3B%0A%0A++const+error+%3D+make((l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B+log.error(%60%24%7Bgroup%7D%40%24%7Bl%7D%60%2C+v)%3B+return+v%3B+%7D%3B%0A++%7D)%3B%0A%0A++const+trap+%3D+make((fn%2C+l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B%0A++++++let+out%3B%0A++++++label(%60%24%7Bl%7D+in%60)(v)%3B%0A++++++try+%7B%0A++++++++out+%3D+fn(v)%3B%0A++++++++label(%60%24%7Bl%7D+out%60)(out)%3B%0A++++++%7D%0A++++++catch+(exception)%0A++++++%7B%0A++++++++error(%60%24%7Bl%7D+throws%60)(exception)%3B%0A++++++++throw+exception%3B%0A++++++%7D%0A++++++return+out%3B%0A++++%7D%3B%0A++%7D)%3B%0A%0A++const+trace+%3D+make((fn%2C+l)+%3D%3E+%7B%0A++++if+('function'+%3D%3D%3D+typeof+fn)+%7B%0A++++++return+trap(fn%2C+l)%3B%0A++++%7D%0A++++return+label(fn)%3B%0A++%7D)%3B%0A%0A++const+capture+%3D+make((fn%2C+l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B%0A++++++let+out%3B%0A++++++warn(%60%24%7Bl%7D+in%60)(v)%3B%0A++++++try+%7B%0A++++++++out+%3D+fn(v)%3B%0A++++++++warn(%60%24%7Bl%7D+out%60)(out)%3B%0A++++++%7D%0A++++++catch+(exception)%0A++++++%7B%0A++++++++error(%60%24%7Bl%7D+throws%60)(exception)%3B%0A++++++++throw+exception%3B%0A++++++%7D%0A++++++return+out%3B%0A++++%7D%3B%0A++%7D)%3B%0A%0A++const+caught+%3D+make((fn%2C+l)+%3D%3E+%7B%0A++++if+('function'+%3D%3D%3D+typeof+fn)+%7B%0A++++++return+capture(fn%2C+l)%3B%0A++++%7D%0A++++return+error(fn)%3B%0A++%7D)%3B%0A%0A++return+%7B+trace%2C+caught%2C+label%2C+error%2C+warn+%7D%3B%0A%7D%0A%2F%2F+%3D%3D%3D+end+of+module+%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%0A%0A%2F%2F+Usage%3A%0Aconst+TRACE+%3D+true%3B%0A%0A%2F%2F+const+%7Btrace%2C+caught%2C+label%2C+error%2C+warn+%7D+%3D+require('promiseTracer')('ModuleName'%2C+TRACE)%3B%0A%2F%2F+or%0A%2F%2F+import+promiseTracer+from+'promiseTracer'%3B%0Aconst+%7Btrace%2C+caught+%7D+%3D+promiseTracer('ModuleName'%2C+TRACE)%3B%0A%0Avar+p+%3D+fetch('%2Ffoo')%0A++.then(%0A++++trace(res+%3D%3E+res.status%2C+'then+fulfilled+A')%2C%0A++++caught('then+rejected+a')%0A++)%3B%0A%0Ap.catch(caught('catch+b'))%3B%0Ap.then(trace('then+c'))%3B%0Ap%0A++.then(trace(status+%3D%3E+status.a.b.c%2C+'then+B'))%0A++.catch(caught('catch+d'))%3B%0A%0Anew+Promise((resolve%2C+reject)+%3D%3E+setTimeout(caught(reject%2C+'new+reject')%2C+8000))%3B

// A tiny little tool for tracing through promises

// export default
function promiseTracer(group = 'Promise', traceOn = false) {
  const log = console;
  const debug = console.debug || console.info || console.log;
  const identity = v => v;
  const make = traceOn ? identity : fn => identity;

  const label = make((l) => {
    return (v) => { debug(`${group}@${l}`, v); return v; };
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
// === end of module ================================

// Usage:
const TRACE = true;

// const {trace, caught, label, error, warn } = require('promiseTracer')('ModuleName', TRACE);
// or
// import promiseTracer from 'promiseTracer';
const {trace, caught } = promiseTracer('ModuleName', TRACE);

var p = fetch('/foo')
  .then(
    trace(res => res.status, 'then fulfilled A'),
    caught('then rejected a')
  );

p.catch(caught('catch b'));
p.then(trace('then c'));
p
  .then(trace(status => status.a.b.c, 'then B'))
  .catch(caught('catch d'));

new Promise((resolve, reject) => setTimeout(caught(reject, 'new reject'), 8000));
