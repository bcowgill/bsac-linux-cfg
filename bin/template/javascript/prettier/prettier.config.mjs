// prettier.config.js, .prettierrc.js, prettier.config.mjs, or .prettierrc.mjs

/** @type {import("prettier").Config} */
const config = {
	endOfLine: "lf",
	useTabs: true,
	tabWidth: 4,
  trailingComma: "es5",
  semi: false,
  singleQuote: true,
  overrides: [
	
	{
		files: ["package*.json", "yarn.lock"],
		options: {
			parser: "json",
			useTabs: false,
			tabWidth: 2,
		},

	}
  ],
};

export default config;
