import figlet from "figlet";

declare module "bun" {
  interface Env {
    MY_ENV_VAR: string;
    bagel: string;
  }
}

console.log("Hello via Cross Bun!", Bun.version);
console.log("env var from .env file:", process.env.MY_ENV_VAR);
console.log("env-ish substituted from bunfig.toml file:", process.env.BAGEL);
console.log("All process.env values:", process.env);
console.log("All process.env keys:", Object.keys(process.env).sort());

const server = Bun.serve({
  port: 3000,
  fetch(req) {
    const body = figlet.textSync("Hot Cross Bun! " + Bun.version);
    return new Response(body);
  },
});

console.log(`Listening on http://localhost:${server.port} ...`);
