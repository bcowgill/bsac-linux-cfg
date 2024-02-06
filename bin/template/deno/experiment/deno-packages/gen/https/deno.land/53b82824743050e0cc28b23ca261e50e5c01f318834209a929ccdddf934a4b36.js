// Copyright 2018-2024 the Deno authors. All rights reserved. MIT license.
// This module is browser compatible.
// This file been copied to `std/expect`.
/**
 * Converts the input into a string. Objects, Sets and Maps are sorted so as to
 * make tests less flaky
 * @param v Value to be formatted
 */ export function format(v) {
  // deno-lint-ignore no-explicit-any
  const { Deno } = globalThis;
  return typeof Deno?.inspect === "function" ? Deno.inspect(v, {
    depth: Infinity,
    sorted: true,
    trailingComma: true,
    compact: false,
    iterableLimit: Infinity,
    // getters should be true in assertEquals.
    getters: true,
    strAbbreviateSize: Infinity
  }) : `"${String(v).replace(/(?=["\\])/g, "\\")}"`;
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImh0dHBzOi8vZGVuby5sYW5kL3N0ZEAwLjIxMS4wL2Fzc2VydC9fZm9ybWF0LnRzIl0sInNvdXJjZXNDb250ZW50IjpbIi8vIENvcHlyaWdodCAyMDE4LTIwMjQgdGhlIERlbm8gYXV0aG9ycy4gQWxsIHJpZ2h0cyByZXNlcnZlZC4gTUlUIGxpY2Vuc2UuXG4vLyBUaGlzIG1vZHVsZSBpcyBicm93c2VyIGNvbXBhdGlibGUuXG5cbi8vIFRoaXMgZmlsZSBiZWVuIGNvcGllZCB0byBgc3RkL2V4cGVjdGAuXG5cbi8qKlxuICogQ29udmVydHMgdGhlIGlucHV0IGludG8gYSBzdHJpbmcuIE9iamVjdHMsIFNldHMgYW5kIE1hcHMgYXJlIHNvcnRlZCBzbyBhcyB0b1xuICogbWFrZSB0ZXN0cyBsZXNzIGZsYWt5XG4gKiBAcGFyYW0gdiBWYWx1ZSB0byBiZSBmb3JtYXR0ZWRcbiAqL1xuZXhwb3J0IGZ1bmN0aW9uIGZvcm1hdCh2OiB1bmtub3duKTogc3RyaW5nIHtcbiAgLy8gZGVuby1saW50LWlnbm9yZSBuby1leHBsaWNpdC1hbnlcbiAgY29uc3QgeyBEZW5vIH0gPSBnbG9iYWxUaGlzIGFzIGFueTtcbiAgcmV0dXJuIHR5cGVvZiBEZW5vPy5pbnNwZWN0ID09PSBcImZ1bmN0aW9uXCJcbiAgICA/IERlbm8uaW5zcGVjdCh2LCB7XG4gICAgICBkZXB0aDogSW5maW5pdHksXG4gICAgICBzb3J0ZWQ6IHRydWUsXG4gICAgICB0cmFpbGluZ0NvbW1hOiB0cnVlLFxuICAgICAgY29tcGFjdDogZmFsc2UsXG4gICAgICBpdGVyYWJsZUxpbWl0OiBJbmZpbml0eSxcbiAgICAgIC8vIGdldHRlcnMgc2hvdWxkIGJlIHRydWUgaW4gYXNzZXJ0RXF1YWxzLlxuICAgICAgZ2V0dGVyczogdHJ1ZSxcbiAgICAgIHN0ckFiYnJldmlhdGVTaXplOiBJbmZpbml0eSxcbiAgICB9KVxuICAgIDogYFwiJHtTdHJpbmcodikucmVwbGFjZSgvKD89W1wiXFxcXF0pL2csIFwiXFxcXFwiKX1cImA7XG59XG4iXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsMEVBQTBFO0FBQzFFLHFDQUFxQztBQUVyQyx5Q0FBeUM7QUFFekM7Ozs7Q0FJQyxHQUNELE9BQU8sU0FBUyxPQUFPLENBQVU7RUFDL0IsbUNBQW1DO0VBQ25DLE1BQU0sRUFBRSxJQUFJLEVBQUUsR0FBRztFQUNqQixPQUFPLE9BQU8sTUFBTSxZQUFZLGFBQzVCLEtBQUssT0FBTyxDQUFDLEdBQUc7SUFDaEIsT0FBTztJQUNQLFFBQVE7SUFDUixlQUFlO0lBQ2YsU0FBUztJQUNULGVBQWU7SUFDZiwwQ0FBMEM7SUFDMUMsU0FBUztJQUNULG1CQUFtQjtFQUNyQixLQUNFLENBQUMsQ0FBQyxFQUFFLE9BQU8sR0FBRyxPQUFPLENBQUMsY0FBYyxNQUFNLENBQUMsQ0FBQztBQUNsRCJ9