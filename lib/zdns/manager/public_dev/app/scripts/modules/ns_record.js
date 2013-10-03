define([
    'zdns',
    'modules/record',
    'text!templates/ns.html',
    'text!templates/ns_row.html'
], function( zdns, Record, tmpl, rowTmpl ) {

    var NsRecord = zdns.module({ Models: {}, Collections: {} });

    NsRecord.Views.Layout = Record.Views.Layout.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.subview = NsRecord.Views.Item;
        },

        render: function() {
            this.$el.html( tmpl );

            this.records.fetch({ reset: true });
            this.setElements();

            // new record's form items
            this.$new_name = this.$el.find('#new-name');
            this.$new_ttl = this.$el.find('#new-ttl');
            this.$new_nsdname = this.$el.find('#new-nsdname');

            // edit, delete record's form items
            this.$name = this.$el.find('#name');
            this.$ttl = this.$el.find('#ttl');
            this.$nsdname = this.$el.find('#nsdname');

            return this;
        },

        beforeEditRecord: function( ev ) {
            var m = this.checkTargetModel( $(ev.target).closest('.btn').data('modelid') ),
                attrs;

            attrs = {
                name:       this.$name.val(),
                ttl:        this.$ttl.val(),
                nsdname:    this.$nsdname.val()
            };

            this.editRecord( m, attrs );
        },

        beforeCreateRecord: function( ev ) {
            this.createRecord({
                name:       this.$new_name.val(),
                ttl:        this.$new_ttl.val(),
                nsdname:    this.$new_nsdname.val()
            });
        }

    });

    NsRecord.Views.Item = Record.Views.Item.extend({

        render: function() {
            this.$el.html( _.template( rowTmpl, this.model.toJSON() ) );
            return this;
        },

        setElements: function() {

            // edit, delete record's form items
            this.$name = this.$edit_modal.find('#name');
            this.$ttl = this.$edit_modal.find('#ttl');
            this.$nsdname = this.$edit_modal.find('#nsdname');

        },

        // set Edit modal
        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$nsdname.val( this.model.get('nsdname') );
        }
    });

    return NsRecord;

});