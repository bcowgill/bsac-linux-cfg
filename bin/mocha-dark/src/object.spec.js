var assert = require('assert');

var testMe = require('./object');

describe('Object', function() {
  describe('#keys()', function() {
    it('should return object keys', function() {
      assert.deepEqual([ 'name' ], Object.keys(testMe));
    });
  });
});
