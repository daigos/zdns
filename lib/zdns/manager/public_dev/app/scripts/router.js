define([
    'zdns'
], function ( zdns ) {
    var Router = Backbone.Router.extend({

        initialize: function() {
            //this.on( 'route', this.onChangeRoute );
        },

        routes: {
            '': 'root',
            'zone(/:id)': 'zone',
            'zone/:id/:record': 'zone_record'
        },

        root: function() {
            this.navigate( 'zone', { trigger: true } );
        },

        zone: function( id ) {
            console.log('zone id: ', id);
            zdns.current_zone_id = id;
        },

        zone_record: function( id, record_type ) {
            zdns.current_zone_id = id;
            zdns.current_record_type = record_type;

        },

        onChangeRoute: function( route ) {
        }

    });

    return Router;
});