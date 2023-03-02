import { Platform, PlatformFeatures } from './platform-system'

/**
 * Combines platform and modernizr results into a single object for debug logging.
 * @param platform the platform object containing OS and platform information.
 * @param modernizr the Modernizr feature object. defaults to window.Modernizr value.
 * @returns object same as platform but with unsupportedFeatures key added containing a string with only the Modernizr features that are not supported.
 */
export default function getPlatformModernizr(
	platform: Platform,
	modernizr = window.Modernizr,
): PlatformFeatures {
	type ModernizrBooleanValues = boolean | string
	type ModernizrBooleans =
		| boolean
		| AudioBoolean
		| FlashBoolean
		| IndexeddbBoolean
		| InputTypesBoolean
		| CssColumnsBoolean
		| WebpBoolean
		| DatauriBoolean
		| WebglextensionsBoolean

	const unsupported: string[] = []
	Object.keys(modernizr).forEach((key) => {
		const feature = modernizr[key] as ModernizrBooleans
		// if (
		// 	/^(audio|datauri|flash|indexeddb|csscolumns|webglextensions|webp)$/.test(
		// 		key,
		// 	)
		// ) {
		// 	console.warn(
		// 		`SPECIALS!! k:${key} f:${feature.toString()}`,
		// 		typeof feature,
		// 		feature.constructor.name,
		// 		feature instanceof Boolean,
		// 		!feature,
		// 		!feature.valueOf(),
		// 	)
		// }
		if (typeof feature === 'object') {
			if (feature instanceof Boolean && !feature.valueOf()) {
				unsupported.push([key, feature].join('::'))
			}
			Object.keys(feature).forEach((subKey) => {
				const subFeature = feature[subKey] as ModernizrBooleanValues
				if (typeof subFeature !== 'boolean' || !subFeature) {
					unsupported.push([key, subKey, subFeature].join(':'))
				}
			})
		} else if (!feature) {
			unsupported.push(key)
		}
	})

	return {
		...platform,
		unsupportedFeatures: unsupported.sort().join(' '),
	}
}
