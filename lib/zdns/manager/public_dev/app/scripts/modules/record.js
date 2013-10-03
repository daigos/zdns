//
//  Record Base Module
//
define([
    'zdns'
], function( zdns ) {

    var Record = zdns.module({ Models: {}, Collections: {} });

    Record.Models.Record = Backbone.Model.extend();

    Record.Collections.Records = Backbone.Collection.extend({
        model: Record.Models.Record,
        initialize: function( options ) {
            this.url = '/api/zone/' + options.zone_id + '/' + options.type;
        }
    });

    //
    // Record's Layout
    //
    Record.Views.Layout = Backbone.View.extend({
        _initialize: function( options ) {
            this.zone_id = options.zone_id;
            this.zone = options.zone;
            this.record_type = options.record_type;

            this.records = new Record.Collections.Records({ zone_id: this.zone_id, type: this.record_type });

            this.listenTo( this.records, 'reset', this.addAll );    // fetch records
            this.listenTo( this.records, 'change', this.addAll );    // fetch records
            this.listenTo( this.records, 'add', this.addOne );      // new record
            this.listenTo( this.records, 'destroy', this.addAll );  // remove record

        },

        events: {
            'click #delete-record': 'beforeDeleteRecord',
            'click #save-record':   'beforeEditRecord',
            'click #create-record': 'beforeCreateRecord'
        },

        render: function() {
            /* cache form elements */
            return this;
        },

        // set New, Edit Record modal
        setElements: function() {
            // cache common elements
            // ----
            this.$rows = this.$el.find('#rows');
            this.$msg = this.$el.find('#msg');

            // modals
            this.$new_modal = $('#modal-new-record');
            this.$edit_modal = $('#modal-edit-record');

            this.$el.find('.modal-zone').text( this.zone.get('name') );
        },

        addOne: function( model ) {
            var $n = this.$rows.find('no-records')
            if( $n.length ) { $n.remove(); }
            var view = new this.subview({ model: model });
            this.$rows.append( view.render().el );
        },

        addAll: function() {
            console.log('add all: ', this.records);

            if( !this.records.length ) {
                this.$rows.html('<tr class="no-records"><td colspan="5">No Records.</td></tr>');
                return false;
            }

            this.$rows.html('');
            this.records.each( this.addOne, this );
        },

        checkTargetModel: function( id ) {
            var self = this,
                m = null;

            if( !id ) {
                console.log('cant get model id: ', id);
                return false;
            }

            m = this.records.get( id );

            if( !m ) {
                console.log('cant get model by id:', id, this.records);
                return false;
            }

            return m;
        },

        beforeDeleteRecord: function( ev ) {
            var m = this.checkTargetModel( $(ev.target).closest('.btn').data('modelid') );
            if(!m) { return false; }

            this.deleteRecord( m );
        },

        deleteRecord: function( m ) {
            var self = this;
            m.destroy(
                {
                    wait: true,
                    success: function( model, res ) {
                        console.log('deleted: ', model, res);
                        self.$msg.html('<p class="alert-green">' +
                            '<i class="icon-info-sign"></i>' +
                            '&nbsp;Record was successfully deleted.</p>');
                        self.closeEditRecordModal();

                    },
                    error: function( model, error ) {
                        console.log('delete error: ', model, error);
                        var msg = self.parseError( error.responseText );
                        $('#edit-record-err').html('<p class="alert-red">' +
                            '<i class="icon-warning-sign"></i>' +
                            '&nbsp;' + msg + '</p>');
                    }
                }
            );
        },

        beforeEditRecord: function( ev ) {
            var m = this.checkTargetModel( $(ev.target).closest('.btn').data('modelid') );
            /* this.editRecord( m, attrs ); */
        },

        editRecord: function( m, attrs ) {
            var self = this;

            m.save(

                attrs,

                {
                    wait: true,
                    success: function(res) {
                        console.log('record saved: ', res);
                        self.$msg.html('<p class="alert-green">' +
                            '<i class="icon-info-sign"></i>' +
                            '&nbsp;Record was successfully changed.</p>');
                        self.closeEditRecordModal();
                    },
                    error: function( model, error ) {
                        console.log( 'record error: ', model, error );
                        var msg = self.parseError( error.responseText );
                        $('#new-record-err').html('<p class="alert-red">' +
                            '<i class="icon-warning-sign"></i>' +
                            '&nbsp;' + msg + '</p>');
                    }
                }
            );
        },

        beforeCreateRecord: function( ev ) {
            /* override here */
        },

        createRecord: function( attrs ) {
            var self = this;

            console.log('to create: ', attrs);

            this.records.create(

                attrs,

                {
                    wait: true,
                    success: function(res) {
                        console.log('record created: ', res);
                        self.$msg.html('<p class="alert-green">' +
                            '<i class="icon-info-sign"></i>' +
                            '&nbsp;Record was successfully created.</p>');
                        self.closeNewRecordModal();
                    },
                    error: function( model, error ) {
                        console.log( 'record error: ', model, error );
                        var msg = self.parseError( error.responseText );
                        $('#new-record-err').html('<p class="alert-red">' +
                            '<i class="icon-warning-sign"></i>' +
                            '&nbsp;' + msg + '</p>');
                    }
                }
            );
        },

        parseError: function( text ) {
            var obj,
                msg = '';
            try {
                obj = JSON.parse( text );
                msg = obj.message;
            } catch( e ) {
                console.log(e);
            }

            return msg;
        },

        closeNewRecordModal: function() {
            $('#modal-new-record').removeClass('active');
            $('.modal-bg').remove();
        },

        closeEditRecordModal: function() {
            $('#modal-edit-record').removeClass('active');
            $('.modal-bg').remove();
        }
    });

    //
    // View for each record
    //
    Record.Views.Item = Backbone.View.extend({
        tagName: 'tr',

        initialize: function( options ) {
            this.$edit_modal = $('#modal-edit-record');

            this.$edit_modal.find('#save-record').attr('data-modelid', this.model.get('id'));
            this.$edit_modal.find('#delete-record').attr('data-modelid', this.model.get('id'));

            this.setElements();
        },

        events: {
            'click .show-edit': 'setModalBody'
        },

        render: function() {
            /* override
            this.$el.html( _.template( this.tmpl, this.model.toJSON() ) );
            return this;
            */
        },

        setElements: function() {
            // cache edit, delete record's form items
        },

        setModalBody: function() {
            // set default inputs
        }
    });

    return Record;

});