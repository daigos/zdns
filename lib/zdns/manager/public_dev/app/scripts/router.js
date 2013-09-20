define([
    'zdns',
    'modules/compose',
    'modules/zone'
], function ( zdns, Compose, Zone ) {

    var Router = Backbone.Router.extend({

        initialize: function() {
            //this.on( 'route', this.onChangeRoute );
        },

        routes: {
            '': 'root',
            'compose': 'compose',
            'zone(/:id)': 'zone',
            'zone/:id/:record': 'zone_record'
        },

        currentView: null,

        //==============================
        // Utils
        //==============================

        // Change View and old one
        changeView: function( view ) {
            if( null != this.currentView ) {
                this.currentView.undelegateEvents();
            }

            this.currentView = view;
            this.currentView.render();
        },

        //==============================
        // Route handlers
        //==============================
        root: function() {
            this.navigate( 'zone', { trigger: true } );
        },

        compose: function() {
            this.changeView( new Compose.Views.Layout() );
        },

        zone: function( id ) {
            zdns.current_zone_id = id;
            this.changeView( new Zone.Views.Layout({ zone_id: id }) );
        },

        zone_record: function( id, record_type ) {
            zdns.current_zone_id = id;
            zdns.current_record_type = record_type;
            this.changeView( new Zone.Views.Record({ id: id, record_type: record_type }) );
        },

        onChangeRoute: function( route ) {
        }

    });

    return Router;
});