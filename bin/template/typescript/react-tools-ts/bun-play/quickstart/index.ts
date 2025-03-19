import figlet from "figlet";
import { buildTime, getGitCommitHash } from './build-macros.ts' with { type: 'macro' };

declare module "bun" {
  interface Env {
    PATH: string;
    MY_ENV_VAR: string;
    BAGEL: string;
  }
}

console.log("Hello via Cross Bun!", Bun.version);
console.log("Built on Date: ", buildTime());
console.log(`From Git commit hash:  ${getGitCommitHash()}`);
console.log("env var from .env file:", process.env.MY_ENV_VAR);
console.log("env-ish substituted from bunfig.toml file:", process.env.BAGEL);
debugger;
console.log("All process.env values:", process.env);
console.log("All process.env keys:", Object.keys(process.env).sort());

const server = Bun.serve({
  port: 3000,
  fetch(_unusedReq) {
    const spc = "\n.\n   ";
    const paths = process.env.PATH?.split(/:/g);
    const body = figlet.textSync(`   Hot Cross Bun!${spc} ${Bun.version} ${spc} ${paths.join(spc)}`);
    console.log("Paths: ", paths)
    return new Response(body);
  },
});

console.log(`Listening on http://localhost:${server.port} ...`);
