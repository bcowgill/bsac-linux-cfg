// inline comment
/*global window, alert, console, jquery, it, describe */
/* Block Comment
 *
 *
 *
 * */

function something (param) {/* jshint maxcomplexity: false */
	var string = "a string 'to' \"be\" ignored something() ";
}

var another = function (param) {/* jshint -W034 */
	var string = 'a string \'to\' "be" ignored another() ';
	something('blue');
}

var singleton = {
	method: function (param) {
		something(this);
		another(this);
	}
};

another(function () {
	singleton.method(this);
});

function _private () {
}

function public () {
}

