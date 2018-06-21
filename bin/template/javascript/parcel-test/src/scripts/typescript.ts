   import './styles.scss';

   interface Data
   {
	  framework: string;
	  packager: string;
   }

   function getData(): Data
   {
	  return {
		 framework: 'Typescript',
		 packager: 'Parcel',
	  };
   }

const data = getData();

if (typeof document !== 'undefined') {

   const framework = document.getElementById( 'tsapp' );

   window.addEventListener(
	  'load',
	  () =>
	  {
		 framework.style.color = '#ff3e96';
		 framework.style.fontSize = '2rem';
		 framework.style.fontWeight = 'bold';
		 framework.innerHTML = `Hello from ${data.framework} and ${data.packager}!`;
	  } );
}

console.log(`Hello from ${data.framework} and ${data.packager}!`);
