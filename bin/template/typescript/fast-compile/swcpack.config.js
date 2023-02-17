/* eslint-env node */
/* eslint-disable @typescript-eslint/no-var-requires */

const { config } = require('@swc/core/spack')

module.exports = config({
	entry: {
		app: __dirname + '/src/index.ts',
		app2: __dirname + '/src/not.ts',
	},
	output: {
		path: __dirname + '/lib',
	},
	module: {},
})
