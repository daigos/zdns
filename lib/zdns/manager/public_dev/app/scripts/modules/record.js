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
        initialize: function(options) {
        }
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

        initialize: function( options ) {
            this.zone = options.zone;
            this.record_type = options.record_type;

            if( this.record_type === 'soa') {
                this.model.set( 'url', '/api/zone/' + this.zone.get('id') );
            } else {
                this.model.set( 'url', '/api/zone/' + this.zone.get('id') + '/' + this.record_type + '/' + this.model.get('id'));
            }

            this.$zone_name = $('#modal-zone');
            this.$record_name = $('#modal-record');

        }
    });

    // Record Item View
    // ----------------------

    Record.Views.SoaRecord = Record.Views.Record.extend({
        el: '#zone-container',
        tagName: 'div',

        initialize: function( options ) {
            this.zone = options.zone;
            this.record_type = options.record_type;

            this.model.set( 'url', '/api/zone/' + this.zone.get('id') );
        },

        events: {
            'click #save-record': 'editSoaRecord',
            'click #delete-record': 'deleteSoaRecord'
        },

        render: function( ) {
            this.$el.html( _.template( soaTmpl, this.model.toJSON() ) );
            return this;
        },

        // delete zone
        deleteSoaRecord: function() {
            var self = this;
            console.log('to delete zone: ', this.model);
            this.model.destroy({
                success: function( model, res ) {
                    console.log('deleted: ', model, res);
                },
                error: function( model, xhr, options ) {
                    console.log('delete error: ', model, xhr);
                }
            })
        },

        editSoaRecord: function() {
            console.log('to edit zone: ', this.model.get('id'));
            this.model.set({
            });
        }

    });

    Record.Views.ARecord = Record.Views.Record.extend({ 
        events: {
            'click .edit-a': 'setModalBody',
            'click #delete-record': 'deleteARecord',
            'click #edit-record': 'editARecord',
        },

        render: function() {
            this.$el.html( _.template( aRowTmpl, this.model.toJSON() ) );

            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$address = $('#address');
            this.$enable_ptr = $('#enable-ptr');

            return this;
        },

        setModalBody: function() {
            this.$zone_name.text( this.zone.get('name') );
            this.$record_name.text( this.record_type );
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$address.val( this.model.get('address') );

            var ptr = this.model.get('enable_ptr');
            ptr ? this.$enable_ptr.attr('checked', 'checked') : this.$enable_ptr.removeAttr('checked');
        },

        // delete zone
        deleteARecord: function() {
            var self = this;
            console.log('to delete A record: ', this.model);
            this.model.destroy({
                success: function( model, res ) {
                    console.log('deleted: ', model, res);
                },
                error: function( model, xhr, options ) {
                    console.log('delete error: ', model, xhr);
                }
            })
        },

        editARecord: function() {
            console.log('to edit A record: ', this.model.get('id'));
            this.model.set({});
        }
    });

    Record.Views.NsRecord = Record.Views.Record.extend({

        render: function() {
            this.$el.html( _.template( nsRowTmpl, this.model.toJSON() ) );

            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$name_server = $('#nsdname');

            return this;
        },

        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$name_server.val( this.model.get('nsdname') );
        }
    });

    Record.Views.CnameRecord = Record.Views.Record.extend({
        render: function() {
            this.$el.html( _.template( cnameRowTmpl, this.model.toJSON() ) );

            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$name_server = $('#cname');
            return this;
        },

        setModalBody: function() {
            this.$zone_name.text( this.zone.get('name') );
            this.$record_name.text( this.record_type );
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$name_server.val( this.model.get('cname') );
        }
    });

    Record.Views.MxRecord = Record.Views.Record.extend({
        render: function() {
            this.$el.html( _.template( mxRowTmpl, this.model.toJSON() ) );

            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$pref = $('#preference');
            this.$exchange = $('#exchange');
            return this;
        },

        setModalBody: function() {
            this.$zone_name.text( this.zone.get('name') );
            this.$record_name.text( this.record_type );
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$pref.val( this.model.get('preference') );
            this.$exchange.val( this.model.get('exchange') );
        }
    });

    Record.Views.TxtRecord = Record.Views.Record.extend({
        render: function() {
            this.$el.html( _.template( txtRowTmpl, this.model.toJSON() ) );
            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$txt = $('#txt-data');
            return this;
        },

        setModalBody: function() {
            this.$zone_name.text( this.zone.get('name') );
            this.$record_name.text( this.record_type );
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$txt.val( this.model.get('txt_data') );
        }
    });

    Record.Views.AaaaRecord = Record.Views.Record.extend({
        render: function() {
            this.$el.html( _.template( aaaaRowTmpl, this.model.toJSON() ) );

            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$address = $('#address');
            this.$enable_ptr = $('#enable-ptr');
            return this;
        },

        setModalBody: function() {
            this.$zone_name.text( this.zone.get('name') );
            this.$record_name.text( this.record_type );
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$address.val( this.model.get('address') );

            var ptr = this.model.get('enable_ptr');
            ptr ? this.$enable_ptr.attr('checked', 'checked') : this.$enable_ptr.removeAttr('checked');
        }
    });

    return Record;

});