var ParseIntBasedZipCodeValidator = (function () {
    function ParseIntBasedZipCodeValidator() {
    }
    ParseIntBasedZipCodeValidator.prototype.isAcceptable = function (s) {
        return s.length === 5 && parseInt(s).toString() === s;
    };
    return ParseIntBasedZipCodeValidator;
}());
export { ParseIntBasedZipCodeValidator };
// Export original validator but rename it
export { ZipCodeValidator as RegExpBasedZipCodeValidator } from "./ZipCodeValidator";
