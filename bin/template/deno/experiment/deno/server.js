#!/usr/bin/env deno run --allow-env --allow-read --allow-net
import express from 'npm:express@4'

const PORT = 3000
const app = express()

app.get('/', (_request, response) => {
	response.send('Hello from Express! on ' + new Date())
})

app.listen(PORT)
console.log(`Listening to http://localhost:${PORT}`)
