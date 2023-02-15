/* eslint-env node */
/* eslint-disable @typescript-eslint/no-var-requires */

const { config } = require('@swc/core/spack')

module.exports = config({
	entry: {
		web: __dirname + '/src/index.ts',
	},
	output: {
		path: __dirname + '/lib',
	},
	module: {},
})
