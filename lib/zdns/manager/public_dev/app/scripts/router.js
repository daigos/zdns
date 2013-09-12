define([
    'app'
], function ( app ) {
    var Router = Backbone.Router.extend({

        initialize: function() {
            this.on('route', this.onChangeRoute);
        },

        routes: {

        },

        onChangeRoute: function( route ) {
            console.log( route );
        }


    });

    return Router;
});