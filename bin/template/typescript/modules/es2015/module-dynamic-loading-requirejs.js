var needZipValidation = true;
if (needZipValidation) {
    require(["./ZipCodeValidator"], function (ZipCodeValidator) {
        var validator = new ZipCodeValidator.ZipCodeValidator();
        if (validator.isAcceptable("...")) { }
    });
}
