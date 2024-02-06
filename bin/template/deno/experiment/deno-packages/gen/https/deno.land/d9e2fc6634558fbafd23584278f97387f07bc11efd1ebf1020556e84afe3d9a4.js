// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { AssertionError } from "./assertion_error.ts";
/**
 * Make an assertion that `actual` not match RegExp `expected`. If match
 * then throw.
 *
 * @example
 * ```ts
 * import { assertNotMatch } from "https://deno.land/std@$STD_VERSION/assert/assert_not_match.ts";
 *
 * assertNotMatch("Denosaurus", RegExp(/Raptor/)); // Doesn't throw
 * assertNotMatch("Raptor", RegExp(/Raptor/)); // Throws
 * ```
 */ export function assertNotMatch(actual, expected, msg) {
  if (expected.test(actual)) {
    const msgSuffix = msg ? `: ${msg}` : ".";
    msg = `Expected actual: "${actual}" to not match: "${expected}"${msgSuffix}`;
    throw new AssertionError(msg);
  }
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfbm90X21hdGNoLnRzIl0sInNvdXJjZXNDb250ZW50IjpbIi8vIENvcHlyaWdodCAyMDE4LTIwMjQgdGhlIERlbm8gYXV0aG9ycy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4gTUlUIGxpY2Vuc2UuXG5pbXBvcnQgeyBBc3NlcnRpb25FcnJvciB9IGZyb20gXCIuL2Fzc2VydGlvbl9lcnJvci50c1wiO1xuXG4vKipcbiAqIE1ha2UgYW4gYXNzZXJ0aW9uIHRoYXQgYGFjdHVhbGAgbm90IG1hdGNoIFJlZ0V4cCBgZXhwZWN0ZWRgLiBJZiBtYXRjaFxuICogdGhlbiB0aHJvdy5cbiAqXG4gKiBAZXhhbXBsZVxuICogYGBgdHNcbiAqIGltcG9ydCB7IGFzc2VydE5vdE1hdGNoIH0gZnJvbSBcImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAkU1REX1ZFUlNJT04vYXNzZXJ0L2Fzc2VydF9ub3RfbWF0Y2gudHNcIjtcbiAqXG4gKiBhc3NlcnROb3RNYXRjaChcIkRlbm9zYXVydXNcIiwgUmVnRXhwKC9SYXB0b3IvKSk7IC8vIERvZXNuJ3QgdGhyb3dcbiAqIGFzc2VydE5vdE1hdGNoKFwiUmFwdG9yXCIsIFJlZ0V4cCgvUmFwdG9yLykpOyAvLyBUaHJvd3NcbiAqIGBgYFxuICovXG5leHBvcnQgZnVuY3Rpb24gYXNzZXJ0Tm90TWF0Y2goXG4gIGFjdHVhbDogc3RyaW5nLFxuICBleHBlY3RlZDogUmVnRXhwLFxuICBtc2c/OiBzdHJpbmcsXG4pIHtcbiAgaWYgKGV4cGVjdGVkLnRlc3QoYWN0dWFsKSkge1xuICAgIGNvbnN0IG1zZ1N1ZmZpeCA9IG1zZyA/IGA6ICR7bXNnfWAgOiBcIi5cIjtcbiAgICBtc2cgPVxuICAgICAgYEV4cGVjdGVkIGFjdHVhbDogXCIke2FjdHVhbH1cIiB0byBub3QgbWF0Y2g6IFwiJHtleHBlY3RlZH1cIiR7bXNnU3VmZml4fWA7XG4gICAgdGhyb3cgbmV3IEFzc2VydGlvbkVycm9yKG1zZyk7XG4gIH1cbn1cbiJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSwwRUFBMEU7QUFDMUUsU0FBUyxjQUFjLFFBQVEsdUJBQXVCO0FBRXREOzs7Ozs7Ozs7OztDQVdDLEdBQ0QsT0FBTyxTQUFTLGVBQ2QsTUFBYyxFQUNkLFFBQWdCLEVBQ2hCLEdBQVk7RUFFWixJQUFJLFNBQVMsSUFBSSxDQUFDLFNBQVM7SUFDekIsTUFBTSxZQUFZLE1BQU0sQ0FBQyxFQUFFLEVBQUUsSUFBSSxDQUFDLEdBQUc7SUFDckMsTUFDRSxDQUFDLGtCQUFrQixFQUFFLE9BQU8saUJBQWlCLEVBQUUsU0FBUyxDQUFDLEVBQUUsVUFBVSxDQUFDO0lBQ3hFLE1BQU0sSUFBSSxlQUFlO0VBQzNCO0FBQ0YifQ==