// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { equal } from "./equal.ts";
import { format } from "./_format.ts";
import { AssertionError } from "./assertion_error.ts";
import { red } from "../fmt/colors.ts";
import { buildMessage, diff, diffstr } from "./_diff.ts";
import { CAN_NOT_DISPLAY } from "./_constants.ts";
/**
 * Make an assertion that `actual` and `expected` are equal, deeply. If not
 * deeply equal, then throw.
 *
 * Type parameter can be specified to ensure values under comparison have the
 * same type.
 *
 * @example
 * ```ts
 * import { assertEquals } from "https://deno.land/std@$STD_VERSION/assert/assert_equals.ts";
 *
 * assertEquals("world", "world"); // Doesn't throw
 * assertEquals("hello", "world"); // Throws
 * ```
 *
 * Note: formatter option is experimental and may be removed in the future.
 */ export function assertEquals(actual, expected, msg, options = {}) {
  if (equal(actual, expected)) {
    return;
  }
  const { formatter = format } = options;
  const msgSuffix = msg ? `: ${msg}` : ".";
  let message = `Values are not equal${msgSuffix}`;
  const actualString = formatter(actual);
  const expectedString = formatter(expected);
  try {
    const stringDiff = typeof actual === "string" && typeof expected === "string";
    const diffResult = stringDiff ? diffstr(actual, expected) : diff(actualString.split("\n"), expectedString.split("\n"));
    const diffMsg = buildMessage(diffResult, {
      stringDiff
    }).join("\n");
    message = `${message}\n${diffMsg}`;
  } catch  {
    message = `${message}\n${red(CAN_NOT_DISPLAY)} + \n\n`;
  }
  throw new AssertionError(message);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfZXF1YWxzLnRzIl0sInNvdXJjZXNDb250ZW50IjpbIi8vIENvcHlyaWdodCAyMDE4LTIwMjQgdGhlIERlbm8gYXV0aG9ycy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4gTUlUIGxpY2Vuc2UuXG5pbXBvcnQgeyBlcXVhbCB9IGZyb20gXCIuL2VxdWFsLnRzXCI7XG5pbXBvcnQgeyBmb3JtYXQgfSBmcm9tIFwiLi9fZm9ybWF0LnRzXCI7XG5pbXBvcnQgeyBBc3NlcnRpb25FcnJvciB9IGZyb20gXCIuL2Fzc2VydGlvbl9lcnJvci50c1wiO1xuaW1wb3J0IHsgcmVkIH0gZnJvbSBcIi4uL2ZtdC9jb2xvcnMudHNcIjtcbmltcG9ydCB7IGJ1aWxkTWVzc2FnZSwgZGlmZiwgZGlmZnN0ciB9IGZyb20gXCIuL19kaWZmLnRzXCI7XG5pbXBvcnQgeyBDQU5fTk9UX0RJU1BMQVkgfSBmcm9tIFwiLi9fY29uc3RhbnRzLnRzXCI7XG5cbi8qKlxuICogTWFrZSBhbiBhc3NlcnRpb24gdGhhdCBgYWN0dWFsYCBhbmQgYGV4cGVjdGVkYCBhcmUgZXF1YWwsIGRlZXBseS4gSWYgbm90XG4gKiBkZWVwbHkgZXF1YWwsIHRoZW4gdGhyb3cuXG4gKlxuICogVHlwZSBwYXJhbWV0ZXIgY2FuIGJlIHNwZWNpZmllZCB0byBlbnN1cmUgdmFsdWVzIHVuZGVyIGNvbXBhcmlzb24gaGF2ZSB0aGVcbiAqIHNhbWUgdHlwZS5cbiAqXG4gKiBAZXhhbXBsZVxuICogYGBgdHNcbiAqIGltcG9ydCB7IGFzc2VydEVxdWFscyB9IGZyb20gXCJodHRwczovL2Rlbm8ubGFuZC9zdGRAJFNURF9WRVJTSU9OL2Fzc2VydC9hc3NlcnRfZXF1YWxzLnRzXCI7XG4gKlxuICogYXNzZXJ0RXF1YWxzKFwid29ybGRcIiwgXCJ3b3JsZFwiKTsgLy8gRG9lc24ndCB0aHJvd1xuICogYXNzZXJ0RXF1YWxzKFwiaGVsbG9cIiwgXCJ3b3JsZFwiKTsgLy8gVGhyb3dzXG4gKiBgYGBcbiAqXG4gKiBOb3RlOiBmb3JtYXR0ZXIgb3B0aW9uIGlzIGV4cGVyaW1lbnRhbCBhbmQgbWF5IGJlIHJlbW92ZWQgaW4gdGhlIGZ1dHVyZS5cbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGFzc2VydEVxdWFsczxUPihcbiAgYWN0dWFsOiBULFxuICBleHBlY3RlZDogVCxcbiAgbXNnPzogc3RyaW5nLFxuICBvcHRpb25zOiB7IGZvcm1hdHRlcj86ICh2YWx1ZTogdW5rbm93bikgPT4gc3RyaW5nIH0gPSB7fSxcbik6IHZvaWQge1xuICBpZiAoZXF1YWwoYWN0dWFsLCBleHBlY3RlZCkpIHtcbiAgICByZXR1cm47XG4gIH1cbiAgY29uc3QgeyBmb3JtYXR0ZXIgPSBmb3JtYXQgfSA9IG9wdGlvbnM7XG4gIGNvbnN0IG1zZ1N1ZmZpeCA9IG1zZyA/IGA6ICR7bXNnfWAgOiBcIi5cIjtcbiAgbGV0IG1lc3NhZ2UgPSBgVmFsdWVzIGFyZSBub3QgZXF1YWwke21zZ1N1ZmZpeH1gO1xuXG4gIGNvbnN0IGFjdHVhbFN0cmluZyA9IGZvcm1hdHRlcihhY3R1YWwpO1xuICBjb25zdCBleHBlY3RlZFN0cmluZyA9IGZvcm1hdHRlcihleHBlY3RlZCk7XG4gIHRyeSB7XG4gICAgY29uc3Qgc3RyaW5nRGlmZiA9ICh0eXBlb2YgYWN0dWFsID09PSBcInN0cmluZ1wiKSAmJlxuICAgICAgKHR5cGVvZiBleHBlY3RlZCA9PT0gXCJzdHJpbmdcIik7XG4gICAgY29uc3QgZGlmZlJlc3VsdCA9IHN0cmluZ0RpZmZcbiAgICAgID8gZGlmZnN0cihhY3R1YWwgYXMgc3RyaW5nLCBleHBlY3RlZCBhcyBzdHJpbmcpXG4gICAgICA6IGRpZmYoYWN0dWFsU3RyaW5nLnNwbGl0KFwiXFxuXCIpLCBleHBlY3RlZFN0cmluZy5zcGxpdChcIlxcblwiKSk7XG4gICAgY29uc3QgZGlmZk1zZyA9IGJ1aWxkTWVzc2FnZShkaWZmUmVzdWx0LCB7IHN0cmluZ0RpZmYgfSkuam9pbihcIlxcblwiKTtcbiAgICBtZXNzYWdlID0gYCR7bWVzc2FnZX1cXG4ke2RpZmZNc2d9YDtcbiAgfSBjYXRjaCB7XG4gICAgbWVzc2FnZSA9IGAke21lc3NhZ2V9XFxuJHtyZWQoQ0FOX05PVF9ESVNQTEFZKX0gKyBcXG5cXG5gO1xuICB9XG4gIHRocm93IG5ldyBBc3NlcnRpb25FcnJvcihtZXNzYWdlKTtcbn1cbiJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSwwRUFBMEU7QUFDMUUsU0FBUyxLQUFLLFFBQVEsYUFBYTtBQUNuQyxTQUFTLE1BQU0sUUFBUSxlQUFlO0FBQ3RDLFNBQVMsY0FBYyxRQUFRLHVCQUF1QjtBQUN0RCxTQUFTLEdBQUcsUUFBUSxtQkFBbUI7QUFDdkMsU0FBUyxZQUFZLEVBQUUsSUFBSSxFQUFFLE9BQU8sUUFBUSxhQUFhO0FBQ3pELFNBQVMsZUFBZSxRQUFRLGtCQUFrQjtBQUVsRDs7Ozs7Ozs7Ozs7Ozs7OztDQWdCQyxHQUNELE9BQU8sU0FBUyxhQUNkLE1BQVMsRUFDVCxRQUFXLEVBQ1gsR0FBWSxFQUNaLFVBQXNELENBQUMsQ0FBQztFQUV4RCxJQUFJLE1BQU0sUUFBUSxXQUFXO0lBQzNCO0VBQ0Y7RUFDQSxNQUFNLEVBQUUsWUFBWSxNQUFNLEVBQUUsR0FBRztFQUMvQixNQUFNLFlBQVksTUFBTSxDQUFDLEVBQUUsRUFBRSxJQUFJLENBQUMsR0FBRztFQUNyQyxJQUFJLFVBQVUsQ0FBQyxvQkFBb0IsRUFBRSxVQUFVLENBQUM7RUFFaEQsTUFBTSxlQUFlLFVBQVU7RUFDL0IsTUFBTSxpQkFBaUIsVUFBVTtFQUNqQyxJQUFJO0lBQ0YsTUFBTSxhQUFhLEFBQUMsT0FBTyxXQUFXLFlBQ25DLE9BQU8sYUFBYTtJQUN2QixNQUFNLGFBQWEsYUFDZixRQUFRLFFBQWtCLFlBQzFCLEtBQUssYUFBYSxLQUFLLENBQUMsT0FBTyxlQUFlLEtBQUssQ0FBQztJQUN4RCxNQUFNLFVBQVUsYUFBYSxZQUFZO01BQUU7SUFBVyxHQUFHLElBQUksQ0FBQztJQUM5RCxVQUFVLENBQUMsRUFBRSxRQUFRLEVBQUUsRUFBRSxRQUFRLENBQUM7RUFDcEMsRUFBRSxPQUFNO0lBQ04sVUFBVSxDQUFDLEVBQUUsUUFBUSxFQUFFLEVBQUUsSUFBSSxpQkFBaUIsT0FBTyxDQUFDO0VBQ3hEO0VBQ0EsTUFBTSxJQUFJLGVBQWU7QUFDM0IifQ==