import styles from '../assets/styles.scss';
import { that } from './facade';
import thing from './facade';

console.log(`The ${thing} is, I am ${that} guy!`);

if (typeof document !== 'undefined') {
	document.write('saying hello from PARCEL packager');
}
console.log('saying hello from PARCEL packager', styles);
