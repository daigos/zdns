define([
    'zdns',
    'text!templates/compose.html'
], function( zdns, layoutTmpl ) {

    var Compose = zdns.module();

    Compose.Views.Layout = Backbone.View.extend({

        el: '#zone-container',

        events: {
            'click #save-zone': 'saveZone'
        },

        initialize: function() {
            zdns.setZoneNav( 'Compose Zone', 'SOA' );
            $('#zone-list .zone.active').removeClass('active');
            $('#record-nav').addClass('composing');
        },

        render: function() {
            this.$el.html( layoutTmpl );

            this.getElements();
            this.setDefaults();

            return this;
        },

        getElements: function() {
            this.$name = $('#name');
            this.$ttl = $('#ttl');
            this.$mname = $('#pname');
            this.$rname = $('#resp');
            this.$serial = $('#serial');
            this.$refresh = $('#ref');
            this.$retry = $('#ret');
            this.$expire = $('#exp');
            this.$minimum = $('#minttl');

            this.$save = $('#save-zone');
            this.$alert = $('#alert-wrap');

            return true;
        },

        setDefaults: function() {
            var def = zdns.defaults.soa;
            
            this.$name.val( def.name );
            this.$ttl.val( def.ttl );
            this.$mname.val( def.mname );
            this.$rname.val( def.rname );
            this.$serial.val( def.serial );
            this.$refresh.val( def.refresh );
            this.$retry.val( def.retry );
            this.$expire.val( def.expire );
            this.$minimum.val( def.minimum );

            return true;
        },

        onSaveError: function( model, error ) {
            console.log( model, error );
        },

        saveZone: function() {
            var self = this;

            this.$save
                .html('<i class="icon-spin icon-spinner"></i>')
                .attr('disabled', 'disabled');

            zdns.zone_list.create(
                {
                    expire: parseInt( this.$expire.val() ) ,
                    minimum: parseInt( this.$minimum.val() ),
                    mname: this.$mname.val(),
                    name: this.$name.val(),
                    refresh: parseInt( this.$refresh.val() ),
                    retry: parseInt( this.$retry.val() ),
                    rname: this.$rname.val(),
                    serial: parseInt( this.$serial.val() ),
                    ttl: parseInt( this.$ttl.val() )
                },
                {
                    wait: true,
                    success: function(res) {
                        console.log('zone created: ', res);
                        self.$save.removeAttr('disabled')
                            .text('Save');

                        self.$alert
                            .removeClass('alert-red')
                            .addClass('alert-green')
                            .find('#msg')
                            .html('<i class="icon-ok"></i>&nbsp;Composed.')
                            .end()
                            .show();
                    },
                    error: function( model, error ) {
                        console.log( model, error );
                        self.$save.removeAttr('disabled')
                            .text('Save');

                        self.$alert
                            .removeClass('alert-green')
                            .addClass('alert-red')
                            .find('#msg')
                            .html('<i class="icon-warning-sign"></i>&nbsp;' + "Can't compose zone.")
                            .end()
                            .show();
                    }
                }
            );

            return true;
        }

    });

    return Compose;

});