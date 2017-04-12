/*!
	types.ts defines some useful types
	tsc --project tsconfig.json5
*/
//declare BooleanArray Array<boolean>;
//declare NumberArray Array<number>;
//declare StringArray Array<string>;

enum Ordinal { MINUS_TWO = -2, MINUS_ONE, ZERO, ONE, TWO };
let ord : Ordinal = Ordinal.ONE;
let ordName : string = Ordinal[Ordinal.TWO];

