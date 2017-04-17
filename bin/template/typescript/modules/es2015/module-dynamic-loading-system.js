var needZipValidation = true;
if (needZipValidation) {
    System.import("./ZipCodeValidator").then(function (ZipCodeValidator) {
        var x = new ZipCodeValidator();
        if (x.isAcceptable("...")) { }
    });
}
