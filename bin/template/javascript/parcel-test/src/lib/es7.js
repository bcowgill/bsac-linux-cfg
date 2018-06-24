// a test of ES2016 (ES7) features
export default function testES7() {
  return () => {
    // ES7 gives Arrays an includes() method similar to indexOf
    const included = ['a', 'b', 'c'].includes('a');
    const excluded = ['a', 'b', 'c'].includes('d');
    const findNaN = ['a', NaN, 'c'].includes(NaN); // indexOf can't do this
    const findUndef = ['a', undefined, 'c'].includes(); // indexOf can't do this
    // exponentiation operator is ES7
    const power2 = n => 2 ** n;
    return {
      included, excluded, findNaN, findUndef, power2
    };
  };
}
