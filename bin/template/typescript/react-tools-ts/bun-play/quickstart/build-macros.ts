// macro runs at build time and evaluates to static string
// https://bun.sh/docs/bundler/macros

// this injects the build date/time into the executable.
export function buildTime(): string {
  return (new Date()).toISOString();
}

// this injects the git commit hash into the executable.
export function getGitCommitHash() {
  const {stdout} = Bun.spawnSync({
    cmd: ["git", "rev-parse", "HEAD"],
    stdout: "pipe",
  });

  return stdout.toString();
}
