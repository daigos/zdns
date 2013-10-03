define([
    'zdns',
    'modules/record',
    'text!templates/txt.html',
    'text!templates/txt_row.html'
], function( zdns, Record, tmpl, rowTmpl ) {

    var TxtRecord = zdns.module({ Models: {}, Collections: {} });

    TxtRecord.Views.Layout = Record.Views.Layout.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.subview = TxtRecord.Views.Item;
        },

        render: function() {
            this.$el.html( tmpl );

            this.records.fetch({ reset: true });
            this.setElements();

            // new record's form items
            this.$new_name = this.$el.find('#new-name');
            this.$new_ttl = this.$el.find('#new-ttl');
            this.$new_txt_data = this.$el.find('#new-txt-data');

            // edit, delete record's form items
            this.$name = this.$el.find('#name');
            this.$ttl = this.$el.find('#ttl');
            this.$txt_data = this.$el.find('#txt-data');

            return this;
        },

        beforeEditRecord: function( ev ) {
            var m = this.checkTargetModel( $(ev.target).closest('.btn').data('modelid') ),
                attrs;

            attrs = {
                name:       this.$name.val(),
                ttl:        this.$ttl.val(),
                txt_data: this.$txt_data.val()
            };

            this.editRecord( m, attrs );
        },

        beforeCreateRecord: function( ev ) {
            this.createRecord({
                name:       this.$new_name.val(),
                ttl:        this.$new_ttl.val(),
                txt_data: this.$new_txt_data.val()
            });
        }
        
    });

    TxtRecord.Views.Item = Record.Views.Item.extend({
        render: function() {
            this.$el.html( _.template( rowTmpl, this.model.toJSON() ) );
            return this;
        },

        setElements: function() {

            // edit, delete record's form items
            this.$name = this.$edit_modal.find('#name');
            this.$ttl = this.$edit_modal.find('#ttl');
            this.$txt_data = this.$edit_modal.find('#txt-data');

        },

        // set Edit modal
        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$txt_data.val( this.model.get('txt_data') );
        }
    });

    return TxtRecord;

});