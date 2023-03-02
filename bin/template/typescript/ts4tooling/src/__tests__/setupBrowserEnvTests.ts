import 'feature.js' // adds window.feature

// Required by modernizr, so we fake it.
window.getComputedStyle = (
	// eslint-disable-next-line @typescript-eslint/no-unused-vars
	unused: Element,
	// eslint-disable-next-line @typescript-eslint/no-unused-vars
	unused2?: string | null | undefined,
) => {
	return new CSSStyleDeclaration()
}

import '../__vendor__/modernizr.min' // addes window.Modernizr
