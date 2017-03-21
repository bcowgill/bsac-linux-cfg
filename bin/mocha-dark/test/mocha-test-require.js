requirejs.config({
    // By default load any module IDs from src/
    baseUrl: 'src',

    // except, if the module ID starts with "app",
    // load it from the js/app directory. paths
    // config is relative to the baseUrl, and
    // never includes a ".js" extension since
    // the paths config could be for a directory.
    paths: {
//        mocha: '../node_modules/mocha/mocha',
        mocha: '../mocha-dark-3.2.0/mocha-dark',
//        mocha: '../mocha/mocha',
        chai: '../node_modules/chai/chai'
    },

    shim: {
        mocha: {
            exports: 'mocha'
        }
    }
});

// Start the tests after loading testing libraries
requirejs(['require', 'mocha', 'chai'],
function (require, mocha, chai) {
    // mocha, chai module are all
    // loaded and can be used here now.

    mocha.setup({ ui: 'bdd' });

    // require test plans here.
    require([
        './test/a-first-test.test.js'
//        './src/object.js',
//        './src/object.spec.js'
    ], function () {
        mocha.checkLeaks();
        mocha.globals(['jQuery']);
        mocha.run();
    });
});
