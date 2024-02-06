// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
import { format } from "./_format.ts";
import { AssertionError } from "./assertion_error.ts";
import { buildMessage, diff, diffstr } from "./_diff.ts";
import { CAN_NOT_DISPLAY } from "./_constants.ts";
import { red } from "../fmt/colors.ts";
/**
 * Make an assertion that `actual` and `expected` are strictly equal. If
 * not then throw.
 *
 * @example
 * ```ts
 * import { assertStrictEquals } from "https://deno.land/std@$STD_VERSION/assert/assert_strict_equals.ts";
 *
 * const a = {};
 * const b = a;
 * assertStrictEquals(a, b); // Doesn't throw
 *
 * const c = {};
 * const d = {};
 * assertStrictEquals(c, d); // Throws
 * ```
 */ export function assertStrictEquals(actual, expected, msg) {
  if (Object.is(actual, expected)) {
    return;
  }
  const msgSuffix = msg ? `: ${msg}` : ".";
  let message;
  const actualString = format(actual);
  const expectedString = format(expected);
  if (actualString === expectedString) {
    const withOffset = actualString.split("\n").map((l)=>`    ${l}`).join("\n");
    message = `Values have the same structure but are not reference-equal${msgSuffix}\n\n${red(withOffset)}\n`;
  } else {
    try {
      const stringDiff = typeof actual === "string" && typeof expected === "string";
      const diffResult = stringDiff ? diffstr(actual, expected) : diff(actualString.split("\n"), expectedString.split("\n"));
      const diffMsg = buildMessage(diffResult, {
        stringDiff
      }).join("\n");
      message = `Values are not strictly equal${msgSuffix}\n${diffMsg}`;
    } catch  {
      message = `\n${red(CAN_NOT_DISPLAY)} + \n\n`;
    }
  }
  throw new AssertionError(message);
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRfc3RyaWN0X2VxdWFscy50cyJdLCJzb3VyY2VzQ29udGVudCI6WyIvLyBDb3B5cmlnaHQgMjAxOC0yMDI0IHRoZSBEZW5vIGF1dGhvcnMuIEFsbCByaWdodHMgcmVzZXJ2ZWQuIE1JVCBsaWNlbnNlLlxuaW1wb3J0IHsgZm9ybWF0IH0gZnJvbSBcIi4vX2Zvcm1hdC50c1wiO1xuaW1wb3J0IHsgQXNzZXJ0aW9uRXJyb3IgfSBmcm9tIFwiLi9hc3NlcnRpb25fZXJyb3IudHNcIjtcbmltcG9ydCB7IGJ1aWxkTWVzc2FnZSwgZGlmZiwgZGlmZnN0ciB9IGZyb20gXCIuL19kaWZmLnRzXCI7XG5pbXBvcnQgeyBDQU5fTk9UX0RJU1BMQVkgfSBmcm9tIFwiLi9fY29uc3RhbnRzLnRzXCI7XG5pbXBvcnQgeyByZWQgfSBmcm9tIFwiLi4vZm10L2NvbG9ycy50c1wiO1xuXG4vKipcbiAqIE1ha2UgYW4gYXNzZXJ0aW9uIHRoYXQgYGFjdHVhbGAgYW5kIGBleHBlY3RlZGAgYXJlIHN0cmljdGx5IGVxdWFsLiBJZlxuICogbm90IHRoZW4gdGhyb3cuXG4gKlxuICogQGV4YW1wbGVcbiAqIGBgYHRzXG4gKiBpbXBvcnQgeyBhc3NlcnRTdHJpY3RFcXVhbHMgfSBmcm9tIFwiaHR0cHM6Ly9kZW5vLmxhbmQvc3RkQCRTVERfVkVSU0lPTi9hc3NlcnQvYXNzZXJ0X3N0cmljdF9lcXVhbHMudHNcIjtcbiAqXG4gKiBjb25zdCBhID0ge307XG4gKiBjb25zdCBiID0gYTtcbiAqIGFzc2VydFN0cmljdEVxdWFscyhhLCBiKTsgLy8gRG9lc24ndCB0aHJvd1xuICpcbiAqIGNvbnN0IGMgPSB7fTtcbiAqIGNvbnN0IGQgPSB7fTtcbiAqIGFzc2VydFN0cmljdEVxdWFscyhjLCBkKTsgLy8gVGhyb3dzXG4gKiBgYGBcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGFzc2VydFN0cmljdEVxdWFsczxUPihcbiAgYWN0dWFsOiB1bmtub3duLFxuICBleHBlY3RlZDogVCxcbiAgbXNnPzogc3RyaW5nLFxuKTogYXNzZXJ0cyBhY3R1YWwgaXMgVCB7XG4gIGlmIChPYmplY3QuaXMoYWN0dWFsLCBleHBlY3RlZCkpIHtcbiAgICByZXR1cm47XG4gIH1cblxuICBjb25zdCBtc2dTdWZmaXggPSBtc2cgPyBgOiAke21zZ31gIDogXCIuXCI7XG4gIGxldCBtZXNzYWdlOiBzdHJpbmc7XG5cbiAgY29uc3QgYWN0dWFsU3RyaW5nID0gZm9ybWF0KGFjdHVhbCk7XG4gIGNvbnN0IGV4cGVjdGVkU3RyaW5nID0gZm9ybWF0KGV4cGVjdGVkKTtcblxuICBpZiAoYWN0dWFsU3RyaW5nID09PSBleHBlY3RlZFN0cmluZykge1xuICAgIGNvbnN0IHdpdGhPZmZzZXQgPSBhY3R1YWxTdHJpbmdcbiAgICAgIC5zcGxpdChcIlxcblwiKVxuICAgICAgLm1hcCgobCkgPT4gYCAgICAke2x9YClcbiAgICAgIC5qb2luKFwiXFxuXCIpO1xuICAgIG1lc3NhZ2UgPVxuICAgICAgYFZhbHVlcyBoYXZlIHRoZSBzYW1lIHN0cnVjdHVyZSBidXQgYXJlIG5vdCByZWZlcmVuY2UtZXF1YWwke21zZ1N1ZmZpeH1cXG5cXG4ke1xuICAgICAgICByZWQod2l0aE9mZnNldClcbiAgICAgIH1cXG5gO1xuICB9IGVsc2Uge1xuICAgIHRyeSB7XG4gICAgICBjb25zdCBzdHJpbmdEaWZmID0gKHR5cGVvZiBhY3R1YWwgPT09IFwic3RyaW5nXCIpICYmXG4gICAgICAgICh0eXBlb2YgZXhwZWN0ZWQgPT09IFwic3RyaW5nXCIpO1xuICAgICAgY29uc3QgZGlmZlJlc3VsdCA9IHN0cmluZ0RpZmZcbiAgICAgICAgPyBkaWZmc3RyKGFjdHVhbCBhcyBzdHJpbmcsIGV4cGVjdGVkIGFzIHN0cmluZylcbiAgICAgICAgOiBkaWZmKGFjdHVhbFN0cmluZy5zcGxpdChcIlxcblwiKSwgZXhwZWN0ZWRTdHJpbmcuc3BsaXQoXCJcXG5cIikpO1xuICAgICAgY29uc3QgZGlmZk1zZyA9IGJ1aWxkTWVzc2FnZShkaWZmUmVzdWx0LCB7IHN0cmluZ0RpZmYgfSkuam9pbihcIlxcblwiKTtcbiAgICAgIG1lc3NhZ2UgPSBgVmFsdWVzIGFyZSBub3Qgc3RyaWN0bHkgZXF1YWwke21zZ1N1ZmZpeH1cXG4ke2RpZmZNc2d9YDtcbiAgICB9IGNhdGNoIHtcbiAgICAgIG1lc3NhZ2UgPSBgXFxuJHtyZWQoQ0FOX05PVF9ESVNQTEFZKX0gKyBcXG5cXG5gO1xuICAgIH1cbiAgfVxuXG4gIHRocm93IG5ldyBBc3NlcnRpb25FcnJvcihtZXNzYWdlKTtcbn1cbiJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSwwRUFBMEU7QUFDMUUsU0FBUyxNQUFNLFFBQVEsZUFBZTtBQUN0QyxTQUFTLGNBQWMsUUFBUSx1QkFBdUI7QUFDdEQsU0FBUyxZQUFZLEVBQUUsSUFBSSxFQUFFLE9BQU8sUUFBUSxhQUFhO0FBQ3pELFNBQVMsZUFBZSxRQUFRLGtCQUFrQjtBQUNsRCxTQUFTLEdBQUcsUUFBUSxtQkFBbUI7QUFFdkM7Ozs7Ozs7Ozs7Ozs7Ozs7Q0FnQkMsR0FDRCxPQUFPLFNBQVMsbUJBQ2QsTUFBZSxFQUNmLFFBQVcsRUFDWCxHQUFZO0VBRVosSUFBSSxPQUFPLEVBQUUsQ0FBQyxRQUFRLFdBQVc7SUFDL0I7RUFDRjtFQUVBLE1BQU0sWUFBWSxNQUFNLENBQUMsRUFBRSxFQUFFLElBQUksQ0FBQyxHQUFHO0VBQ3JDLElBQUk7RUFFSixNQUFNLGVBQWUsT0FBTztFQUM1QixNQUFNLGlCQUFpQixPQUFPO0VBRTlCLElBQUksaUJBQWlCLGdCQUFnQjtJQUNuQyxNQUFNLGFBQWEsYUFDaEIsS0FBSyxDQUFDLE1BQ04sR0FBRyxDQUFDLENBQUMsSUFBTSxDQUFDLElBQUksRUFBRSxFQUFFLENBQUMsRUFDckIsSUFBSSxDQUFDO0lBQ1IsVUFDRSxDQUFDLDBEQUEwRCxFQUFFLFVBQVUsSUFBSSxFQUN6RSxJQUFJLFlBQ0wsRUFBRSxDQUFDO0VBQ1IsT0FBTztJQUNMLElBQUk7TUFDRixNQUFNLGFBQWEsQUFBQyxPQUFPLFdBQVcsWUFDbkMsT0FBTyxhQUFhO01BQ3ZCLE1BQU0sYUFBYSxhQUNmLFFBQVEsUUFBa0IsWUFDMUIsS0FBSyxhQUFhLEtBQUssQ0FBQyxPQUFPLGVBQWUsS0FBSyxDQUFDO01BQ3hELE1BQU0sVUFBVSxhQUFhLFlBQVk7UUFBRTtNQUFXLEdBQUcsSUFBSSxDQUFDO01BQzlELFVBQVUsQ0FBQyw2QkFBNkIsRUFBRSxVQUFVLEVBQUUsRUFBRSxRQUFRLENBQUM7SUFDbkUsRUFBRSxPQUFNO01BQ04sVUFBVSxDQUFDLEVBQUUsRUFBRSxJQUFJLGlCQUFpQixPQUFPLENBQUM7SUFDOUM7RUFDRjtFQUVBLE1BQU0sSUFBSSxlQUFlO0FBQzNCIn0=