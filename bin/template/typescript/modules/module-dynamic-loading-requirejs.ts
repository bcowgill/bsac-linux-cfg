// Dynamic module loading using module type amd
declare function require(moduleNames: string[], onLoad: (...args: any[]) => void): void;

const needZipValidation = true;

import  * as Zip from "./ZipCodeValidator";

if (needZipValidation) {
    require(["./ZipCodeValidator"], (ZipCodeValidator: typeof Zip) => {
        let validator = new ZipCodeValidator.ZipCodeValidator();
        if (validator.isAcceptable("...")) { /* ... */ }
    });
}
