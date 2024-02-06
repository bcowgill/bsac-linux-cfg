// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { assertEquals } from "./assert_equals.ts";
/**
 * Make an assertion that `actual` object is a subset of `expected` object,
 * deeply. If not, then throw.
 *
 * @example
 * ```ts
 * import { assertObjectMatch } from "https://deno.land/std@$STD_VERSION/assert/assert_object_match.ts";
 *
 * assertObjectMatch({ foo: "bar" }, { foo: "bar" }); // Doesn't throw
 * assertObjectMatch({ foo: "bar" }, { foo: "baz" }); // Throws
 * ```
 */ export function assertObjectMatch(// deno-lint-ignore no-explicit-any
actual, expected, msg) {
  function filter(a, b) {
    const seen = new WeakMap();
    return fn(a, b);
    function fn(a, b) {
      // Prevent infinite loop with circular references with same filter
      if (seen.has(a) && seen.get(a) === b) {
        return a;
      }
      try {
        seen.set(a, b);
      } catch (err) {
        if (err instanceof TypeError) {
          throw new TypeError(`Cannot assertObjectMatch ${a === null ? null : `type ${typeof a}`}`);
        } else throw err;
      }
      // Filter keys and symbols which are present in both actual and expected
      const filtered = {};
      const entries = [
        ...Object.getOwnPropertyNames(a),
        ...Object.getOwnPropertySymbols(a)
      ].filter((key)=>key in b).map((key)=>[
          key,
          a[key]
        ]);
      for (const [key, value] of entries){
        // On array references, build a filtered array and filter nested objects inside
        if (Array.isArray(value)) {
          const subset = b[key];
          if (Array.isArray(subset)) {
            filtered[key] = fn({
              ...value
            }, {
              ...subset
            });
            continue;
          }
        } else if (value instanceof RegExp) {
          filtered[key] = value;
          continue;
        } else if (typeof value === "object" && value !== null) {
          const subset = b[key];
          if (typeof subset === "object" && subset) {
            // When both operands are maps, build a filtered map with common keys and filter nested objects inside
            if (value instanceof Map && subset instanceof Map) {
              filtered[key] = new Map([
                ...value
              ].filter(([k])=>subset.has(k)).map(([k, v])=>[
                  k,
                  typeof v === "object" ? fn(v, subset.get(k)) : v
                ]));
              continue;
            }
            // When both operands are set, build a filtered set with common values
            if (value instanceof Set && subset instanceof Set) {
              filtered[key] = new Set([
                ...value
              ].filter((v)=>subset.has(v)));
              continue;
            }
            filtered[key] = fn(value, subset);
            continue;
          }
        }
        filtered[key] = value;
      }
      return filtered;
    }
  }
  return assertEquals(// get the intersection of "actual" and "expected"
  // side effect: all the instances' constructor field is "Object" now.
  filter(actual, expected), // set (nested) instances' constructor field to be "Object" without changing expected value.
  // see https://github.com/denoland/deno_std/pull/1419
  filter(expected, expected), msg);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfb2JqZWN0X21hdGNoLnRzIl0sInNvdXJjZXNDb250ZW50IjpbIi8vIENvcHlyaWdodCAyMDE4LTIwMjQgdGhlIERlbm8gYXV0aG9ycy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4gTUlUIGxpY2Vuc2UuXG5pbXBvcnQgeyBhc3NlcnRFcXVhbHMgfSBmcm9tIFwiLi9hc3NlcnRfZXF1YWxzLnRzXCI7XG5cbi8qKlxuICogTWFrZSBhbiBhc3NlcnRpb24gdGhhdCBgYWN0dWFsYCBvYmplY3QgaXMgYSBzdWJzZXQgb2YgYGV4cGVjdGVkYCBvYmplY3QsXG4gKiBkZWVwbHkuIElmIG5vdCwgdGhlbiB0aHJvdy5cbiAqXG4gKiBAZXhhbXBsZVxuICogYGBgdHNcbiAqIGltcG9ydCB7IGFzc2VydE9iamVjdE1hdGNoIH0gZnJvbSBcImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAkU1REX1ZFUlNJT04vYXNzZXJ0L2Fzc2VydF9vYmplY3RfbWF0Y2gudHNcIjtcbiAqXG4gKiBhc3NlcnRPYmplY3RNYXRjaCh7IGZvbzogXCJiYXJcIiB9LCB7IGZvbzogXCJiYXJcIiB9KTsgLy8gRG9lc24ndCB0aHJvd1xuICogYXNzZXJ0T2JqZWN0TWF0Y2goeyBmb286IFwiYmFyXCIgfSwgeyBmb286IFwiYmF6XCIgfSk7IC8vIFRocm93c1xuICogYGBgXG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBhc3NlcnRPYmplY3RNYXRjaChcbiAgLy8gZGVuby1saW50LWlnbm9yZSBuby1leHBsaWNpdC1hbnlcbiAgYWN0dWFsOiBSZWNvcmQ8UHJvcGVydHlLZXksIGFueT4sXG4gIGV4cGVjdGVkOiBSZWNvcmQ8UHJvcGVydHlLZXksIHVua25vd24+LFxuICBtc2c/OiBzdHJpbmcsXG4pOiB2b2lkIHtcbiAgdHlwZSBsb29zZSA9IFJlY29yZDxQcm9wZXJ0eUtleSwgdW5rbm93bj47XG5cbiAgZnVuY3Rpb24gZmlsdGVyKGE6IGxvb3NlLCBiOiBsb29zZSkge1xuICAgIGNvbnN0IHNlZW4gPSBuZXcgV2Vha01hcCgpO1xuICAgIHJldHVybiBmbihhLCBiKTtcblxuICAgIGZ1bmN0aW9uIGZuKGE6IGxvb3NlLCBiOiBsb29zZSk6IGxvb3NlIHtcbiAgICAgIC8vIFByZXZlbnQgaW5maW5pdGUgbG9vcCB3aXRoIGNpcmN1bGFyIHJlZmVyZW5jZXMgd2l0aCBzYW1lIGZpbHRlclxuICAgICAgaWYgKChzZWVuLmhhcyhhKSkgJiYgKHNlZW4uZ2V0KGEpID09PSBiKSkge1xuICAgICAgICByZXR1cm4gYTtcbiAgICAgIH1cbiAgICAgIHRyeSB7XG4gICAgICAgIHNlZW4uc2V0KGEsIGIpO1xuICAgICAgfSBjYXRjaCAoZXJyKSB7XG4gICAgICAgIGlmIChlcnIgaW5zdGFuY2VvZiBUeXBlRXJyb3IpIHtcbiAgICAgICAgICB0aHJvdyBuZXcgVHlwZUVycm9yKFxuICAgICAgICAgICAgYENhbm5vdCBhc3NlcnRPYmplY3RNYXRjaCAke1xuICAgICAgICAgICAgICBhID09PSBudWxsID8gbnVsbCA6IGB0eXBlICR7dHlwZW9mIGF9YFxuICAgICAgICAgICAgfWAsXG4gICAgICAgICAgKTtcbiAgICAgICAgfSBlbHNlIHRocm93IGVycjtcbiAgICAgIH1cbiAgICAgIC8vIEZpbHRlciBrZXlzIGFuZCBzeW1ib2xzIHdoaWNoIGFyZSBwcmVzZW50IGluIGJvdGggYWN0dWFsIGFuZCBleHBlY3RlZFxuICAgICAgY29uc3QgZmlsdGVyZWQgPSB7fSBhcyBsb29zZTtcbiAgICAgIGNvbnN0IGVudHJpZXMgPSBbXG4gICAgICAgIC4uLk9iamVjdC5nZXRPd25Qcm9wZXJ0eU5hbWVzKGEpLFxuICAgICAgICAuLi5PYmplY3QuZ2V0T3duUHJvcGVydHlTeW1ib2xzKGEpLFxuICAgICAgXVxuICAgICAgICAuZmlsdGVyKChrZXkpID0+IGtleSBpbiBiKVxuICAgICAgICAubWFwKChrZXkpID0+IFtrZXksIGFba2V5IGFzIHN0cmluZ11dKSBhcyBBcnJheTxbc3RyaW5nLCB1bmtub3duXT47XG4gICAgICBmb3IgKGNvbnN0IFtrZXksIHZhbHVlXSBvZiBlbnRyaWVzKSB7XG4gICAgICAgIC8vIE9uIGFycmF5IHJlZmVyZW5jZXMsIGJ1aWxkIGEgZmlsdGVyZWQgYXJyYXkgYW5kIGZpbHRlciBuZXN0ZWQgb2JqZWN0cyBpbnNpZGVcbiAgICAgICAgaWYgKEFycmF5LmlzQXJyYXkodmFsdWUpKSB7XG4gICAgICAgICAgY29uc3Qgc3Vic2V0ID0gKGIgYXMgbG9vc2UpW2tleV07XG4gICAgICAgICAgaWYgKEFycmF5LmlzQXJyYXkoc3Vic2V0KSkge1xuICAgICAgICAgICAgZmlsdGVyZWRba2V5XSA9IGZuKHsgLi4udmFsdWUgfSwgeyAuLi5zdWJzZXQgfSk7XG4gICAgICAgICAgICBjb250aW51ZTtcbiAgICAgICAgICB9XG4gICAgICAgIH0gLy8gT24gcmVnZXhwIHJlZmVyZW5jZXMsIGtlZXAgdmFsdWUgYXMgaXQgdG8gYXZvaWQgbG9vc2luZyBwYXR0ZXJuIGFuZCBmbGFnc1xuICAgICAgICBlbHNlIGlmICh2YWx1ZSBpbnN0YW5jZW9mIFJlZ0V4cCkge1xuICAgICAgICAgIGZpbHRlcmVkW2tleV0gPSB2YWx1ZTtcbiAgICAgICAgICBjb250aW51ZTtcbiAgICAgICAgfSAvLyBPbiBuZXN0ZWQgb2JqZWN0cyByZWZlcmVuY2VzLCBidWlsZCBhIGZpbHRlcmVkIG9iamVjdCByZWN1cnNpdmVseVxuICAgICAgICBlbHNlIGlmICh0eXBlb2YgdmFsdWUgPT09IFwib2JqZWN0XCIgJiYgdmFsdWUgIT09IG51bGwpIHtcbiAgICAgICAgICBjb25zdCBzdWJzZXQgPSAoYiBhcyBsb29zZSlba2V5XTtcbiAgICAgICAgICBpZiAoKHR5cGVvZiBzdWJzZXQgPT09IFwib2JqZWN0XCIpICYmIHN1YnNldCkge1xuICAgICAgICAgICAgLy8gV2hlbiBib3RoIG9wZXJhbmRzIGFyZSBtYXBzLCBidWlsZCBhIGZpbHRlcmVkIG1hcCB3aXRoIGNvbW1vbiBrZXlzIGFuZCBmaWx0ZXIgbmVzdGVkIG9iamVjdHMgaW5zaWRlXG4gICAgICAgICAgICBpZiAoKHZhbHVlIGluc3RhbmNlb2YgTWFwKSAmJiAoc3Vic2V0IGluc3RhbmNlb2YgTWFwKSkge1xuICAgICAgICAgICAgICBmaWx0ZXJlZFtrZXldID0gbmV3IE1hcChcbiAgICAgICAgICAgICAgICBbLi4udmFsdWVdLmZpbHRlcigoW2tdKSA9PiBzdWJzZXQuaGFzKGspKS5tYXAoKFxuICAgICAgICAgICAgICAgICAgW2ssIHZdLFxuICAgICAgICAgICAgICAgICkgPT4gW2ssIHR5cGVvZiB2ID09PSBcIm9iamVjdFwiID8gZm4odiwgc3Vic2V0LmdldChrKSkgOiB2XSksXG4gICAgICAgICAgICAgICk7XG4gICAgICAgICAgICAgIGNvbnRpbnVlO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgLy8gV2hlbiBib3RoIG9wZXJhbmRzIGFyZSBzZXQsIGJ1aWxkIGEgZmlsdGVyZWQgc2V0IHdpdGggY29tbW9uIHZhbHVlc1xuICAgICAgICAgICAgaWYgKCh2YWx1ZSBpbnN0YW5jZW9mIFNldCkgJiYgKHN1YnNldCBpbnN0YW5jZW9mIFNldCkpIHtcbiAgICAgICAgICAgICAgZmlsdGVyZWRba2V5XSA9IG5ldyBTZXQoWy4uLnZhbHVlXS5maWx0ZXIoKHYpID0+IHN1YnNldC5oYXModikpKTtcbiAgICAgICAgICAgICAgY29udGludWU7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBmaWx0ZXJlZFtrZXldID0gZm4odmFsdWUgYXMgbG9vc2UsIHN1YnNldCBhcyBsb29zZSk7XG4gICAgICAgICAgICBjb250aW51ZTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgICAgZmlsdGVyZWRba2V5XSA9IHZhbHVlO1xuICAgICAgfVxuICAgICAgcmV0dXJuIGZpbHRlcmVkO1xuICAgIH1cbiAgfVxuICByZXR1cm4gYXNzZXJ0RXF1YWxzKFxuICAgIC8vIGdldCB0aGUgaW50ZXJzZWN0aW9uIG9mIFwiYWN0dWFsXCIgYW5kIFwiZXhwZWN0ZWRcIlxuICAgIC8vIHNpZGUgZWZmZWN0OiBhbGwgdGhlIGluc3RhbmNlcycgY29uc3RydWN0b3IgZmllbGQgaXMgXCJPYmplY3RcIiBub3cuXG4gICAgZmlsdGVyKGFjdHVhbCwgZXhwZWN0ZWQpLFxuICAgIC8vIHNldCAobmVzdGVkKSBpbnN0YW5jZXMnIGNvbnN0cnVjdG9yIGZpZWxkIHRvIGJlIFwiT2JqZWN0XCIgd2l0aG91dCBjaGFuZ2luZyBleHBlY3RlZCB2YWx1ZS5cbiAgICAvLyBzZWUgaHR0cHM6Ly9naXRodWIuY29tL2Rlbm9sYW5kL2Rlbm9fc3RkL3B1bGwvMTQxOVxuICAgIGZpbHRlcihleHBlY3RlZCwgZXhwZWN0ZWQpLFxuICAgIG1zZyxcbiAgKTtcbn1cbiJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSwwRUFBMEU7QUFDMUUsU0FBUyxZQUFZLFFBQVEscUJBQXFCO0FBRWxEOzs7Ozs7Ozs7OztDQVdDLEdBQ0QsT0FBTyxTQUFTLGtCQUNkLG1DQUFtQztBQUNuQyxNQUFnQyxFQUNoQyxRQUFzQyxFQUN0QyxHQUFZO0VBSVosU0FBUyxPQUFPLENBQVEsRUFBRSxDQUFRO0lBQ2hDLE1BQU0sT0FBTyxJQUFJO0lBQ2pCLE9BQU8sR0FBRyxHQUFHO0lBRWIsU0FBUyxHQUFHLENBQVEsRUFBRSxDQUFRO01BQzVCLGtFQUFrRTtNQUNsRSxJQUFJLEFBQUMsS0FBSyxHQUFHLENBQUMsTUFBUSxLQUFLLEdBQUcsQ0FBQyxPQUFPLEdBQUk7UUFDeEMsT0FBTztNQUNUO01BQ0EsSUFBSTtRQUNGLEtBQUssR0FBRyxDQUFDLEdBQUc7TUFDZCxFQUFFLE9BQU8sS0FBSztRQUNaLElBQUksZUFBZSxXQUFXO1VBQzVCLE1BQU0sSUFBSSxVQUNSLENBQUMseUJBQXlCLEVBQ3hCLE1BQU0sT0FBTyxPQUFPLENBQUMsS0FBSyxFQUFFLE9BQU8sRUFBRSxDQUFDLENBQ3ZDLENBQUM7UUFFTixPQUFPLE1BQU07TUFDZjtNQUNBLHdFQUF3RTtNQUN4RSxNQUFNLFdBQVcsQ0FBQztNQUNsQixNQUFNLFVBQVU7V0FDWCxPQUFPLG1CQUFtQixDQUFDO1dBQzNCLE9BQU8scUJBQXFCLENBQUM7T0FDakMsQ0FDRSxNQUFNLENBQUMsQ0FBQyxNQUFRLE9BQU8sR0FDdkIsR0FBRyxDQUFDLENBQUMsTUFBUTtVQUFDO1VBQUssQ0FBQyxDQUFDLElBQWM7U0FBQztNQUN2QyxLQUFLLE1BQU0sQ0FBQyxLQUFLLE1BQU0sSUFBSSxRQUFTO1FBQ2xDLCtFQUErRTtRQUMvRSxJQUFJLE1BQU0sT0FBTyxDQUFDLFFBQVE7VUFDeEIsTUFBTSxTQUFTLEFBQUMsQ0FBVyxDQUFDLElBQUk7VUFDaEMsSUFBSSxNQUFNLE9BQU8sQ0FBQyxTQUFTO1lBQ3pCLFFBQVEsQ0FBQyxJQUFJLEdBQUcsR0FBRztjQUFFLEdBQUcsS0FBSztZQUFDLEdBQUc7Y0FBRSxHQUFHLE1BQU07WUFBQztZQUM3QztVQUNGO1FBQ0YsT0FDSyxJQUFJLGlCQUFpQixRQUFRO1VBQ2hDLFFBQVEsQ0FBQyxJQUFJLEdBQUc7VUFDaEI7UUFDRixPQUNLLElBQUksT0FBTyxVQUFVLFlBQVksVUFBVSxNQUFNO1VBQ3BELE1BQU0sU0FBUyxBQUFDLENBQVcsQ0FBQyxJQUFJO1VBQ2hDLElBQUksQUFBQyxPQUFPLFdBQVcsWUFBYSxRQUFRO1lBQzFDLHNHQUFzRztZQUN0RyxJQUFJLEFBQUMsaUJBQWlCLE9BQVMsa0JBQWtCLEtBQU07Y0FDckQsUUFBUSxDQUFDLElBQUksR0FBRyxJQUFJLElBQ2xCO21CQUFJO2VBQU0sQ0FBQyxNQUFNLENBQUMsQ0FBQyxDQUFDLEVBQUUsR0FBSyxPQUFPLEdBQUcsQ0FBQyxJQUFJLEdBQUcsQ0FBQyxDQUM1QyxDQUFDLEdBQUcsRUFBRSxHQUNIO2tCQUFDO2tCQUFHLE9BQU8sTUFBTSxXQUFXLEdBQUcsR0FBRyxPQUFPLEdBQUcsQ0FBQyxNQUFNO2lCQUFFO2NBRTVEO1lBQ0Y7WUFDQSxzRUFBc0U7WUFDdEUsSUFBSSxBQUFDLGlCQUFpQixPQUFTLGtCQUFrQixLQUFNO2NBQ3JELFFBQVEsQ0FBQyxJQUFJLEdBQUcsSUFBSSxJQUFJO21CQUFJO2VBQU0sQ0FBQyxNQUFNLENBQUMsQ0FBQyxJQUFNLE9BQU8sR0FBRyxDQUFDO2NBQzVEO1lBQ0Y7WUFDQSxRQUFRLENBQUMsSUFBSSxHQUFHLEdBQUcsT0FBZ0I7WUFDbkM7VUFDRjtRQUNGO1FBQ0EsUUFBUSxDQUFDLElBQUksR0FBRztNQUNsQjtNQUNBLE9BQU87SUFDVDtFQUNGO0VBQ0EsT0FBTyxhQUNMLGtEQUFrRDtFQUNsRCxxRUFBcUU7RUFDckUsT0FBTyxRQUFRLFdBQ2YsNEZBQTRGO0VBQzVGLHFEQUFxRDtFQUNyRCxPQUFPLFVBQVUsV0FDakI7QUFFSiJ9