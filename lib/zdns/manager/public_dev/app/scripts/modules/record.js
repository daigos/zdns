define([
    'zdns',

    'text!templates/a_row.html',
    'text!templates/aaaa_row.html',
    'text!templates/cname_row.html',
    'text!templates/mx_row.html',
    'text!templates/ns_row.html',
    'text!templates/soa.html',
    'text!templates/txt_row.html',
    'modal'
], function( zdns, aRowTmpl, aaaaRowTmpl, cnameRowTmpl,
    mxRowTmpl, nsRowTmpl, soaTmpl, txtRowTmpl ) {

    var Record = zdns.module({ Models: {}, Collections: {} });

    Record.Models.Record = Backbone.Model.extend({
        /*
        initialize: function( options ) {
            console.log('Models.Record options:', options);
            this.url = '/api/zone/' + options.id + '/' + options.record_type + '/' + options.record_id;
        }
        */
    });

    Record.Collections.Records = Backbone.Collection.extend({
        model: Record.Models.Record,
        initialize: function( options ) {
            //console.log('Collections.Records options:', options);
            this.url = '/api/zone/' + options.zone_id + '/' + options.record_type;
        }
    });

    // Record Item Base View
    // ----------------------

    Record.Views.Record = Backbone.View.extend({
        tagName: 'tr',

        events: {
            'click .edit > .btn': 'showModal'
        },

        showModal: function( ev ) {
            console.log(ev);
        }
    });

    // Record Item View
    // ----------------------

    Record.Views.SoaRecord = Record.Views.Record.extend({
        el: '#zone-container',
        tagName: 'div',

        initialize: function() {
        },

        render: function() {
            this.$el.html( _.template( soaTmpl, this.model.toJSON() ) );
            return this;
        }
    });

    Record.Views.ARecord = Record.Views.Record.extend({
        initialize: function() {
        },

        render: function() {
            this.$el.html( _.template( aRowTmpl, this.model.toJSON() ) );
            return this;
        }
    });

    Record.Views.NsRecord = Record.Views.Record.extend({
        initialize: function() {
        },

        render: function() {
            this.$el.html( _.template( nsRowTmpl, this.model.toJSON() ) );
            return this;
        }
    });

    Record.Views.CnameRecord = Record.Views.Record.extend({
        initialize: function() {
        },

        render: function() {
            this.$el.html( _.template( cnameRowTmpl, this.model.toJSON() ) );
            return this;
        }
    });

    Record.Views.MxRecord = Record.Views.Record.extend({
        initialize: function() {
        },

        render: function() {
            this.$el.html( _.template( mxRowTmpl, this.model.toJSON() ) );
            return this;
        }
    });

    Record.Views.TxtRecord = Record.Views.Record.extend({
        initialize: function() {
        },

        render: function() {
            this.$el.html( _.template( txtRowTmpl, this.model.toJSON() ) );
            return this;
        }
    });

    Record.Views.AaaaRecord = Record.Views.Record.extend({
        initialize: function() {
        },

        render: function() {
            this.$el.html( _.template( aaaaRowTmpl, this.model.toJSON() ) );
            return this;
        }
    });

    return Record;

});