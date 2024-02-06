// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { AssertionError } from "./assertion_error.ts";
/**
 * Make an assertion that `actual` match RegExp `expected`. If not
 * then throw.
 *
 * @example
 * ```ts
 * import { assertMatch } from "https://deno.land/std@$STD_VERSION/assert/assert_match.ts";
 *
 * assertMatch("Raptor", RegExp(/Raptor/)); // Doesn't throw
 * assertMatch("Denosaurus", RegExp(/Raptor/)); // Throws
 * ```
 */ export function assertMatch(actual, expected, msg) {
  if (!expected.test(actual)) {
    const msgSuffix = msg ? `: ${msg}` : ".";
    msg = `Expected actual: "${actual}" to match: "${expected}"${msgSuffix}`;
    throw new AssertionError(msg);
  }
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfbWF0Y2gudHMiXSwic291cmNlc0NvbnRlbnQiOlsiLy8gQ29weXJpZ2h0IDIwMTgtMjAyNCB0aGUgRGVubyBhdXRob3JzLiBBbGwgcmlnaHRzIHJlc2VydmVkLiBNSVQgbGljZW5zZS5cbmltcG9ydCB7IEFzc2VydGlvbkVycm9yIH0gZnJvbSBcIi4vYXNzZXJ0aW9uX2Vycm9yLnRzXCI7XG5cbi8qKlxuICogTWFrZSBhbiBhc3NlcnRpb24gdGhhdCBgYWN0dWFsYCBtYXRjaCBSZWdFeHAgYGV4cGVjdGVkYC4gSWYgbm90XG4gKiB0aGVuIHRocm93LlxuICpcbiAqIEBleGFtcGxlXG4gKiBgYGB0c1xuICogaW1wb3J0IHsgYXNzZXJ0TWF0Y2ggfSBmcm9tIFwiaHR0cHM6Ly9kZW5vLmxhbmQvc3RkQCRTVERfVkVSU0lPTi9hc3NlcnQvYXNzZXJ0X21hdGNoLnRzXCI7XG4gKlxuICogYXNzZXJ0TWF0Y2goXCJSYXB0b3JcIiwgUmVnRXhwKC9SYXB0b3IvKSk7IC8vIERvZXNuJ3QgdGhyb3dcbiAqIGFzc2VydE1hdGNoKFwiRGVub3NhdXJ1c1wiLCBSZWdFeHAoL1JhcHRvci8pKTsgLy8gVGhyb3dzXG4gKiBgYGBcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGFzc2VydE1hdGNoKFxuICBhY3R1YWw6IHN0cmluZyxcbiAgZXhwZWN0ZWQ6IFJlZ0V4cCxcbiAgbXNnPzogc3RyaW5nLFxuKSB7XG4gIGlmICghZXhwZWN0ZWQudGVzdChhY3R1YWwpKSB7XG4gICAgY29uc3QgbXNnU3VmZml4ID0gbXNnID8gYDogJHttc2d9YCA6IFwiLlwiO1xuICAgIG1zZyA9IGBFeHBlY3RlZCBhY3R1YWw6IFwiJHthY3R1YWx9XCIgdG8gbWF0Y2g6IFwiJHtleHBlY3RlZH1cIiR7bXNnU3VmZml4fWA7XG4gICAgdGhyb3cgbmV3IEFzc2VydGlvbkVycm9yKG1zZyk7XG4gIH1cbn1cbiJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSwwRUFBMEU7QUFDMUUsU0FBUyxjQUFjLFFBQVEsdUJBQXVCO0FBRXREOzs7Ozs7Ozs7OztDQVdDLEdBQ0QsT0FBTyxTQUFTLFlBQ2QsTUFBYyxFQUNkLFFBQWdCLEVBQ2hCLEdBQVk7RUFFWixJQUFJLENBQUMsU0FBUyxJQUFJLENBQUMsU0FBUztJQUMxQixNQUFNLFlBQVksTUFBTSxDQUFDLEVBQUUsRUFBRSxJQUFJLENBQUMsR0FBRztJQUNyQyxNQUFNLENBQUMsa0JBQWtCLEVBQUUsT0FBTyxhQUFhLEVBQUUsU0FBUyxDQUFDLEVBQUUsVUFBVSxDQUFDO0lBQ3hFLE1BQU0sSUFBSSxlQUFlO0VBQzNCO0FBQ0YifQ==