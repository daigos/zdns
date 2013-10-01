define([
    'zdns',
    'text!templates/soa.html',
], function( zdns, tmpl ) {

    var SoaRecord = zdns.module();

    SoaRecord.Views.Layout = Backbone.View.extend({
        initialize: function( options ) {
            this.zone_id = options.zone_id;
            this.zone = zdns.zone_list.get( this.zone_id );

            this.$zone_name = $('#modal-zone');
            this.$record_name = $('#modal-record');

            this.listenTo( this.zone, 'change', this.render );
        },

        events: {
            'click #delete-record': 'deleteRecord',
            'click #edit-record': 'editRecord'
        },

        render: function() {
            this.$el.html( _.template( tmpl, this.zone.toJSON() ) );
            return this;
        },

        setModalBody: function() {
            this.$zone_name.text( this.zone.get('name') );
            this.$record_name.text( this.record_type );

            var ptr = this.model.get('enable_ptr');
            ptr ? this.$enable_ptr.attr('checked', 'checked') : this.$enable_ptr.removeAttr('checked');
        },

        // delete zone
        deleteRecord: function() {
            var self = this,
                msg = '';

            this.zone.destroy({
                success: function( model, res ) {
                    console.log('deleted success: ', model, res);
                    msg = '<p class="alert-green"><i class="icon-info-sign"><i>&nbsp;' + model.get('name') + ' was successfully deleted.' + '</p>';

                    self.$el.html(msg);
                    $('.modal-bg').remove();
                },
                error: function( model, xhr, options ) {
                    console.log('delete error: ', model, xhr);
                    msg = '<p class="alert-red"><i class="icon-warning-sign"><i>&nbsp;Failed to delete ' + model.get('name') + '</p>';
                    self.$el.html(msg);
                    $('.modal-bg').remove();
                }
            })
        },

        editRecord: function() {
            this.zone.save({
                name: $('#name').val(),
                ttl: $('#ttl').val(),
                mname: $('#mname').val(),
                rname: $('#rname').val(),
                serial: $('#serial').val(),
                refresh: $('#refresh').val(),
                retry: $('#retry').val(),
                expire: $('#expire').val(),
                minimum: $('#minimum').val(),
            }, {
                success: function( model, res ) {
                    console.log('success edit', model, res);
                    $('#msg').html( '<p class="alert-green"><i class="icon-info-sign"><i>&nbsp;' + model.get('name') + ' was successfully changed.' + '</p>' );
                    $('.modal-bg').remove();
                },
                error: function( model, xhr, options ) {
                    console.log('success edit', model, xhr);
                    $('#msg').html( '<p class="alert-red"><i class="icon-warning-sign"><i>&nbsp;Failed to edit ' + model.get('name') + '</p>' );
                    $('.modal-bg').remove();
                }
            });
        }
    });

    return SoaRecord;

});