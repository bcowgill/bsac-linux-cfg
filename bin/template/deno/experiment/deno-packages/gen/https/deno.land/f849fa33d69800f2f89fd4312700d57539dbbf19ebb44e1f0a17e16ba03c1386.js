// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { assert } from "./assert.ts";
/**
 * Forcefully throws a failed assertion.
 *
 * @example
 * ```ts
 * import { fail } from "https://deno.land/std@$STD_VERSION/assert/fail.ts";
 *
 * fail("Deliberately failed!"); // Throws
 * ```
 */ export function fail(msg) {
  const msgSuffix = msg ? `: ${msg}` : ".";
  assert(false, `Failed assertion${msgSuffix}`);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9mYWlsLnRzIl0sInNvdXJjZXNDb250ZW50IjpbIi8vIENvcHlyaWdodCAyMDE4LTIwMjQgdGhlIERlbm8gYXV0aG9ycy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4gTUlUIGxpY2Vuc2UuXG5pbXBvcnQgeyBhc3NlcnQgfSBmcm9tIFwiLi9hc3NlcnQudHNcIjtcblxuLyoqXG4gKiBGb3JjZWZ1bGx5IHRocm93cyBhIGZhaWxlZCBhc3NlcnRpb24uXG4gKlxuICogQGV4YW1wbGVcbiAqIGBgYHRzXG4gKiBpbXBvcnQgeyBmYWlsIH0gZnJvbSBcImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAkU1REX1ZFUlNJT04vYXNzZXJ0L2ZhaWwudHNcIjtcbiAqXG4gKiBmYWlsKFwiRGVsaWJlcmF0ZWx5IGZhaWxlZCFcIik7IC8vIFRocm93c1xuICogYGBgXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBmYWlsKG1zZz86IHN0cmluZyk6IG5ldmVyIHtcbiAgY29uc3QgbXNnU3VmZml4ID0gbXNnID8gYDogJHttc2d9YCA6IFwiLlwiO1xuICBhc3NlcnQoZmFsc2UsIGBGYWlsZWQgYXNzZXJ0aW9uJHttc2dTdWZmaXh9YCk7XG59XG4iXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsMEVBQTBFO0FBQzFFLFNBQVMsTUFBTSxRQUFRLGNBQWM7QUFFckM7Ozs7Ozs7OztDQVNDLEdBQ0QsT0FBTyxTQUFTLEtBQUssR0FBWTtFQUMvQixNQUFNLFlBQVksTUFBTSxDQUFDLEVBQUUsRUFBRSxJQUFJLENBQUMsR0FBRztFQUNyQyxPQUFPLE9BQU8sQ0FBQyxnQkFBZ0IsRUFBRSxVQUFVLENBQUM7QUFDOUMifQ==