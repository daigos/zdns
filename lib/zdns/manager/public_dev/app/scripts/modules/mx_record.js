define([
    'zdns',
    'modules/record',
    'text!templates/mx.html',
    'text!templates/mx_row.html'
], function( zdns, Record, tmpl, rowTmpl ) {

    var MxRecord = zdns.module({ Models: {}, Collections: {} });

    MxRecord.Views.Layout = Record.Views.Layout.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.subview = MxRecord.Views.Item;
        },

        render: function() {
            this.$el.html( tmpl );

            this.records.fetch({ reset: true });
            this.setElements();

            // new record's form items
            this.$new_name = this.$el.find('#new-name');
            this.$new_ttl = this.$el.find('#new-ttl');
            this.$new_preference = this.$el.find('#new-preference');
            this.$new_exchange = this.$el.find('#new-exchange');

            // edit, delete record's form items
            this.$name = this.$el.find('#name');
            this.$ttl = this.$el.find('#ttl');
            this.$preference = this.$el.find('#preference');
            this.$exchange = this.$el.find('#exchange');

            return this;
        },

        beforeEditRecord: function( ev ) {
            var m = this.checkTargetModel( $(ev.target).closest('.btn').data('modelid') ),
                attrs;

            attrs = {
                name:       this.$name.val(),
                ttl:        this.$ttl.val(),
                preference: this.$preference.val(),
                exchange:   this.$exchange.val()
            };

            this.editRecord( m, attrs );
        },

        beforeCreateRecord: function( ev ) {
            this.createRecord({
                name:       this.$new_name.val(),
                ttl:        this.$new_ttl.val(),
                preference: this.$new_preference.val(),
                exchange:   this.$new_exchange.val()
            });
        }
        
    });

    MxRecord.Views.Item = Record.Views.Item.extend({
        render: function() {
            this.$el.html( _.template( rowTmpl, this.model.toJSON() ) );
            return this;
        },

        setElements: function() {

            // edit, delete record's form items
            this.$name = this.$edit_modal.find('#name');
            this.$ttl = this.$edit_modal.find('#ttl');
            this.$preference = this.$edit_modal.find('#preference');
            this.$exchange = this.$edit_modal.find('#exchange');

        },

        // set Edit modal
        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$preference.val( this.model.get('preference') );
            this.$exchange.val( this.model.get('exchange') );
        }
    });

    return MxRecord;

});