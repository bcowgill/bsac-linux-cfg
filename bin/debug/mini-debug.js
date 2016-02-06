// a mini debugger to put into third party libraries to log/break when
// something interesting happens.
// set a desired log level with __DEBUG, set __BREAK to enter the debugger
// set __MATCH to a regex to match against to filter logs

var __DEBUG = 1, __BREAK = 0, __MATCH = /./i, __M = 'minidebug'; if (__DEBUG) { console.trace(__M+'#_debug level ' + __DEBUG + ' =~ ' + __MATCH.toString()); } function _debug(level, match) { 'use strict'; if (level <= __DEBUG && (!match || __MATCH.test(match))) { if (__DEBUG >= 10) { console.trace(__M+'?match['+match+']'); } if (__BREAK) { /*jshint -W087*/
	debugger; /*jshint +W087*/ }
return true; } return false; }


(function __test() {
	'use strict';
	if(_debug(1,'hidden')){ console.log(__M+'#method1', this); }
	if(_debug(1,'matched')){ console.log(__M+'#method2', this); }
})();
