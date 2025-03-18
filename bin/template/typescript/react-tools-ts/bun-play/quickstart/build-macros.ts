// macro runs at build time and evaluates to static string
// so this injects the build date/time into the executable
export function buildTime(): string {
	return (new Date()).toISOString();
}
