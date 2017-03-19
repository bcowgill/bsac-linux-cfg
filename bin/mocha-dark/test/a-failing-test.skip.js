var chai = chai || require('chai');
var assert = chai.assert;

describe('String failure', function() {
  describe('string diff', function() {
    it('should compare the strings exactly', function() {
      assert.equal("the quick brown fox jumped over", "The quick fox Humpd under");
    });
  });
});
