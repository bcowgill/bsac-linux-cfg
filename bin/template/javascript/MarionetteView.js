define(function(require) {

    'use strict';

    var myName = 'XyzzyView',
        myStyle = 'xyzzy-view',
        myParentName = 'Marionette.ItemView',
        Marionette = require('backbone.marionette'),
        Super = Marionette.ItemView,
        _ = require('underscore'),

        XyzzyView = Super.extend({

        tagName: 'section',
        className: myStyle,

        template: require('hbs!views/' + myName),
        // getTemplate: function ... if you need more control based on view state

        ui: {
            'top': '.header',
            'bigButton': '.big-button'
        },

        regions: {
            Top: '@ui.top'
        },

        events: {
            'click @ui.bigButton': 'whenClickButton'
        },

        triggers: {
            'mouseover @ui.icon': 'tooltip:show'
            // can also specify common options with a {} instead of a string
        },

        modelEvents: {
            // will manage unbinding and checking method existence
            // can specify multiple method names in the string.
            'change:property': 'whenPropertyChanged'
        },

        collectionEvents: {
            // will manage unbinding and checking method existence
            // can specify multiple method names in the string.
            'add': 'whenAddedModel'
        },

        // specify which properties of the options hash should be copied
        // to the view instance.
        XyzzyViewOptions: ['expanded'],

        initialize: function (options) {
            // track inheritance for easy debugging
            this._inherits = _.union(this._inherits || [],
                [myName, myParentName]);
            /*dbg:*/ console.debug('MUSTDO initialize ' + this._inherits[0], options);

            Super.prototype.initialize.apply(this, options);

            // bring supported options into the instance as properties
            this.mergeOptions(options, this.XyzzyViewOptions);

            // alternative to the modelEvents/collectionEvents config
            this.listenTo(this.model, 'change:property', this.whenPropertyChanged);
            this.listenTo(this.collection, 'add', this.whenAddedModel);

            this.on('tooltip:show', function (args) {
                //args.keys = view, model, collection as needed
            });

        },

        render: function () {
            return this;
        },

        onShow: function () {
            // view shown by a region, good time to add child views
            this.getGetRegion('Top').show(new TopView);
            this.Top.show(new TopView())
        },

        onBeforeAttach: function () {
            // before the view is attached to the document by a region.
        },

        onAttach: function () {
            // after view is attached to the document by a region.
        },

        onDomRefresh: function () {
            // Triggered after the view has been rendered, has been shown in
            // the DOM via a Marionette.Region, and has been re-rendered.
            // useful for dom dependent ui plugins like jquery UI or kendo UI
        },

        onBeforeDestroy: function (argsFromDestroy) {
        },

        onDestroy: function (argsFromDestroy) {
        },
    });

    return XyzzyView;
});