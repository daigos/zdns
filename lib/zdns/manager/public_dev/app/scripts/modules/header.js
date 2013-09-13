define([
    'zdns'
], function( zdns ) {
    var Header = zdns.module();

    Header.Views.Layout = Backbone.View.extend({

        el: '#g-head',

        events: {
            'click #do-back': 'doBack',
            'click #do-refresh': 'doRefresh'
        },

        doBack: function() {
            history.back();
            return false;
        },

        doRefresh: function() {
            location.reload();
            return false;
        }

    });

    return Header;

});