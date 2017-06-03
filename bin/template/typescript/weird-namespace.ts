   export namespace Weird
   {
	  export function FWeird( value: any )
	  {
		 console.log( 'FWeird was called', value );
	  }

	  export class CWeird
	  {
		 static readonly klass: string = 'CWeird';

		 public readonly description: string;

		 constructor(
			public name: string,
			protected prot: string = 'protected string',
			private priv: string = 'private string'
		 )
		 {
			console.log( `CWeird constructor(${name})` );
			this.description = `I am ${name} and I keep ${this.priv} a secret but share ${this.prot} with friends`;
		 }

		 static statics()
		 {
			console.log( `${CWeird.klass} statics called` );
		 }

		 whatever() // also an instance method
		 {
			console.log( `${this.name} whatever called` );
		 }
		 public publics()
		 {
			console.log( `${this.name} publics called` );
			this.protecteds()
		 }
		 private privates()
		 {
			console.log( `${this.name} privates called` );
			FWeird( 'from privates' );
		 }
		 protected protecteds()
		 {
			console.log( `${this.name} protecteds called` );
			this.privates();
		 }
	  }
   }
   const iWeird = new Weird.CWeird( 'bill' );
   iWeird.publics();
   // iWeird.description = 'time cannot change me';  // read only, cannot
   // iWeird.protecteds(); // not accessible from instance
   // iWeird.privates(); // not accessible from instance

   console.log( Weird.CWeird.klass );
   Weird.CWeird.statics();
   // iWeird.statics(); // not an instance method
   // Weird.CWeird.klass = 'not allowed'; // read only, cannot

   Weird.FWeird( void 0 );
