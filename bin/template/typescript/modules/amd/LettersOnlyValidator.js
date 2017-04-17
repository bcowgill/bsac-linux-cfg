define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    var lettersRegexp = /^[A-Za-z]+$/;
    var LettersOnlyValidator = (function () {
        function LettersOnlyValidator() {
        }
        LettersOnlyValidator.prototype.isAcceptable = function (s) {
            return lettersRegexp.test(s);
        };
        return LettersOnlyValidator;
    }());
    exports.LettersOnlyValidator = LettersOnlyValidator;
});
