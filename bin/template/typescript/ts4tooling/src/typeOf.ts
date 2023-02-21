export default function typeOf(source: unknown): string {
	const primitive = typeof source
	let type: string = primitive
	if (source === null) {
		type = 'null'
	} else if (primitive === 'object') {
		const konst = (source as object).constructor
		const konstructor = String(konst.name || 'Anon')
		type += konstructor !== 'Object' ? ':' + konstructor : ''
	}
	return type
}
