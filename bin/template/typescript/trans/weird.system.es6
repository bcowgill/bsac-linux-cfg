// weird.d.ts - system.es6
export declare function FWeird(value: any): void;
export declare class CWeird {
    name: string;
    protected prot: string;
    private priv;
    static readonly klass: string;
    readonly description: string;
    constructor(name: string, prot?: string, priv?: string);
    static statics(): void;
    whatever(): void;
    publics(): void;
    private privates();
    protected protecteds(): void;
}
 
// weird.js - system.es6
System.register([], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    function FWeird(value) {
        console.log('FWeird was called', value);
    }
    exports_1("FWeird", FWeird);
    var CWeird, iWeird;
    return {
        setters: [],
        execute: function () {
            CWeird = class CWeird {
                constructor(name, prot = 'protected string', priv = 'private string') {
                    this.name = name;
                    this.prot = prot;
                    this.priv = priv;
                    console.log(`CWeird constructor(${name})`);
                    this.description = `I am ${name} and I keep ${this.priv} a secret but share ${this.prot} with friends`;
                }
                static statics() {
                    console.log(`${CWeird.klass} statics called`);
                }
                whatever() {
                    console.log(`${this.name} whatever called`);
                }
                publics() {
                    console.log(`${this.name} publics called`);
                    this.protecteds();
                }
                privates() {
                    console.log(`${this.name} privates called`);
                }
                protecteds() {
                    console.log(`${this.name} protecteds called`);
                    this.privates();
                }
            };
            CWeird.klass = 'CWeird';
            exports_1("CWeird", CWeird);
            iWeird = new CWeird('bill');
            iWeird.publics();
            // iWeird.description = 'time cannot change me';  // read only, cannot
            // iWeird.protecteds(); // not accessible from instance
            // iWeird.privates(); // not accessible from instance
            console.log(CWeird.klass);
            CWeird.statics();
            // iWeird.statics(); // not an instance method
            // CWeird.klass = 'not allowed'; // read only, cannot
            FWeird(void 0);
        }
    };
});
//# sourceMappingURL=weird.js.map