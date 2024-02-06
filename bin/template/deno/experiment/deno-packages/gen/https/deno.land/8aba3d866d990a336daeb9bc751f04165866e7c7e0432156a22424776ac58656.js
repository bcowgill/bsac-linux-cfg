// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { AssertionError } from "./assertion_error.ts";
/**
 * Make an assertion that `actual` and `expected` are almost equal numbers
 * through a given tolerance. It can be used to take into account IEEE-754
 * double-precision floating-point representation limitations. If the values
 * are not almost equal then throw.
 *
 * @example
 * ```ts
 * import { assertAlmostEquals } from "https://deno.land/std@$STD_VERSION/assert/mod.ts";
 *
 * assertAlmostEquals(0.01, 0.02, 0.1); // Doesn't throw
 * assertAlmostEquals(0.01, 0.02); // Throws
 * assertAlmostEquals(0.1 + 0.2, 0.3, 1e-16); // Doesn't throw
 * assertAlmostEquals(0.1 + 0.2, 0.3, 1e-17); // Throws
 * ```
 */ export function assertAlmostEquals(actual, expected, tolerance = 1e-7, msg) {
  if (Object.is(actual, expected)) {
    return;
  }
  const delta = Math.abs(expected - actual);
  if (delta <= tolerance) {
    return;
  }
  const msgSuffix = msg ? `: ${msg}` : ".";
  const f = (n)=>Number.isInteger(n) ? n : n.toExponential();
  throw new AssertionError(`Expected actual: "${f(actual)}" to be close to "${f(expected)}": \
delta "${f(delta)}" is greater than "${f(tolerance)}"${msgSuffix}`);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfYWxtb3N0X2VxdWFscy50cyJdLCJzb3VyY2VzQ29udGVudCI6WyIvLyBDb3B5cmlnaHQgMjAxOC0yMDI0IHRoZSBEZW5vIGF1dGhvcnMuIEFsbCByaWdodHMgcmVzZXJ2ZWQuIE1JVCBsaWNlbnNlLlxuaW1wb3J0IHsgQXNzZXJ0aW9uRXJyb3IgfSBmcm9tIFwiLi9hc3NlcnRpb25fZXJyb3IudHNcIjtcblxuLyoqXG4gKiBNYWtlIGFuIGFzc2VydGlvbiB0aGF0IGBhY3R1YWxgIGFuZCBgZXhwZWN0ZWRgIGFyZSBhbG1vc3QgZXF1YWwgbnVtYmVyc1xuICogdGhyb3VnaCBhIGdpdmVuIHRvbGVyYW5jZS4gSXQgY2FuIGJlIHVzZWQgdG8gdGFrZSBpbnRvIGFjY291bnQgSUVFRS03NTRcbiAqIGRvdWJsZS1wcmVjaXNpb24gZmxvYXRpbmctcG9pbnQgcmVwcmVzZW50YXRpb24gbGltaXRhdGlvbnMuIElmIHRoZSB2YWx1ZXNcbiAqIGFyZSBub3QgYWxtb3N0IGVxdWFsIHRoZW4gdGhyb3cuXG4gKlxuICogQGV4YW1wbGVcbiAqIGBgYHRzXG4gKiBpbXBvcnQgeyBhc3NlcnRBbG1vc3RFcXVhbHMgfSBmcm9tIFwiaHR0cHM6Ly9kZW5vLmxhbmQvc3RkQCRTVERfVkVSU0lPTi9hc3NlcnQvbW9kLnRzXCI7XG4gKlxuICogYXNzZXJ0QWxtb3N0RXF1YWxzKDAuMDEsIDAuMDIsIDAuMSk7IC8vIERvZXNuJ3QgdGhyb3dcbiAqIGFzc2VydEFsbW9zdEVxdWFscygwLjAxLCAwLjAyKTsgLy8gVGhyb3dzXG4gKiBhc3NlcnRBbG1vc3RFcXVhbHMoMC4xICsgMC4yLCAwLjMsIDFlLTE2KTsgLy8gRG9lc24ndCB0aHJvd1xuICogYXNzZXJ0QWxtb3N0RXF1YWxzKDAuMSArIDAuMiwgMC4zLCAxZS0xNyk7IC8vIFRocm93c1xuICogYGBgXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBhc3NlcnRBbG1vc3RFcXVhbHMoXG4gIGFjdHVhbDogbnVtYmVyLFxuICBleHBlY3RlZDogbnVtYmVyLFxuICB0b2xlcmFuY2UgPSAxZS03LFxuICBtc2c/OiBzdHJpbmcsXG4pOiB2b2lkIHtcbiAgaWYgKE9iamVjdC5pcyhhY3R1YWwsIGV4cGVjdGVkKSkge1xuICAgIHJldHVybjtcbiAgfVxuICBjb25zdCBkZWx0YSA9IE1hdGguYWJzKGV4cGVjdGVkIC0gYWN0dWFsKTtcbiAgaWYgKGRlbHRhIDw9IHRvbGVyYW5jZSkge1xuICAgIHJldHVybjtcbiAgfVxuXG4gIGNvbnN0IG1zZ1N1ZmZpeCA9IG1zZyA/IGA6ICR7bXNnfWAgOiBcIi5cIjtcbiAgY29uc3QgZiA9IChuOiBudW1iZXIpID0+IE51bWJlci5pc0ludGVnZXIobikgPyBuIDogbi50b0V4cG9uZW50aWFsKCk7XG4gIHRocm93IG5ldyBBc3NlcnRpb25FcnJvcihcbiAgICBgRXhwZWN0ZWQgYWN0dWFsOiBcIiR7ZihhY3R1YWwpfVwiIHRvIGJlIGNsb3NlIHRvIFwiJHtmKGV4cGVjdGVkKX1cIjogXFxcbmRlbHRhIFwiJHtmKGRlbHRhKX1cIiBpcyBncmVhdGVyIHRoYW4gXCIke2YodG9sZXJhbmNlKX1cIiR7bXNnU3VmZml4fWAsXG4gICk7XG59XG4iXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsMEVBQTBFO0FBQzFFLFNBQVMsY0FBYyxRQUFRLHVCQUF1QjtBQUV0RDs7Ozs7Ozs7Ozs7Ozs7O0NBZUMsR0FDRCxPQUFPLFNBQVMsbUJBQ2QsTUFBYyxFQUNkLFFBQWdCLEVBQ2hCLFlBQVksSUFBSSxFQUNoQixHQUFZO0VBRVosSUFBSSxPQUFPLEVBQUUsQ0FBQyxRQUFRLFdBQVc7SUFDL0I7RUFDRjtFQUNBLE1BQU0sUUFBUSxLQUFLLEdBQUcsQ0FBQyxXQUFXO0VBQ2xDLElBQUksU0FBUyxXQUFXO0lBQ3RCO0VBQ0Y7RUFFQSxNQUFNLFlBQVksTUFBTSxDQUFDLEVBQUUsRUFBRSxJQUFJLENBQUMsR0FBRztFQUNyQyxNQUFNLElBQUksQ0FBQyxJQUFjLE9BQU8sU0FBUyxDQUFDLEtBQUssSUFBSSxFQUFFLGFBQWE7RUFDbEUsTUFBTSxJQUFJLGVBQ1IsQ0FBQyxrQkFBa0IsRUFBRSxFQUFFLFFBQVEsa0JBQWtCLEVBQUUsRUFBRSxVQUFVO09BQzVELEVBQUUsRUFBRSxPQUFPLG1CQUFtQixFQUFFLEVBQUUsV0FBVyxDQUFDLEVBQUUsVUFBVSxDQUFDO0FBRWxFIn0=