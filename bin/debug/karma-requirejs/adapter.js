(function(karma, requirejs, locationPathname) {
// VERSION karma-requirejs 0.2.2
var __DEBUG = 1, __BREAK = 0, __MATCH = /./i, __M = 'karma-requirejs/adapter', __LOG = 0; if (__DEBUG) { console.trace(__M+'#_debug level ' + __DEBUG + ' =~ ' + __MATCH.toString()); } function _debug(level, match) { 'use strict'; if (level <= __DEBUG && (!match || __MATCH.test(match))) { ++__LOG; if (__DEBUG >= 10) { console.trace(__M+'?match['+match+']'); } if (__BREAK) { /*jshint -W087*/
  debugger; /*jshint +W087*/ }
return true; } return false; }

// monkey patch requirejs, to use append timestamps to sources
// to take advantage of karma's heavy caching
// it would work even without this hack, but with reloading all the files all the time

var normalizePath = function(path) {
  var normalized = [];
  var parts = path.split('/');

  for (var i = 0; i < parts.length; i++) {
    if (parts[i] === '.') {
      continue;
    }

    if (parts[i] === '..' && normalized.length && normalized[normalized.length - 1] !== '..') {
      normalized.pop();
      continue;
    }

    normalized.push(parts[i]);
  }

  return normalized.join('/');
};

var createPatchedLoad = function(files, originalLoadFn, locationPathname) {
  var IS_DEBUG = /debug\.html$/.test(locationPathname);

  return function(context, moduleName, url) {
    if(_debug(1,moduleName)){ console.log(__M+'#createPatchedLoad0 ' + moduleName + ' @ ' + url, context); }
    url = normalizePath(url);
    if(_debug(2,moduleName)){ console.log(__M+'#createPatchedLoad1 ' + moduleName + ' @ ' + url); }
    if (files.hasOwnProperty(url)) {
      if (!IS_DEBUG) {
        url = url + '?' + files[url];
        if(_debug(3,moduleName)){ console.log(__M+'#createPatchedLoad2 ' + moduleName + ' @ ' + url); }
      }
    } else {
      if (!/https?:\/\/\S+\.\S+/i.test(url)) {
        console.error('There is no timestamp for ' + url + '!');
      } else {
        if(_debug(3,moduleName)){ console.log(__M+'#createPatchedLoad3 ' + moduleName + ' @ ' + url); }
      }
    }

    return originalLoadFn.call(this, context, moduleName, url);
  };
};

// make it async
karma.loaded = function() {};

// patch require.js
requirejs.load = createPatchedLoad(karma.files, requirejs.load, locationPathname);

})(window.__karma__, window.requirejs, window.location.pathname);
