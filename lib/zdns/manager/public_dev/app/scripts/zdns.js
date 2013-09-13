define([
    'jquery',
    'underscore',
    'backbone'
], function( $, _, Backbone ) {

    var zdns = {};

    zdns = _.extend(zdns, Backbone.Events);

    return _.extend(zdns, {

        // Initialize module base object
        module: function( options ) {
            return _.extend( { Views: {} }, options );
        }

    });

});