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

            this.zone = new zdns.Models.Zone();
            this.listenTo( this.zone, 'invalid', this.onErrorCreateZone );
        },

        render: function() {
            this.$el.html( layoutTmpl );

            $('#show-new-record').hide();

            this.getElements();
            this.setDefaults();

            return this;
        },

        onErrorCreateZone: function( model, errors ) {
            this.$save.removeAttr('disabled')
                .text('Save');

            this.showError( errors );
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

        showError: function( msg ) {
            if( _.isArray( msg ) ) {
                msg = _.map( msg, function( v ) {
                    return '<i class="icon-warning-sign"></i>&nbsp;' + v;
                }).join('<br />');
            } else {
                msg = '<i class="icon-warning-sign"></i>&nbsp;' + msg;
            }

            this.$alert
                .removeClass('alert-green')
                .addClass('alert-red')
                .find('#msg')
                .html( msg )
                .end()
                .show();
        },

        saveZone: function() {
            var self = this;

            this.$save
                .html('<i class="icon-spin icon-spinner"></i>')
                .attr('disabled', 'disabled');

            this.zone.save(

                {
                    name: this.$name.val(),
                    ttl: parseInt( this.$ttl.val() ),
                    mname: this.$mname.val(),
                    rname: this.$rname.val(),
                    serial: parseInt( this.$serial.val() ),
                    refresh: parseInt( this.$refresh.val() ),
                    retry: parseInt( this.$retry.val() ),
                    expire: parseInt( this.$expire.val() ) ,
                    minimum: parseInt( this.$minimum.val() )
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

                            zdns.zone_list.add( self.zone );
                    },
                    error: function( model, error ) {
                        console.log( model, error );
                        self.$save.removeAttr('disabled')
                            .text('Save');

                        var msg = zdns.parseError(error.responseText);

                        self.showError( msg );
                    }
                }
            );

            return true;
        }

    });

    return Compose;

});