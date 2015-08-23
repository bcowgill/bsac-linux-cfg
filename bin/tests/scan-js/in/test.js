// inline comment

/* Block Comment
 *
 *
 *
 * */

function something (param) {
	var string = "a string 'to' \"be\" ignored something() ";
}

var another = function (param) {
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

