/* weird-namespace.d.ts - commonjs.es6
export declare namespace Weird {
    function FWeird(value: any): void;
    class CWeird {
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
}
*/
 
// weird-namespace.js - commonjs.es6
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Weird;
(function (Weird) {
    function FWeird(value) {
        console.log('FWeird was called', value);
    }
    Weird.FWeird = FWeird;
    class CWeird {
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
            FWeird('from privates');
        }
        protecteds() {
            console.log(`${this.name} protecteds called`);
            this.privates();
        }
    }
    CWeird.klass = 'CWeird';
    Weird.CWeird = CWeird;
})(Weird = exports.Weird || (exports.Weird = {}));
const iWeird = new Weird.CWeird('bill');
iWeird.publics();
// iWeird.description = 'time cannot change me';  // read only, cannot
// iWeird.protecteds(); // not accessible from instance
// iWeird.privates(); // not accessible from instance
console.log(Weird.CWeird.klass);
Weird.CWeird.statics();
// iWeird.statics(); // not an instance method
// Weird.CWeird.klass = 'not allowed'; // read only, cannot
Weird.FWeird(void 0);
//# sourceMappingURL=weird-namespace.js.map