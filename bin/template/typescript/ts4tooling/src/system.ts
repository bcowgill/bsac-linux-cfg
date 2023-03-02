/// <reference types="modernizr" />
import platform from 'platform'

export type Platform = typeof platform

export type Feature = {
	testAll: () => void
	extend: (name: string, fnCheckFeature: () => boolean) => Feature
} & Record<string, boolean>

export type PlatformFeatures = Platform & { unsupportedFeatures: string }

declare global {
	interface Window {
		feature: Feature
		Modernizr: FeatureDetects
		getComputedStyle: (
			elt: Element,
			pseudoElt?: string | null | undefined,
		) => CSSStyleDeclaration
	}
}
