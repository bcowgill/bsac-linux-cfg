// a test of ES6 features
export default function testES6() {
  return () => {
    // classes are ES6
    class pt {
      // default values are ES6
      constructor(x = 0, y = 0) {
        this.x = x;
        this.y = y;
        // arrow functions and template strings are ES6 features
        this.toString = () => `(${this.x}, ${this.y})`;
      }
      // enhanced object literals in ES6 (shorthand method definitions)
      magnitude() {
        // const is ES6f
        const mag = this.x * this.x + this.y * this.y;
        return Math.sqrt(mag);
      }
    }

    // enhanced object literals in ES6 (shorter object key/values)
    return {
      pt
    };
  }
}
