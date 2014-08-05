/*jshint node: true */
/**
	@file lib/node-module.js
	@author Brent S.A. Cowgill
	@version 0.0.0
	@license {@link http://unlicense.org The Unlicense}

	@requires util
	@see {@link module:node-module}

	@description

	File description
*/
/**
	@module node-module

	@description

	Node Module to DO SOMETHING USEFUL.

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

