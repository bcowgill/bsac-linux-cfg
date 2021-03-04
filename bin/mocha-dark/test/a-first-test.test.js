var chai = chai || require('chai');
var assert = chai.assert;

describe('test/a-first-test.test.js', function() {
describe('Array', function() {
  describe('#indexOf()', function() {
//  debugger;
    it('should return -1 when the value is not present', function() {
      var r = assert.equal(-1, [1, 2, 3].indexOf(4)); // result
    });
    it('should compare strings in arrays', function() {
      assert.deepEqual(
        ['The quick brown fox jumped over the lazy dog', 'burma shave'],
        ['The quick brown fox jumped over the lazy dog', 'bURMA SHAVe'.toLowerCase()]);
    });
  });
});
});
