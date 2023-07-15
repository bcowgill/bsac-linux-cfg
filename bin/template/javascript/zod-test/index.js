#!/usr/bin/env node
const fs = require("fs");
const print = console.log;

print("Zod test");

function printJobs (results) {
	results.results.forEach(({ job }) => {
		print(job);
	})
}

printJobs({
	results: [
		{
			id: 1,
			name: "John",
			job: "developer",
		},
	]
});

const data = JSON.parse(fs.readFileSync("data.json", "utf-8"));
const dataErr = JSON.parse(fs.readFileSync("data-error.json", "utf-8"));
printJobs(data);
printJobs(dataErr);
