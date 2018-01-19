// http://bevacqua.github.io/promisees/#code=%2F%2F+A+tiny+little+tool+for+tracing+through+promises%0A%0A%2F%2F+export+default%0Afunction+promiseTracer(group+%3D+'Promise'%2C+traceOn+%3D+false)+%7B%0A++const+log+%3D+console%3B%0A++const+identity+%3D+v+%3D%3E+v%3B%0A++const+make+%3D+(fn)+%3D%3E+traceOn+%3F+fn+%3A+identity%3B%0A%0A++const+label+%3D+make((l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B+log.debug(%60%24%7Bgroup%7D%40%24%7Bl%7D%60%2C+v)%3B+return+v%3B+%7D%3B%0A++%7D)%3B%0A%0A++const+error+%3D+make((l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B+log.error(%60%24%7Bgroup%7D%40%24%7Bl%7D%60%2C+v)%3B+return+v%3B+%7D%3B%0A++%7D)%3B%0A%0A++const+trace+%3D+make((fn%2C+l)+%3D%3E+%7B%0A++++return+(v)+%3D%3E+%7B%0A++++++let+out%3B%0A++++++label(%60%24%7Bl%7D+in%60)(v)%3B%0A++++++try+%7B%0A++++++++out+%3D+fn(v)%3B%0A++++++++label(%60%24%7Bl%7D+out%60)(out)%3B%0A++++++%7D%0A++++++catch+(exception)%0A++++++%7B%0A++++++++error(%60%24%7Bl%7D+throws%60)(exception)%3B%0A++++++++throw+exception%3B%0A++++++%7D%0A++++++return+out%3B%0A++++%7D%3B%0A++%7D)%3B%0A%0A++return+%7B+trace%2C+label%2C+error+%7D%3B%0A%7D%0A%2F%2F+%3D%3D%3D+end+of+module+%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%3D%0A%0A%2F%2F+Usage%3A%0Aconst+TRACE+%3D+true%3B%0A%0A%2F%2F+const+%7Btrace%2C+label%2C+error%7D+%3D+require('promiseTracer')('ModuleName'%2C+TRACE)%3B%0A%2F%2F+or%0A%2F%2F+import+promiseTracer+from+'promiseTracer'%3B%0Aconst+%7Btrace%2C+label%2C+error%7D+%3D+promiseTracer('ModuleName'%2C+TRACE)%3B%0A%0Avar+p+%3D+fetch('%2Ffoo')%0A++.then(%0A++++trace(res+%3D%3E+res.status%2C+'then+fulfilled+A')%0A++++%2C+error('then+rejected+a')%0A++)%0A%0Ap.catch(error('catch+b'))%0Ap.then(label('then+c'))%0Ap%0A++.then(trace(status+%3D%3E+status.a.b.c%2C+'then+B'))%0A++.catch(error('catch+d'))

// A tiny little tool for tracing through promises

// export default
function promiseTracer(group = 'Promise', traceOn = false) {
  const log = console;
  const identity = v => v;
  const make = (fn) => traceOn ? fn : identity;

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
// === end of module ================================

// Usage:
const TRACE = true;

// const {trace, label, error} = require('promiseTracer')('ModuleName', TRACE);
// or
// import promiseTracer from 'promiseTracer';
const {trace, label, error} = promiseTracer('ModuleName', TRACE);

var p = fetch('/foo')
  .then(
    trace(res => res.status, 'then fulfilled A')
    , error('then rejected a')
  )

p.catch(error('catch b'))
p.then(label('then c'))
p
  .then(trace(status => status.a.b.c, 'then B'))
  .catch(error('catch d'))

