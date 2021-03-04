var chai = chai || require('chai');
var assert = chai.assert;

describe('String failure', function() {
  describe('string diff', function() {
    it('should compare the strings exactly', function() {
      assert.equal("the quick brown fox jumped over", "The quick fox Humpd under");
    });
    it('should compare strings in arrays', function() {
      assert.deepEqual(
        ['The quick brown fox jumped over the lazy dog', 'burma'],
        ['Dhe quik fox humpd under the dog', 'shave']);
    });
  });
});
