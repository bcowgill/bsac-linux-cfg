var needZipValidation = true;
if (needZipValidation) {
    var ZipCodeValidator = require("./ZipCodeValidator");
    var validator = new ZipCodeValidator();
    if (validator.isAcceptable("...")) { }
}
