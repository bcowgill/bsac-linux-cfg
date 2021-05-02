if (process.env.TEST_DEBUG) {
	// eslint-disable-next-line no-console
	console.error('in specs/testPolyfill.js')
}

// React expects requestAnimationFrame to exist so we polyfill for tests.
// eslint-disable-next-line no-multi-assign
const raf = (global.requestAnimationFrame = (cb) => {
	setTimeout(cb, 0)
})

export default raf
