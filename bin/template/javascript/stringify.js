// a stringify which won't throw an error on cyclic objects

export default function stringify(obj = 'undefined') {
  let pretty;
  try {
    pretty = typeof obj === 'object' ? JSON.stringify(obj) : obj;
  } catch (exception) {
    pretty = `${obj} ${exception}`;
  }
  return pretty;
}
