/* weird.d.ts - amd.es6
export declare function FWeird(value: any): void;
export declare class CWeird {
    name: string;
    protected prot: string;
    private priv;
    static readonly klass: string;
    readonly description: string;
    constructor(name: string, prot?: string, priv?: string);
    static statics(): void;
    static staticArrow: () => void;
    whatever(): void;
    arrow: () => void;
    publics(): void;
    private privates();
    protected protecteds(): void;
}
*/
 
// weird.js - amd.es6
define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    function FWeird(value) {
        console.log('FWeird was called', value);
    }
    exports.FWeird = FWeird;
    class CWeird {
        constructor(name, prot = 'protected string', priv = 'private string') {
            this.name = name;
            this.prot = prot;
            this.priv = priv;
            this.arrow = () => {
                console.log(`${this.name} arrow called`);
                this.protecteds();
            };
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
    CWeird.staticArrow = () => {
        console.log(`${CWeird.klass} statics called`);
    };
    exports.CWeird = CWeird;
    const iWeird = new CWeird('bill');
    iWeird.publics();
    // iWeird.description = 'time cannot change me';  // read only, cannot
    // iWeird.protecteds(); // not accessible from instance
    // iWeird.privates(); // not accessible from instance
    console.log(CWeird.klass);
    CWeird.statics();
    // iWeird.statics(); // not an instance method
    // CWeird.klass = 'not allowed'; // read only, cannot
    FWeird(void 0);
});
//# sourceMappingURL=weird.js.map