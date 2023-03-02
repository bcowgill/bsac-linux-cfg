import { Platform, Feature, PlatformFeatures } from './platform-system'

/**
 * Combines platform and feature.js results into a single object for debug logging.
 * @param platform the platform object containing OS and platform information.
 * @param feature the feature.js feature object. defaults to window.feature value.
 * @returns object same as platform but with unsupportedFeatures key added containing a string with only the feature.js features that are not supported.
 */
export default function getPlatformFeatures(
	platform: Platform,
	feature: Feature = window.feature,
): PlatformFeatures {
	const unsupported = Object.keys(feature)
		.filter((key) => !feature[key])
		.sort()
		.join(' ')
	return { ...platform, unsupportedFeatures: unsupported }
}
