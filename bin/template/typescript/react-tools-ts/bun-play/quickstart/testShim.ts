// make jest, mock etc available to tests without specific ref to bun
// is there a better way to do this?  export * from 'bun:test' did not work.
import * as T from 'bun:test';

export const afterAll = T.afterAll;
export const afterEach = T.afterEach;
export const beforeAll = T.beforeAll;
export const beforeEach = T.beforeEach;
export const describe = T.describe; // 5
export const expect = T.expect;
export const it = T.it;
export const jest = T.jest;
export const mock = T.mock;
export const setDefaultTimeout = T.setDefaultTimeout; // 10
export const setSystemTime = T.setSystemTime;
export const spyOn = T.spyOn;
export const test = T.test;
//export const vi = T.vi; // 14
//testShim.ts:17:21 - error TS2339: Property 'vi' does not exist on type 'typeof import("bun:test")

const bkeys = Object.keys(T).sort();
const exported = 14;
if (bkeys.length > exported) {
  console.warn(`bun:test some exports missed, need to add to the export const list above: }`, bkeys);
  expect(bkeys.length).toBe(exported);
}
