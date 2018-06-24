// a test of ES2017 (ES8) features
export default function testES8() {
  // string padding functions are ES8
  const rightJustify = width => string => string.padstart(width);
  const leftJustify = width => string => string.padEnd(width);
  // getting object values is ES8
  const orderedValues = obj => Object.values(obj).sort();
  // getting an object's entries is ES8
  const kvEntries = obj => Object.entries(obj);
  // getting my own property descriptors is ES8
  const introspectProps = obj => Object.getOwnPropertyDescriptors(obj);
  // trailing commas in function parameters are ES8
  console.log('es', '8', 'loves', 'commas',);

  return {
    rightJustify, leftJustify, orderedValues, kvEntries, introspectProps
  };
}
