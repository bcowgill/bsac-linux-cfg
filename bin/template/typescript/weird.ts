   // becomes a function exported directly
   export function FWeird( value: any )
   {
	  console.log( 'FWeird was called', value );
   }

   export class CWeird
   {
	  static readonly klass: string = 'CWeird';

	  public readonly description: string;

	  // becomes CWeird() constructor function default export
	  constructor(
		 public name: string,
		 protected prot: string = 'protected string',
		 private priv: string = 'private string'
	  )
	  {
		 console.log( `CWeird constructor(${name})` );
		 this.description = `I am ${name} and I keep ${this.priv} a secret but share ${this.prot} with friends`;
	  }

	  // becomes CWeird.statics() as a static method
	  static statics()
	  {
		 console.log( `${CWeird.klass} statics called` );
	  }

	  // becomes CWeird.staticArrow() as a static method
	  static staticArrow = () =>
	  {
		 console.log( `${CWeird.klass} staticArrow called` );
	  }

	  // becomes CWeird.prototype.whatever() as an instance method
	  whatever()
	  {
		 console.log( `${this.name} whatever called` );
	  }

	  // becomes instance.arrow() as a direct instance method
	  public arrow = () =>
	  {
		 console.log( `${this.name} arrow called` );
		 this.protecteds()
	  }

	  // becomes CWeird.prototype.publics() as an instance method
	  public publics()
	  {
		 console.log( `${this.name} publics called` );
		 console.log( `description: ${this.description}` );
		 this.protecteds()
		 this.justAFunction( 'from publics()' );
		 this.equalsFunction( 'from publics()' );
	  }

	  // becomes CWeird.prototype.privates() as an instance method
	  private privates()
	  {
		 console.log( `${this.name} privates called` );
		 FWeird( 'from privates' );
	  }

	  // becomes CWeird.prototype.protecteds() as an instance method
	  protected protecteds()
	  {
		 console.log( `${this.name} protecteds called` );
		 this.privates();
	  }

	  // becomes instance.justAFunction() with no access to this
	  justAFunction = function ( name: string )
	  {
		 console.log( `CWeird.justAFunction(${name}) called - no ref to this` );
	  }

	  // becomes instance.equalsFunction() as a direct instance method with this accessible
	  equalsFunction = function ( this: CWeird, name: string )
	  {
		 console.log( `CWeird.equalsFunction(${name}) called desc: ${this.description}` );
		 this.privates();
	  }
   }

   const iWeird = new CWeird( 'bill' );
   iWeird.publics();
   iWeird.whatever();
   iWeird.arrow();
   iWeird.justAFunction( 'from iWeird' );
   iWeird.equalsFunction( 'from iWeird' );
   console.log( `iWeird.description: ${iWeird.description}` );
   // iWeird.description = 'time cannot change me';  // read only, cannot
   // iWeird.klass // statics not accessible directly from instance
   const konst: any = iWeird.constructor;
   console.log( `iWeird access static from instance: ${konst.klass}` ); // access a static from an instance
   // iWeird.protecteds(); // not accessible from instance
   // iWeird.privates(); // not accessible from instance

   console.log( `CWeird.klass = ${CWeird.klass}` );
   CWeird.statics();
   CWeird.staticArrow();
   // iWeird.statics(); // not an instance method
   // CWeird.klass = 'not allowed'; // read only, cannot

   FWeird( void 0 );
