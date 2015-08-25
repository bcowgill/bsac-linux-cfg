/* Exceptional Javascript
 *
 * Take normal Javascript functions which return an error code
 * and instead cause them to throw an exception.
 * */

var NOT_A_NUMBER = 'Error: Not a number';
var NOT_FINITE_NUMBER = 'Error: Not a finite number';

function valueOfEx (number)
{
	number = valueOf(number);
	if (!isFinite(number))
	{
		if (isNaN(number))
		{
			throw NOT_A_NUMBER;
		}
		throw NOT_FINITE_NUMBER;
	}
	return number;
}

function parseFloatEx (string)
{
	return valueOfEx(parseFloat(string));
}

function parseIntEx (string)
{
	return valueOfEx(parseInt(string));
}
