#!/usr/bin/env deno run --allow-net
// deno run --allow-net www.ts
Deno.serve((_request: Request) => {
	return new Response("Hello, world! It's " + new Date())
})
