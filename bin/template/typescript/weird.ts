   export function FWeird( value: any ) // becomes a function exported directly
   {
	  console.log( 'FWeird was called', value );
   }

   export class CWeird
   {
	  static readonly klass: string = 'CWeird';

	  public readonly description: string;

	  constructor( // becomes CWeird() function default export
		 public name: string,
		 protected prot: string = 'protected string',
		 private priv: string = 'private string'
	  )
	  {
		 console.log( `CWeird constructor(${name})` );
		 this.description = `I am ${name} and I keep ${this.priv} a secret but share ${this.prot} with friends`;
	  }

	  static statics() // becomes CWeird.statics() as a static method
	  {
		 console.log( `${CWeird.klass} statics called` );
	  }

	  static staticArrow = () => // becomes CWeird.staticArrow() as a static method
	  {
		 console.log( `${CWeird.klass} statics called` );
	  }

	  whatever() // becomes CWeird.prototype.whatever() as an instance method
	  {
		 console.log( `${this.name} whatever called` );
	  }
	  public arrow = () => // becomes instance.arrow() as a direct instance method
	  {
		 console.log( `${this.name} arrow called` );
		 this.protecteds()
	  }
	  public publics() // becomes CWeird.prototype.publics() as an instance method
	  {
		 console.log( `${this.name} publics called` );
		 console.log( `description: ${this.description}` );
		 this.protecteds()
	  }
	  private privates() // becomes CWeird.prototype.privates() as an instance method
	  {
		 console.log( `${this.name} privates called` );
		 FWeird( 'from privates' );
	  }
	  protected protecteds() // becomes CWeird.prototype.protecteds() as an instance method
	  {
		 console.log( `${this.name} protecteds called` );
		 this.privates();
	  }
   }

   const iWeird = new CWeird( 'bill' );
   iWeird.publics();
   // iWeird.description = 'time cannot change me';  // read only, cannot
   // iWeird.protecteds(); // not accessible from instance
   // iWeird.privates(); // not accessible from instance

   console.log( CWeird.klass );
   CWeird.statics();
   // iWeird.statics(); // not an instance method
   // CWeird.klass = 'not allowed'; // read only, cannot

   FWeird( void 0 );
