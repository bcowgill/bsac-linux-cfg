define(["require", "exports", "./LettersOnlyValidator", "./ZipCodeValidator"], function (require, exports, LettersOnlyValidator_1, ZipCodeValidator_1) {
    "use strict";
    function __export(m) {
        for (var p in m) if (!exports.hasOwnProperty(p)) exports[p] = m[p];
    }
    Object.defineProperty(exports, "__esModule", { value: true });
    __export(LettersOnlyValidator_1); // exports class 'LettersOnlyValidator'
    __export(ZipCodeValidator_1); // exports class 'ZipCodeValidator'
    exports.max = 32;
    var MyThing = (function () {
        function MyThing() {
        }
        return MyThing;
    }());
    exports.default = MyThing;
    ;
});
