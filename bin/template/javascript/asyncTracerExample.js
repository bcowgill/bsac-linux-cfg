// A tiny little tool for tracing through node's asynchronous callbacks

const TRACE = true;

// const { trace } = asyncTracer('ModuleName', TRACE);
const { trace } = require('./asyncTracer')('ModuleName', TRACE);

var fs = require('fs');

fs.readFile('DATA', 'utf8', trace(function(err, contents) {
  if (!err) {
    console.log('contents', contents);
  }
}, 'readFile'));

fs.readFile('/etc/passwd', 'utf8', trace(function(err, contents) {
  if (!err) {
    console.log('contents', contents);
  }
}, 'readFile2'));
