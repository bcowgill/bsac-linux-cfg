#!/usr/bin/env node
const fs = require("fs");
const { z } = require("zod");

const suite = "Zod test (NodeJS)";

const print = console.log;
const err = console.error;

print(suite);

/*
interface Result {
   results: {
      id: number;
      name: string;
      job: string;
   }[];
}
*/
const ResultSchema = z.object({
  results: z.array(
    z.object({
      id: z.number(),
      name: z.string(),
      job: z.string(),
    }),
  ),
});

function checkSchema(info, paramName, param, schema) {
  const check = schema.safeParse(param);
  if (!check.success) {
    err(
      "SchemaError: " + info + "\n" + paramName + ":",
      param,
      "\n",
      check.error,
    );
  }
  return check.success;
} // checkSchema()

function throwSchema(info, paramName, param, schema) {
  const check = schema.safeParse(param);
  if (!check.success) {
    throw new TypeError(
      "SchemaError: " +
        info +
        "\n" +
        paramName +
        ":" +
        JSON.stringify(param) +
        "\nZodError: " +
        check.error.toString(),
    );
  }
  return check.success;
} // throwSchema()

function printJobs(results) {
  if (
    checkSchema(
      "printJobs(results !~~ Result)",
      "results",
      results,
      ResultSchema,
    )
  ) {
    results.results.forEach(({ job }) => {
      print(job);
    });
  }
} // printJobs(): void

function logJobs(results) {
  throwSchema(
    "printJobs(results !~~ Result)",
    "results",
    results,
    ResultSchema,
  );
  results.results.forEach(({ job }) => {
    print(job);
  });
} // logJobs(): void

const r1 = {
  results: [
    {
      id: 1,
      name: "John",
      job: "developer",
    },
  ],
};

print("\nprintJobs(r1)");
printJobs(r1);

print("\nparse r1");
ResultSchema.parse(r1);

const data = JSON.parse(fs.readFileSync("data.json", "utf-8"));
const dataErr = JSON.parse(fs.readFileSync("data-error.json", "utf-8"));

print("\nprintJobs(from data.json)");
printJobs(data);

print("\nprintJobs(from data-error.json)");
printJobs(dataErr);

logJobs(dataErr);

//ResultSchema.parse(dataErr);
