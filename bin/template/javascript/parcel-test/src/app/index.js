import { that } from '../scripts/facade';
import thing from '../scripts/facade';
import styles from '../styles/styles.scss';

console.log(`The ${thing} is, I am ${that} guy!`);

if (typeof document !== 'undefined') {
	document.write('saying hello from PARCEL packager');
}
console.log('saying hello from PARCEL packager', styles);
