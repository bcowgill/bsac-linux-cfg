
var Year = function (year) {
    this.year = year;
};

Year.prototype.isLeap = function () {
    return (0 === (this.year % 4))
        && (0 !== (this.year % 100)
        || (0 === (this.year % 400)));
};

module.exports = Year;
