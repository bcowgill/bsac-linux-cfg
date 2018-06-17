import styles from './styles.scss';
import thing from './facade';
import { that } from './facade';

console.log(`The ${thing} is, I am ${that} guy!`);

if (typeof document !== 'undefined') {
	document.write('saying hello from PARCEL packager');
}
console.log('saying hello from PARCEL packager', styles);
