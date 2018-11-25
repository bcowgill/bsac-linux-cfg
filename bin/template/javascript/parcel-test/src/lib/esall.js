import es6 from './es6'
import es7 from './es7'
import es8 from './es8'

const ES6 = es6()
const ES7 = es7()
const ES8 = es8()

try {
	const { pt } = ES6()
	const p0 = new pt(1, -4)
	console.log('ES6: pt: ' + p0, p0.magnitude())
} catch (error) {
	console.error('ES6', error)
}

try {
	const es7l = ES7()
	console.log('ES7 array methods', es7l)
	console.log('ES7 exponent', es7l.power2(4))
} catch (error) {
	console.error('ES7', error)
}

try {
	console.log('ES8', ES8.leftJustify(10)('ES') + ES8.rightJustify(10)(8))
} catch (error) {
	console.error('ES8', error)
}

const obj = { x: 'xxx', y: 1 }

try {
	console.log('ES8 values', ES8.orderedValues(obj))
} catch (error) {
	console.error('ES8', error)
}

try {
	console.log('ES8 entries', ES8.kvEntries(obj))
} catch (error) {
	console.error('ES8', error)
}

const objProps = {
	get oceans7() {
		return 777
	},
	get oceans8() {
		return 888
	},
}

try {
	console.log('ES8 own props', ES8.introspectProps(objProps))
} catch (error) {
	console.error('ES8', error)
}
