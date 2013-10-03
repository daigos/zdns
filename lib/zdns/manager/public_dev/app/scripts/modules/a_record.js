define([
    'zdns',
    'modules/record',
    'text!templates/a.html',
    'text!templates/a_row.html'
], function( zdns, Record, tmpl, rowTmpl ) {

    var ARecord = zdns.module({ Models: {}, Collections: {} });

    ARecord.Views.Layout = Record.Views.Layout.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.subview = ARecord.Views.Item;
        },

        render: function() {
            this.$el.html( tmpl );

            this.records.fetch({ reset: true });
            this.setElements();

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

            return this;
        },

        beforeEditRecord: function( ev ) {
            var m = this.checkTargetModel( $(ev.target).closest('.btn').data('modelid') ),
                attrs;

            attrs = {
                name:       this.$name.val(),
                ttl:        this.$ttl.val(),
                address:    this.$address.val(),
                enable_ptr: this.$enable_ptr.is(':checked')
            };

            this.editRecord( m, attrs );

        },

        beforeCreateRecord: function( ev ) {
            this.createRecord({
                name:       this.$new_name.val(),
                ttl:        this.$new_ttl.val(),
                address:    this.$new_address.val(),
                enable_ptr: this.$new_enable_ptr.is(':checked')
            });
        }
        
    });

    ARecord.Views.Item = Record.Views.Item.extend({
        render: function() {
            this.$el.html( _.template( rowTmpl, this.model.toJSON() ) );

            return this;
        },

        setElements: function() {

            // edit, delete record's form items
            this.$name = this.$edit_modal.find('#name');
            this.$ttl = this.$edit_modal.find('#ttl');
            this.$address = this.$edit_modal.find('#address');
            this.$enable_ptr = this.$edit_modal.find('#enable-ptr');

        },

        // set Edit modal
        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$address.val( this.model.get('address') );
            this.model.get('enable_ptr') ? this.$enable_ptr.attr('checked', 'checked') :
                                           this.$enable_ptr.removeAttr('checked');
        }
    });

    return ARecord;

});