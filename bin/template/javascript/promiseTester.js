// A quick little promise tester, use it on https://bevacqua.github.io/promisees/

var p = fine('/foo')
  .then(trace('then1'))
  .then(() => {
    return flub('/bar')
      .then(trace('then3'))
      .catch(trace('catch1'));
    })
    .catch(trace('catch2'));

function trace(label) {
  return (value) => {
    console.error(label, value)
  }
}

function fine(url) {
  return Promise.resolve('fine ' + url);
}

function flub(url) {
  return Promise.reject('flub ' + url);
}


// https://bevacqua.github.io/promisees/#code=var+p+%3D+fine('%2Ffoo')%0A++.then(trace('then1'))%0A++.then(()+%3D%3E+%7B%0A++++return+fine('%2Fbar')%0A++++++++.then(trace('then3'))%0A%2F%2F++++++++.catch(trace('catch1'))%0A++%7D)%0A++.catch(trace('catch2'))%0A%0Afunction+trace(label)+%7B%0A++return+(value)+%3D%3E+%7B%0A++++console.error(label%2C+value)%0A++%7D%0A%7D%0A%0Afunction+fine(url)+%7B%0A+++return+Promise.resolve('fine+'+%2B+url)++%0A%7D%0A%0Afunction+flub(url)+%7B%0A+++return+Promise.reject('flub+'+%2B+url)%0A%7D
