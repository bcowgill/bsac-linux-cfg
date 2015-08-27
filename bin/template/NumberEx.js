/* Exceptional Javascript
 *
 * Take normal Javascript functions which return an error code
 * and instead cause them to throw an exception.
 * */

var NUMBER_ERROR = 'NumberError';
var NOT_A_NUMBER = 'not a number';
var NOT_FINITE_NUMBER = 'not a finite number';

// Samples of thrown errors from browser
// RangeError: toPrecision() argument must be between 1 and 21
// RangeError: toFixed() digits argument must be between 0 and 20

// Global Number methods

function parseFloatEx (string)
{
	return valueOfEx(parseFloat(string), 'parseFloatEx');
}

function parseIntEx (string, radix)
{
	radix = valueOfEx(radix, 'parseIntEx', 'radix argument is');
	return valueOfEx(parseInt(string, radix), 'parseIntEx');
}

// Number instance methods

function toExponentialEx (number)
{
	number = valueOfEx(number, 'toExponentialEx');
	return number.toExponential();
}

function toFixedEx (number, digits)
{
	number = valueOfEx(number, 'toFixedEx');
	digits = valueOfEx(digits, 'toFixedEx', 'digits argument is');
	return number.toFixed(digits);
}

function toPrecisionEx (number)
{
	number = new Number(number);
	return valueOfEx(number.toPrecision(), 'toPrecisionEx');
}

function valueOfEx (number, function, message)
{
	var value = new Number(number);
	function = function || 'valueOfEx';
	message = message || '';
	value = value.valueOf();
	if (!isFinite(value))
	{
		if (isNaN(value))
		{
			_throwEx(function, message + NOT_A_NUMBER, number);
		}
		_throwEx(function, message + NOT_FINITE_NUMBER, number);
	}
	return value;
}

function _throwEx (function, message, number)
{
	var exception = NUMBER_ERROR + ': ' + function + '() ' + message;
	exception = exception.replace('%n', '[' + number + ']');
	throw exception;
}


// Math functions...

// MathEx.log(-1) throws an error.