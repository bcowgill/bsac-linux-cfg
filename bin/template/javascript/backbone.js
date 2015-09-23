// some templates for use with backbone

// make debugging easier with extended classes and mixins:

var BaseClass = require('Base'),
    Super = BaseClass.prototype;

var MyClass = BaseClass.extend({
    initialize: function () {
        // track inheritance for easy debugging
        this._inherits = _.union(this._inherits || [],
            ['MyClass', 'BaseClass', 'MixinClass']);

        Super.initialize.apply(this, arguments);

        // pick some of the options from those passed in to store in this
        _.extend(this, _.pick(options, [
            "prop1"
        ]));

    }

});
_.extend(MyClass.prototype, require('MixinClass'));


