// some templates for use with backbone

// make debugging easier with extended classes and mixins:

var BaseClass = require('Base'),
    Super = BaseClass.prototype;

var MyClass = BaseClass.extend({
    initialize: function () {
        // track inheritance for easy debugging
        /*dbg:*/ this._inherits = _.union(this._inherits || [],
        /*dbg:*/    ['MyClass', 'BaseClass', 'MixinClass']);
        /*dbg:*/ console.debug('MUSTDO initialize ' + this._inherits[0]);

        Super.initialize.apply(this, arguments);

        // pick some of the options from those passed in to store in this
        _.extend(this, _.pick(options, [
            "prop1"
        ]));

        // listen to all events to see what's going on.
        this.listenTo(this, 'all', _.bind(function (eventName) {
            /*dbg:*/ console.debug('MUSTDO ' + eventName + ' ' + this._inherits[0], this, arguments);
        }, this));
    }

});
_.extend(MyClass.prototype, require('MixinClass'));

var mockFactory = require('mockFactory');

beforeEach(function() {
    mockFactory.createApplication();
    this.requests = mockFactory.installFakeAjax();
});

afterEach(function() {
    mockFactory.uninstallFakeAjax();
    mockFactory.deleteApplication();
});

