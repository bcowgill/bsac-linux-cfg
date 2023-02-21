// A simple Javascript benchmark runner, to compare with Typescript version
const Benchmark = require('benchmark')

const suite = new Benchmark.Suite

// add tests
suite.add('RegExp#test', function() {
  /o/.test('Hello World!');
})
.add('String#indexOf', function() {
  'Hello World!'.indexOf('o') > -1;
})
// add listeners
.on('cycle', function(event) {
  console.log(String(event.target));
})
.on('complete', function() {
  const fastest = this.filter('fastest').map('name').join(',')
  console.log('Fastest is ' + fastest);
})
// run async
.run({ 'async': true });
