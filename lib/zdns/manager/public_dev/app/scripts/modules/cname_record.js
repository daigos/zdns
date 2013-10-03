define([
    'zdns',
    'modules/record',
    'text!templates/cname.html',
    'text!templates/cname_row.html'
], function( zdns, Record, tmpl, rowTmpl ) {

    var CnameRecord = zdns.module({ Models: {}, Collections: {} });

    CnameRecord.Views.Layout = Record.Views.Layout.extend({
        initialize: function( options ) {
            this._initialize( options );
            this.subview = CnameRecord.Views.Item;
        },

        render: function() {
            this.$el.html( tmpl );

            this.records.fetch({ reset: true });
            this.setElements();

            // new record's form items
            this.$new_name = this.$el.find('#new-name');
            this.$new_ttl = this.$el.find('#new-ttl');
            this.$new_cname = this.$el.find('#new-cname');

            // edit, delete record's form items
            this.$name = this.$el.find('#name');
            this.$ttl = this.$el.find('#ttl');
            this.$cname = this.$el.find('#cname');

            return this;
        },

        beforeEditRecord: function( ev ) {
            var m = this.checkTargetModel( $(ev.target).closest('.btn').data('modelid') ),
                attrs;

            attrs = {
                name:       this.$name.val(),
                ttl:        this.$ttl.val(),
                cname:    this.$cname.val(),
            };

            this.editRecord( m, attrs );
        },

        beforeCreateRecord: function( ev ) {
            this.createRecord({
                name:       this.$new_name.val(),
                ttl:        this.$new_ttl.val(),
                cname:    this.$new_cname.val(),
            });
        }
        
    });

    CnameRecord.Views.Item = Record.Views.Item.extend({
        render: function() {
            this.$el.html( _.template( rowTmpl, this.model.toJSON() ) );
            return this;
        },

        setElements: function() {

            // edit, delete record's form items
            this.$name = this.$edit_modal.find('#name');
            this.$ttl = this.$edit_modal.find('#ttl');
            this.$cname = this.$edit_modal.find('#cname');

        },

        // set Edit modal
        setModalBody: function() {
            this.$name.val( this.model.get('name') );
            this.$ttl.val( this.model.get('ttl') );
            this.$cname.val( this.model.get('cname') );
        }
    });

    return CnameRecord;

});