// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { equal } from "./equal.ts";
import { format } from "./_format.ts";
import { AssertionError } from "./assertion_error.ts";
/**
 * Make an assertion that `actual` includes the `expected` values. If not then
 * an error will be thrown.
 *
 * Type parameter can be specified to ensure values under comparison have the
 * same type.
 *
 * @example
 * ```ts
 * import { assertArrayIncludes } from "https://deno.land/std@$STD_VERSION/assert/assert_array_includes.ts";
 *
 * assertArrayIncludes([1, 2], [2]); // Doesn't throw
 * assertArrayIncludes([1, 2], [3]); // Throws
 * ```
 */ export function assertArrayIncludes(actual, expected, msg) {
  const missing = [];
  for(let i = 0; i < expected.length; i++){
    let found = false;
    for(let j = 0; j < actual.length; j++){
      if (equal(expected[i], actual[j])) {
        found = true;
        break;
      }
    }
    if (!found) {
      missing.push(expected[i]);
    }
  }
  if (missing.length === 0) {
    return;
  }
  const msgSuffix = msg ? `: ${msg}` : ".";
  msg = `Expected actual: "${format(actual)}" to include: "${format(expected)}"${msgSuffix}\nmissing: ${format(missing)}`;
  throw new AssertionError(msg);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfYXJyYXlfaW5jbHVkZXMudHMiXSwic291cmNlc0NvbnRlbnQiOlsiLy8gQ29weXJpZ2h0IDIwMTgtMjAyNCB0aGUgRGVubyBhdXRob3JzLiBBbGwgcmlnaHRzIHJlc2VydmVkLiBNSVQgbGljZW5zZS5cbmltcG9ydCB7IGVxdWFsIH0gZnJvbSBcIi4vZXF1YWwudHNcIjtcbmltcG9ydCB7IGZvcm1hdCB9IGZyb20gXCIuL19mb3JtYXQudHNcIjtcbmltcG9ydCB7IEFzc2VydGlvbkVycm9yIH0gZnJvbSBcIi4vYXNzZXJ0aW9uX2Vycm9yLnRzXCI7XG5cbi8qKiBBbiBhcnJheS1saWtlIG9iamVjdCAoYEFycmF5YCwgYFVpbnQ4QXJyYXlgLCBgTm9kZUxpc3RgLCBldGMuKSB0aGF0IGlzIG5vdCBhIHN0cmluZyAqL1xuZXhwb3J0IHR5cGUgQXJyYXlMaWtlQXJnPFQ+ID0gQXJyYXlMaWtlPFQ+ICYgb2JqZWN0O1xuXG4vKipcbiAqIE1ha2UgYW4gYXNzZXJ0aW9uIHRoYXQgYGFjdHVhbGAgaW5jbHVkZXMgdGhlIGBleHBlY3RlZGAgdmFsdWVzLiBJZiBub3QgdGhlblxuICogYW4gZXJyb3Igd2lsbCBiZSB0aHJvd24uXG4gKlxuICogVHlwZSBwYXJhbWV0ZXIgY2FuIGJlIHNwZWNpZmllZCB0byBlbnN1cmUgdmFsdWVzIHVuZGVyIGNvbXBhcmlzb24gaGF2ZSB0aGVcbiAqIHNhbWUgdHlwZS5cbiAqXG4gKiBAZXhhbXBsZVxuICogYGBgdHNcbiAqIGltcG9ydCB7IGFzc2VydEFycmF5SW5jbHVkZXMgfSBmcm9tIFwiaHR0cHM6Ly9kZW5vLmxhbmQvc3RkQCRTVERfVkVSU0lPTi9hc3NlcnQvYXNzZXJ0X2FycmF5X2luY2x1ZGVzLnRzXCI7XG4gKlxuICogYXNzZXJ0QXJyYXlJbmNsdWRlcyhbMSwgMl0sIFsyXSk7IC8vIERvZXNuJ3QgdGhyb3dcbiAqIGFzc2VydEFycmF5SW5jbHVkZXMoWzEsIDJdLCBbM10pOyAvLyBUaHJvd3NcbiAqIGBgYFxuICovXG5leHBvcnQgZnVuY3Rpb24gYXNzZXJ0QXJyYXlJbmNsdWRlczxUPihcbiAgYWN0dWFsOiBBcnJheUxpa2VBcmc8VD4sXG4gIGV4cGVjdGVkOiBBcnJheUxpa2VBcmc8VD4sXG4gIG1zZz86IHN0cmluZyxcbik6IHZvaWQge1xuICBjb25zdCBtaXNzaW5nOiB1bmtub3duW10gPSBbXTtcbiAgZm9yIChsZXQgaSA9IDA7IGkgPCBleHBlY3RlZC5sZW5ndGg7IGkrKykge1xuICAgIGxldCBmb3VuZCA9IGZhbHNlO1xuICAgIGZvciAobGV0IGogPSAwOyBqIDwgYWN0dWFsLmxlbmd0aDsgaisrKSB7XG4gICAgICBpZiAoZXF1YWwoZXhwZWN0ZWRbaV0sIGFjdHVhbFtqXSkpIHtcbiAgICAgICAgZm91bmQgPSB0cnVlO1xuICAgICAgICBicmVhaztcbiAgICAgIH1cbiAgICB9XG4gICAgaWYgKCFmb3VuZCkge1xuICAgICAgbWlzc2luZy5wdXNoKGV4cGVjdGVkW2ldKTtcbiAgICB9XG4gIH1cbiAgaWYgKG1pc3NpbmcubGVuZ3RoID09PSAwKSB7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgY29uc3QgbXNnU3VmZml4ID0gbXNnID8gYDogJHttc2d9YCA6IFwiLlwiO1xuICBtc2cgPSBgRXhwZWN0ZWQgYWN0dWFsOiBcIiR7Zm9ybWF0KGFjdHVhbCl9XCIgdG8gaW5jbHVkZTogXCIke1xuICAgIGZvcm1hdChleHBlY3RlZClcbiAgfVwiJHttc2dTdWZmaXh9XFxubWlzc2luZzogJHtmb3JtYXQobWlzc2luZyl9YDtcbiAgdGhyb3cgbmV3IEFzc2VydGlvbkVycm9yKG1zZyk7XG59XG4iXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsMEVBQTBFO0FBQzFFLFNBQVMsS0FBSyxRQUFRLGFBQWE7QUFDbkMsU0FBUyxNQUFNLFFBQVEsZUFBZTtBQUN0QyxTQUFTLGNBQWMsUUFBUSx1QkFBdUI7QUFLdEQ7Ozs7Ozs7Ozs7Ozs7O0NBY0MsR0FDRCxPQUFPLFNBQVMsb0JBQ2QsTUFBdUIsRUFDdkIsUUFBeUIsRUFDekIsR0FBWTtFQUVaLE1BQU0sVUFBcUIsRUFBRTtFQUM3QixJQUFLLElBQUksSUFBSSxHQUFHLElBQUksU0FBUyxNQUFNLEVBQUUsSUFBSztJQUN4QyxJQUFJLFFBQVE7SUFDWixJQUFLLElBQUksSUFBSSxHQUFHLElBQUksT0FBTyxNQUFNLEVBQUUsSUFBSztNQUN0QyxJQUFJLE1BQU0sUUFBUSxDQUFDLEVBQUUsRUFBRSxNQUFNLENBQUMsRUFBRSxHQUFHO1FBQ2pDLFFBQVE7UUFDUjtNQUNGO0lBQ0Y7SUFDQSxJQUFJLENBQUMsT0FBTztNQUNWLFFBQVEsSUFBSSxDQUFDLFFBQVEsQ0FBQyxFQUFFO0lBQzFCO0VBQ0Y7RUFDQSxJQUFJLFFBQVEsTUFBTSxLQUFLLEdBQUc7SUFDeEI7RUFDRjtFQUVBLE1BQU0sWUFBWSxNQUFNLENBQUMsRUFBRSxFQUFFLElBQUksQ0FBQyxHQUFHO0VBQ3JDLE1BQU0sQ0FBQyxrQkFBa0IsRUFBRSxPQUFPLFFBQVEsZUFBZSxFQUN2RCxPQUFPLFVBQ1IsQ0FBQyxFQUFFLFVBQVUsV0FBVyxFQUFFLE9BQU8sU0FBUyxDQUFDO0VBQzVDLE1BQU0sSUFBSSxlQUFlO0FBQzNCIn0=