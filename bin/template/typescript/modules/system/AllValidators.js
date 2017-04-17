System.register(["./LettersOnlyValidator", "./ZipCodeValidator"], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var max, MyThing;
    var exportedNames_1 = {
        "max": true
    };
    function exportStar_1(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default" && !exportedNames_1.hasOwnProperty(n)) exports[n] = m[n];
        }
        exports_1(exports);
    }
    return {
        setters: [
            function (LettersOnlyValidator_1_1) {
                exportStar_1(LettersOnlyValidator_1_1);
            },
            function (ZipCodeValidator_1_1) {
                exportStar_1(ZipCodeValidator_1_1);
            }
        ],
        execute: function () {
            exports_1("max", max = 32);
            MyThing = (function () {
                function MyThing() {
                }
                return MyThing;
            }());
            exports_1("default", MyThing);
            ;
        }
    };
});
