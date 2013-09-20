define([
    'zdns'
], function( zdns ) {

    var Record = zdns.module();

    Record.Views.Layout = Backbone.View.extend({

        el: '#zone-container',

        initialize: function( options ) {
            this.id = options.id;
            this.record_type = options.record_type;
        },

        render: function() {

        }
    });

    return Record;

});