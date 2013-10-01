define([
    'zdns',
    'text!templates/ns.html',
    'text!templates/ns_row.html'
], function( zdns, tmpl, rowTmpl ) {

    var NsRecord = zdns.module({ Models: {}, Collections: {} });

    NsRecord.Models.Record = Backbone.Model.extend();

    NsRecord.Collections.Records = Backbone.Collection.extend({
        model: NsRecord.Models.Record,
        initialize: function( options ) {
            this.zone_id = options.zone_id;
            this.url = '/api/zone/' + options.zone_id + '/ns';
        }
    });

    NsRecord.Views.Layout = Backbone.View.extend({
        initialize: function( options ) {
            this.zone_id = options.zone_id;
            this.zone = options.zone;

            this.records = new NsRecord.Collections.Records({
                zone_id: this.zone_id
            });

            this.$el.html( tmpl );

            this.listenTo( this.records, 'reset', this.addAll );
            this.listenTo( this.records, 'add', this.addOne );
            this.records.fetch({ reset: true });
        },

        events: {
            'click #delete-record': 'deleteRecord',
            'click #edit-record': 'editRecord',
            'click #create-record': 'createRecord'
        },

        render: function() {
            this.$rows = this.$el.find('#rows');
            this.$zone_names = this.$el.find('.modal-zone');
            this.$msg = this.$el.find('#msg');

            // new record's form items
            this.$new_name = this.$el.find('#new-name');
            this.$new_ttl = this.$el.find('#new-ttl');
            this.$new_address = this.$el.find('#new-address');
            this.$new_enable_ptr = this.$el.find('#new-enable-ptr');

            // edit, delete record's form items
            this.$name = this.$el.find('#name');
            this.$ttl = this.$el.find('#ttl');
            this.$address = this.$el.find('#address');
            this.$enable_ptr = this.$el.find('#enable-ptr');

            this.setModalHeader();

            return this;
        },

        // set New, Edit Record modal
        setModalHeader: function() {
            this.$zone_names.text( this.zone.get('name') );
        },

        // set Edit, Delete modal
        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$address.val( this.model.get('address') );

            var ptr = this.model.get('enable_ptr');
            ptr ? this.$enable_ptr.attr('checked', 'checked') : this.$enable_ptr.removeAttr('checked');
        },

        addOne: function( model ) {
            var view = new NsRecord.Views.Item({ model: model });
            this.$rows.append( view.render().el );
        },

        addAll: function() {
            console.log('add all: ', this.records);
            if( !this.records.length ) {
                this.$rows.html('<tr><td colspan="5" class="no-records">No Records.</td></tr>');

                return false;
            }

            this.$rows.html('');
            this.records.each( this.addOne, this );
        },

        // delete zone
        deleteRecord: function() {
            var self = this;
            console.log('to delete A record: ', this.model);
            this.model.destroy({
                success: function( model, res ) {
                    console.log('deleted: ', model, res);
                },
                error: function( model, xhr, options ) {
                    console.log('delete error: ', model, xhr);
                }
            });
        },

        editRecord: function() {
            console.log('to edit A record: ', this.model.get('id'));
            this.model.set({});
        },

        createRecord: function() {
            var self = this;
            console.log('to create', {
                name: self.$new_name.val(),
                ttl: self.$new_ttl.val(),
                address: self.$new_address.val(),
                enable_ptr: self.$new_enable_ptr.is(':checked')
            });

            this.records.create(
                {
                    name: self.$new_name.val(),
                    ttl: self.$new_ttl.val(),
                    address: self.$new_address.val(),
                    enable_ptr: self.$new_enable_ptr.is(':checked')
                },
                {
                    success: function(res) {
                        console.log('record created: ', res);
                        self.$msg.html('<p class="alert-green"><i class="icon-info-sign"></i>&nbsp;Record was successfully created.</p>');
                    },
                    error: function( model, error ) {
                        console.log( model, error );
                        self.$msg.html('<p class="alert-red"><i class="icon-warning-sign"></i>&nbsp;Failed to create a record.</p>');
                    }
                }
            );
        }
    });

    NsRecord.Views.Item = Backbone.View.extend({
        tagName: 'tr',

        events: {
            'click .edit-a': 'setModalBody'
        },

        render: function() {
            this.$el.html( _.template( rowTmpl, this.model.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            console.log('setModalBody');
        }  
    });

    return NsRecord;

});