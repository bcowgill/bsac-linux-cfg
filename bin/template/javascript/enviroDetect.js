// enviroDetect.js
// Detecting your environment and getting access to the global object
// http://stackoverflow.com/questions/17575790/environment-detection-node-js-or-browser
// https://developer.mozilla.org/en-US/docs/Web/API/Window/self
'use strict';

var isBrowser = new Function("try { return this === window; } catch (e) { return false; }");
var isWebWorker = new Function("try { return this === WorkerGlobalScope; } catch (e) { return false; }");
var isNode = new Function("try { return this === global; } catch (e) { return false; }");
var isKarma = new Function("try { return '__karma__' in this; } catch (e) { return false; }");

var memoize = function (fn) {
    var memory;
    return function () {
        return memory === void 0 ? (memory = fn()) : memory;
    };
};

// http://engineering.shapesecurity.com/2015/01/detecting-phantomjs-based-visitors.html
var isPhantomJS = function () {
    var isPhantom = false;
    var error;
    // console.error("isPhantomJS");
    try {
        null[0]();
    } catch (exception) {
        // console.error("isPhantomJS catch ", exception, exception.stack);
        error = exception;
    }
    if (error.stack.indexOf('phantomjs') > -1) {
        isPhantom = 'phantom stack';
    }
    else if (window && (window.callPhantom || window._phantom)) {
        isPhantom = 'phantom globals';
    }
    else if (navigator && (!(navigator.plugins instanceof PluginArray) || navigator.plugins.length == 0)) {
        isPhantom = 'phantom plugins';
    }
    else if (!Function.prototype.bind) {
        isPhantom = 'phantom bind1';
    }
    else if (Function.prototype.bind.toString().replace(/bind/g, 'Error') != Error.toString()) {
        isPhantom = 'phantom bind2';
    }
    else if (Function.prototype.toString.toString().replace(/toString/g, 'Error') != Error.toString()) {
        isPhantom = 'phantom bind3';
    }
    // console.log("isPhantomJS ", isPhantom);
    return !!isPhantom;
};

var getGlobal = new Function("return this;");


function _addElement (message) {
    try {
        var newDiv = document.createElement("div"),
            newContent = document.createTextNode(message);

        newDiv.appendChild(newContent);

        document.body.insertBefore(newDiv, document.body.firstChild);
    }
    finally {}
}

var spray = function () {
    var global = getGlobal(),
        args = Array.prototype.slice.call(arguments);
    if (global.document && global.document.body) {
        _addElement(args.join());
    }
    if (global.console && global.console.log) {
        global.console.log.apply(global.console, args);
    }
    if (global.alert) {
        alert.call(null, args.join());
    }
};

var enviro = {
    getGlobal: memoize(getGlobal),
    isBrowser: memoize(isBrowser),
    isWebWorker: memoize(isWebWorker),
    isNode: memoize(isNode),
    isPhantomJS: memoize(isPhantomJS),
    isKarma: memoize(isKarma),
    spray: spray,
    '-': '-'
};

if (typeof module === 'object' && module.exports) {
    module.exports = enviro;
}

spray(enviro.getGlobal());
spray('node', enviro.isNode());
spray('browser', enviro.isBrowser());
spray('webworker', enviro.isWebWorker());
spray('phantomjs', enviro.isPhantomJS());
spray('karma', enviro.isKarma());
