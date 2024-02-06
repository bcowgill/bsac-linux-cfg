// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
/**
 * Error thrown when an assertion fails.
 *
 * @example
 * ```ts
 * import { AssertionError } from "https://deno.land/std@$STD_VERSION/assert/assertion_error.ts";
 *
 * throw new AssertionError("Assertion failed");
 * ```
 */ export class AssertionError extends Error {
  /** Constructs a new instance. */ constructor(message){
    super(message);
    this.name = "AssertionError";
  }
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9hc3NlcnRpb25fZXJyb3IudHMiXSwic291cmNlc0NvbnRlbnQiOlsiLy8gQ29weXJpZ2h0IDIwMTgtMjAyNCB0aGUgRGVubyBhdXRob3JzLiBBbGwgcmlnaHRzIHJlc2VydmVkLiBNSVQgbGljZW5zZS5cblxuLyoqXG4gKiBFcnJvciB0aHJvd24gd2hlbiBhbiBhc3NlcnRpb24gZmFpbHMuXG4gKlxuICogQGV4YW1wbGVcbiAqIGBgYHRzXG4gKiBpbXBvcnQgeyBBc3NlcnRpb25FcnJvciB9IGZyb20gXCJodHRwczovL2Rlbm8ubGFuZC9zdGRAJFNURF9WRVJTSU9OL2Fzc2VydC9hc3NlcnRpb25fZXJyb3IudHNcIjtcbiAqXG4gKiB0aHJvdyBuZXcgQXNzZXJ0aW9uRXJyb3IoXCJBc3NlcnRpb24gZmFpbGVkXCIpO1xuICogYGBgXG4gKi9cbmV4cG9ydCBjbGFzcyBBc3NlcnRpb25FcnJvciBleHRlbmRzIEVycm9yIHtcbiAgLyoqIENvbnN0cnVjdHMgYSBuZXcgaW5zdGFuY2UuICovXG4gIGNvbnN0cnVjdG9yKG1lc3NhZ2U6IHN0cmluZykge1xuICAgIHN1cGVyKG1lc3NhZ2UpO1xuICAgIHRoaXMubmFtZSA9IFwiQXNzZXJ0aW9uRXJyb3JcIjtcbiAgfVxufVxuIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUFBLDBFQUEwRTtBQUUxRTs7Ozs7Ozs7O0NBU0MsR0FDRCxPQUFPLE1BQU0sdUJBQXVCO0VBQ2xDLCtCQUErQixHQUMvQixZQUFZLE9BQWUsQ0FBRTtJQUMzQixLQUFLLENBQUM7SUFDTixJQUFJLENBQUMsSUFBSSxHQUFHO0VBQ2Q7QUFDRiJ9