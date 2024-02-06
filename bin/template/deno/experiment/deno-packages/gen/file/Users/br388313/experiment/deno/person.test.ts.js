#!/usr/bin/env deno test
// before deno.jsonc file created: import { assertEquals } from "https://deno.land/std@0.211.0/assert/mod.ts";
import { assertEquals } from '$std/assert/mod.ts';
import { sayHello } from './Person.ts';
Deno.test('sayHello function', ()=>{
  const grace = {
    lastName: 'Hopper',
    firstName: 'Grace'
  };
  assertEquals('Hello, Grace!', sayHello(grace));
});
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImZpbGU6Ly8vVXNlcnMvYnIzODgzMTMvZXhwZXJpbWVudC9kZW5vL3BlcnNvbi50ZXN0LnRzIl0sInNvdXJjZXNDb250ZW50IjpbIiMhL3Vzci9iaW4vZW52IGRlbm8gdGVzdFxuLy8gYmVmb3JlIGRlbm8uanNvbmMgZmlsZSBjcmVhdGVkOiBpbXBvcnQgeyBhc3NlcnRFcXVhbHMgfSBmcm9tIFwiaHR0cHM6Ly9kZW5vLmxhbmQvc3RkQDAuMjExLjAvYXNzZXJ0L21vZC50c1wiO1xuaW1wb3J0IHsgYXNzZXJ0RXF1YWxzIH0gZnJvbSAnJHN0ZC9hc3NlcnQvbW9kLnRzJ1xuaW1wb3J0IFBlcnNvbiwgeyBzYXlIZWxsbyB9IGZyb20gJy4vUGVyc29uLnRzJ1xuXG5EZW5vLnRlc3QoJ3NheUhlbGxvIGZ1bmN0aW9uJywgKCkgPT4ge1xuXHRjb25zdCBncmFjZTogUGVyc29uID0ge1xuXHRcdGxhc3ROYW1lOiAnSG9wcGVyJyxcblx0XHRmaXJzdE5hbWU6ICdHcmFjZScsXG5cdH1cblxuXHRhc3NlcnRFcXVhbHMoJ0hlbGxvLCBHcmFjZSEnLCBzYXlIZWxsbyhncmFjZSkpXG59KVxuIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7QUFDQSw4R0FBOEc7QUFDOUcsU0FBUyxZQUFZLFFBQVEscUJBQW9CO0FBQ2pELFNBQWlCLFFBQVEsUUFBUSxjQUFhO0FBRTlDLEtBQUssSUFBSSxDQUFDLHFCQUFxQjtFQUM5QixNQUFNLFFBQWdCO0lBQ3JCLFVBQVU7SUFDVixXQUFXO0VBQ1o7RUFFQSxhQUFhLGlCQUFpQixTQUFTO0FBQ3hDIn0=