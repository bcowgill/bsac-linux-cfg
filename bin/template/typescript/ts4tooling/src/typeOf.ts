export default function typeOf(source): string {
    const primitive = typeof source
    let type : string = primitive
    if (source === null) {
        type = 'null'
    }
    else if (primitive === 'object') {
        const konstructor = source.constructor.name || 'Anon'
        type += konstructor !== 'Object' ? ':' + konstructor : ''
    }
    return type
}
