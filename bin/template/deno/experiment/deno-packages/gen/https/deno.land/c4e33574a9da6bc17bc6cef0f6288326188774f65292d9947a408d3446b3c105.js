// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { format } from "./_format.ts";
import { AssertionError } from "./assertion_error.ts";
/**
 * Make an assertion that `actual` is greater than `expected`.
 * If not then throw.
 *
 * @example
 * ```ts
 * import { assertGreater } from "https://deno.land/std@$STD_VERSION/assert/assert_greater.ts";
 *
 * assertGreater(2, 1); // Doesn't throw
 * assertGreater(1, 1); // Throws
 * assertGreater(0, 1); // Throws
 * ```
 */ export function assertGreater(actual, expected, msg) {
  if (actual > expected) return;
  const actualString = format(actual);
  const expectedString = format(expected);
  throw new AssertionError(msg ?? `Expect ${actualString} > ${expectedString}`);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfZ3JlYXRlci50cyJdLCJzb3VyY2VzQ29udGVudCI6WyIvLyBDb3B5cmlnaHQgMjAxOC0yMDI0IHRoZSBEZW5vIGF1dGhvcnMuIEFsbCByaWdodHMgcmVzZXJ2ZWQuIE1JVCBsaWNlbnNlLlxuaW1wb3J0IHsgZm9ybWF0IH0gZnJvbSBcIi4vX2Zvcm1hdC50c1wiO1xuaW1wb3J0IHsgQXNzZXJ0aW9uRXJyb3IgfSBmcm9tIFwiLi9hc3NlcnRpb25fZXJyb3IudHNcIjtcblxuLyoqXG4gKiBNYWtlIGFuIGFzc2VydGlvbiB0aGF0IGBhY3R1YWxgIGlzIGdyZWF0ZXIgdGhhbiBgZXhwZWN0ZWRgLlxuICogSWYgbm90IHRoZW4gdGhyb3cuXG4gKlxuICogQGV4YW1wbGVcbiAqIGBgYHRzXG4gKiBpbXBvcnQgeyBhc3NlcnRHcmVhdGVyIH0gZnJvbSBcImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAkU1REX1ZFUlNJT04vYXNzZXJ0L2Fzc2VydF9ncmVhdGVyLnRzXCI7XG4gKlxuICogYXNzZXJ0R3JlYXRlcigyLCAxKTsgLy8gRG9lc24ndCB0aHJvd1xuICogYXNzZXJ0R3JlYXRlcigxLCAxKTsgLy8gVGhyb3dzXG4gKiBhc3NlcnRHcmVhdGVyKDAsIDEpOyAvLyBUaHJvd3NcbiAqIGBgYFxuICovXG5leHBvcnQgZnVuY3Rpb24gYXNzZXJ0R3JlYXRlcjxUPihhY3R1YWw6IFQsIGV4cGVjdGVkOiBULCBtc2c/OiBzdHJpbmcpOiB2b2lkIHtcbiAgaWYgKGFjdHVhbCA+IGV4cGVjdGVkKSByZXR1cm47XG5cbiAgY29uc3QgYWN0dWFsU3RyaW5nID0gZm9ybWF0KGFjdHVhbCk7XG4gIGNvbnN0IGV4cGVjdGVkU3RyaW5nID0gZm9ybWF0KGV4cGVjdGVkKTtcbiAgdGhyb3cgbmV3IEFzc2VydGlvbkVycm9yKG1zZyA/PyBgRXhwZWN0ICR7YWN0dWFsU3RyaW5nfSA+ICR7ZXhwZWN0ZWRTdHJpbmd9YCk7XG59XG4iXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsMEVBQTBFO0FBQzFFLFNBQVMsTUFBTSxRQUFRLGVBQWU7QUFDdEMsU0FBUyxjQUFjLFFBQVEsdUJBQXVCO0FBRXREOzs7Ozs7Ozs7Ozs7Q0FZQyxHQUNELE9BQU8sU0FBUyxjQUFpQixNQUFTLEVBQUUsUUFBVyxFQUFFLEdBQVk7RUFDbkUsSUFBSSxTQUFTLFVBQVU7RUFFdkIsTUFBTSxlQUFlLE9BQU87RUFDNUIsTUFBTSxpQkFBaUIsT0FBTztFQUM5QixNQUFNLElBQUksZUFBZSxPQUFPLENBQUMsT0FBTyxFQUFFLGFBQWEsR0FBRyxFQUFFLGVBQWUsQ0FBQztBQUM5RSJ9