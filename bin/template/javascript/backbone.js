// some templates for use with backbone

// make debugging easier with extended classes and mixins:

var BaseClass = require('Base'),
    Super = BaseClass.prototype;

var MyClass = BaseClass.extend({
    initialize: function () {
        // keep track of what class we are and our parents to ease debugging
        this._inherits = _.union(this._inherits || [], ['MyClass', 'BaseClass', 'MixinClass']);
        Super.initialize.apply(this);
    }

});
_.extend(MyClass.prototype, require('MixinClass'));
