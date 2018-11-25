import { that } from '../facade'
import thing from '../facade'
import styles from '../styles/styles.scss'

console.log(`The ${thing} is, I am ${that} guy!`)

if (thing !== 'THING') {
	console.error('Problem with default export', thing)
}
if (that !== 'THAT') {
	console.error('Problem with named exports', that)
}

if (typeof document !== 'undefined') {
	document.write('saying hello from PARCEL packager')
}
console.log('saying hello from PARCEL packager', styles)
