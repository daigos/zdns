define([
    'zdns',
    'modules/compose',
    'modules/zone'
], function ( zdns, Compose, Zone ) {

    var Router = Backbone.Router.extend({

        routes: {
            '': 'root',
            'compose': 'compose',
            'zone(/:id)(/:record)': 'zone_record',
            '*path': 'root'
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
            this.navigate( 'zone/' + zdns.zone_list.first().get('id') + '/soa', { trigger: true } );
        },

        compose: function() {
            this.changeView( new Compose.Views.Layout() );
        },

        zone_record: function( id, record_type ) {
            zdns.current_zone_id = id;
            zdns.current_record_type = record_type;
            this.changeView( new Zone.Views.RecordManager({ id: id, record_type: record_type }) );
        }

    });

    return Router;
});