
var chai = chai || require('chai');
var assert = chai.assert;

var testMe = require('./object');

describe('src/object.spec.js', function() {
describe('Object', function() {
  describe('#keys()', function() {
    it('should return object keys', function() {
      assert.deepEqual([ 'name' ], Object.keys(testMe));
    });
  });
});
});
