import { readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { transformSync } from '@swc/core'

const DEBUG = false
const extensionsRegex = /\.(m?ts|tsx)$/
const target = 'es2018'

export async function load(url, context, nextLoad) {
	if (DEBUG) {
		console.warn(`load module ${url}`, extensionsRegex.test(url))
	}
	if (extensionsRegex.test(url)) {
		const path = fileURLToPath(url)
		if (DEBUG) {
			console.warn(`transpiling module ${path}`)
		}
		const rawSource = readFileSync(path, 'utf-8')

		const { code } = transformSync(rawSource, {
			filename: url,
			jsc: {
				target,
				parser: {
					syntax: 'typescript',
					dynamicImport: true,
				},
			},
			module: {
				type: 'es6',
			},
			sourceMaps: 'inline',
		})

		return {
			format: 'module',
			shortCircuit: true,
			source: code,
		}
	}

	// Assume files without extensions (e.g. tsc) are 'commonjs'
	context.format ||= 'commonjs'

	// Let Node.js handle all other URLs.
	return nextLoad(url, context)
}
