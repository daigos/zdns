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
    });

    Record.Collections.Records = Backbone.Collection.extend({
        model: Record.Models.Record,
        initialize: function( options ) {
            //console.log('Collections.Records options:', options);
            this.record_type = options.record_type;
            this.zone_id = options.zone_id;
            this.url = '/api/zone/' + options.zone_id + '/' + options.record_type;
        }
    });

    // Record Item Base View
    // ----------------------

    Record.Views.Record = Backbone.View.extend({
        tagName: 'tr',

        _initialize: function( options ) {
            this.zone = options.zone;
            this.record_type = options.record_type;

            this.model.set( 'url', '/api/zone/' + this.zone.get('id') + '/' + this.record_type + '/' + this.model.get('id'));

            this.$zone_name = $('#modal-zone');
            this.$record_name = $('#modal-record');
        },

        events: {
            'click .edit .modal-toggle': 'setModalTitle'
        },

        setModalTitle: function( ev ) {
            this.$zone_name.text( this.zone.get('name') );
            this.$record_name.text( this.record_type );

            this.setModalBody();
        },

        setModalBody: function() {}

    });

    // Record Item View
    // ----------------------

    Record.Views.SoaRecord = Record.Views.Record.extend({
        el: '#zone-container',
        tagName: 'div',

        render: function() {
            this.$el.html( _.template( soaTmpl, this.model.toJSON() ) );
            return this;
        }

    });

    Record.Views.ARecord = Record.Views.Record.extend({ 
        initialize: function( options ) {

            this._initialize( options );

            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$address = $('#address');
            this.$enable_ptr = $('#enable-ptr');
        },

        render: function() {
            this.$el.html( _.template( aRowTmpl, this.model.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$address.val( this.model.get('address') );

            var ptr = this.model.get('enable_ptr');
            ptr ? this.$enable_ptr.attr('checked', 'checked') : this.$enable_ptr.removeAttr('checked');
        }
    });

    Record.Views.NsRecord = Record.Views.Record.extend({
        initialize: function( options ) {
            this._initialize( options );

            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$name_server = $('#nsdname');
        },

        render: function() {
            this.$el.html( _.template( nsRowTmpl, this.model.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$name_server.val( this.model.get('nsdname') );
        }
    });

    Record.Views.CnameRecord = Record.Views.Record.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$name_server = $('#cname');
        },

        render: function() {
            this.$el.html( _.template( cnameRowTmpl, this.model.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$name_server.val( this.model.get('cname') );
        }
    });

    Record.Views.MxRecord = Record.Views.Record.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$pref = $('#preference');
            this.$exchange = $('#exchange');
        },

        render: function() {
            this.$el.html( _.template( mxRowTmpl, this.model.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$pref.val( this.model.get('preference') );
            this.$exchange.val( this.model.get('exchange') );
        }
    });

    Record.Views.TxtRecord = Record.Views.Record.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$txt = $('#txt-data');
        },

        render: function() {
            this.$el.html( _.template( txtRowTmpl, this.model.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$txt.val( this.model.get('txt_data') );
        }
    });

    Record.Views.AaaaRecord = Record.Views.Record.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$address = $('#address');
            this.$enable_ptr = $('#enable-ptr');
        },

        render: function() {
            this.$el.html( _.template( aaaaRowTmpl, this.model.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$address.val( this.model.get('address') );

            var ptr = this.model.get('enable_ptr');
            ptr ? this.$enable_ptr.attr('checked', 'checked') : this.$enable_ptr.removeAttr('checked');
        }
    });

    return Record;

});