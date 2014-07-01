/**
	@file lib/node-module.js
	@module node-module
	@author Brent S.A. Cowgill
	@version 0.0.0
	@license {@link http://unlicense.org The Unlicense}

	@description

	Node Module to DO SOMETHING USEFUL.

	@requires util

	@example

	var oModule = require('node-module');
	console.log(oModule.something());

	@see {@link http://usejsdoc.org/index.html jsDoc Documentation}

	@todo IMPLEMENT THIS MODULE
*/

'use strict';

module.exports = {
	/**
		A function to do something

		@param  {String} string some string to do something with.
		@return {String} result string is cool.
	*/
	'something': function (string)
	{
		return '\'' + string + '\'';
	},
	'-': '-'
};
