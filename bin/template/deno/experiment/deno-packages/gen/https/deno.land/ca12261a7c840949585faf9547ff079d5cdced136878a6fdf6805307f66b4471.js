// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { AssertionError } from "./assertion_error.ts";
/**
 * Make an assertion that actual includes expected. If not
 * then throw.
 *
 * @example
 * ```ts
 * import { assertStringIncludes } from "https://deno.land/std@$STD_VERSION/assert/assert_string_includes.ts";
 *
 * assertStringIncludes("Hello", "ello"); // Doesn't throw
 * assertStringIncludes("Hello", "world"); // Throws
 * ```
 */ export function assertStringIncludes(actual, expected, msg) {
  if (!actual.includes(expected)) {
    const msgSuffix = msg ? `: ${msg}` : ".";
    msg = `Expected actual: "${actual}" to contain: "${expected}"${msgSuffix}`;
    throw new AssertionError(msg);
  }
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfc3RyaW5nX2luY2x1ZGVzLnRzIl0sInNvdXJjZXNDb250ZW50IjpbIi8vIENvcHlyaWdodCAyMDE4LTIwMjQgdGhlIERlbm8gYXV0aG9ycy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4gTUlUIGxpY2Vuc2UuXG5pbXBvcnQgeyBBc3NlcnRpb25FcnJvciB9IGZyb20gXCIuL2Fzc2VydGlvbl9lcnJvci50c1wiO1xuXG4vKipcbiAqIE1ha2UgYW4gYXNzZXJ0aW9uIHRoYXQgYWN0dWFsIGluY2x1ZGVzIGV4cGVjdGVkLiBJZiBub3RcbiAqIHRoZW4gdGhyb3cuXG4gKlxuICogQGV4YW1wbGVcbiAqIGBgYHRzXG4gKiBpbXBvcnQgeyBhc3NlcnRTdHJpbmdJbmNsdWRlcyB9IGZyb20gXCJodHRwczovL2Rlbm8ubGFuZC9zdGRAJFNURF9WRVJTSU9OL2Fzc2VydC9hc3NlcnRfc3RyaW5nX2luY2x1ZGVzLnRzXCI7XG4gKlxuICogYXNzZXJ0U3RyaW5nSW5jbHVkZXMoXCJIZWxsb1wiLCBcImVsbG9cIik7IC8vIERvZXNuJ3QgdGhyb3dcbiAqIGFzc2VydFN0cmluZ0luY2x1ZGVzKFwiSGVsbG9cIiwgXCJ3b3JsZFwiKTsgLy8gVGhyb3dzXG4gKiBgYGBcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGFzc2VydFN0cmluZ0luY2x1ZGVzKFxuICBhY3R1YWw6IHN0cmluZyxcbiAgZXhwZWN0ZWQ6IHN0cmluZyxcbiAgbXNnPzogc3RyaW5nLFxuKSB7XG4gIGlmICghYWN0dWFsLmluY2x1ZGVzKGV4cGVjdGVkKSkge1xuICAgIGNvbnN0IG1zZ1N1ZmZpeCA9IG1zZyA/IGA6ICR7bXNnfWAgOiBcIi5cIjtcbiAgICBtc2cgPSBgRXhwZWN0ZWQgYWN0dWFsOiBcIiR7YWN0dWFsfVwiIHRvIGNvbnRhaW46IFwiJHtleHBlY3RlZH1cIiR7bXNnU3VmZml4fWA7XG4gICAgdGhyb3cgbmV3IEFzc2VydGlvbkVycm9yKG1zZyk7XG4gIH1cbn1cbiJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSwwRUFBMEU7QUFDMUUsU0FBUyxjQUFjLFFBQVEsdUJBQXVCO0FBRXREOzs7Ozs7Ozs7OztDQVdDLEdBQ0QsT0FBTyxTQUFTLHFCQUNkLE1BQWMsRUFDZCxRQUFnQixFQUNoQixHQUFZO0VBRVosSUFBSSxDQUFDLE9BQU8sUUFBUSxDQUFDLFdBQVc7SUFDOUIsTUFBTSxZQUFZLE1BQU0sQ0FBQyxFQUFFLEVBQUUsSUFBSSxDQUFDLEdBQUc7SUFDckMsTUFBTSxDQUFDLGtCQUFrQixFQUFFLE9BQU8sZUFBZSxFQUFFLFNBQVMsQ0FBQyxFQUFFLFVBQVUsQ0FBQztJQUMxRSxNQUFNLElBQUksZUFBZTtFQUMzQjtBQUNGIn0=