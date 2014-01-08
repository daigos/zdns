(function() {
    var ZDNS = ZDNS || {};

    // enable views to trigger and bind named events
    // that other views can respond to
    Backbone.View.prototype.vent = _.extend({}, Backbone.Events);


    // ======================
    // Models
    // ======================
    ZDNS.Zone = Backbone.Model.extend({
        defaults: {
        },

        urlRoot: '/api/zone'
    });

    // ======================
    // Collections
    // ======================
    ZDNS.ZoneList = Backbone.Collection.extend({
        model: ZDNS.Zone,
        url: function() { return '/api/zone/'; },
        initialize: function() {
            this.fetch();
        }
    });

    // ======================
    // Views
    // ======================
    ZDNS.ZoneListView = Backbone.View.extend({
        el: '#zone-list',

        initialize: function() {
            this.zone_list = new ZDNS.ZoneList();
            this.zone_list.on('add', this.add, this);
        },

        render: function() {

        },

        add: function( zone ) {
            var zone_view = new ZDNS.ZoneItemView({
                model: zone
            });
            this.$el.append( zone_view.render().el );
            return zone_view;
        }
    });

    ZDNS.ZoneItemView = Backbone.View.extend({
        tagName: 'li',
        className: 'zone',
        template: '<a href="#">' +
                    '<h3 class="zone-name"><%- name %></h3>' +
                  '</a>',

        render: function() {
            this.$el.html( _.template( this.template, this.model.toJSON() ) );
            return this;
        }
    });

    // ======================
    // Application Router
    // ======================
    ZDNS.Router = Backbone.Router.extend({
        initialize: function() {
            this.zone();
        },

        routes: {
            '': 'index'
        },

        currentView: null,

        changeView: function( view ) {
            if( null != this.currentView ) {
                // remove listeners on old view
                this.currentView.undelegateEvents();
            }

            this.currentView = view;
            this.currentView.render();
        },

        index: function() {
            this.changeView( this.zoneListView );
        },

        zone: function() {
            this.zoneListView = new ZDNS.ZoneListView();
        }
    });

    // ======================
    // Application Object
    // ======================
    ZDNS.Application = function() {
        this.start = function() {
            var router = new ZDNS.Router();
            Backbone.history.start();
            router.navigate('', true);
        };
    };

    $(function() {

        FastClick.attach(document.body);

        var app = new ZDNS.Application();
        app.start();
    });

}).call(this);