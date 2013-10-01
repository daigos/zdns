define([
    'zdns',

    'modules/a_record',
    'modules/soa_record',
    'modules/ns_record',
    'modules/cname_record',
    'modules/mx_record',
    'modules/aaaa_record',
    'modules/txt_record',
    'modal'
], function( zdns, ARecord, SoaRecord, NsRecord, CnameRecord, MxRecord, AaaaRecord, TxtRecord ) {

    var Zone = zdns.module(); 

    Zone.Views.Layout = Backbone.View.extend({
        initialize: function( options ) {
            $('#record-nav').removeClass('composing');

            if( !options.zone_id ) {
                // navigate to default zone
                var zone_id = zdns.zone_list.first().get('id');
                zdns.router.navigate( 'zone/' + zone_id + '/soa', { trigger: true });
            }
        }
    });

    // Record view layout
    Zone.Views.RecordManager = Backbone.View.extend({

        el: '#zone-container', 

        events: {
            'click #show-new-record': 'showNewRecordModal'
        },

        loader: '<div id="zone-loader"><p class="msg">Loading...</p><p><i class="icon-spinner icon-spin"></i></p></div>',

        initialize: function( options ) {
            this.zone_id = options.id;
            this.record_type = options.record_type;

            if( !this.zone_id ) {
                var first_id = zdns.zone_list.first().get('id');
                zdns.router.navigate('zone/' + first_id + '/soa', { trigger: true });
            }

            if( !this.record_type ) {
                zdns.router.navigate('zone/' + this.zone_id + '/soa', { trigger: true });
            }

            this.$el.html( this.loader );
            this.zone = zdns.zone_list.get( this.zone_id );

        },

        render: function() {
            if( !this.zone ) {
                this.$el.html('Zone Not Found...');
                return false;
            }

            this.$show_new_record = $('#show-new-record');

            zdns.setZoneNav( this.zone.get('name'), this.record_type, this.zone.get('name') );
            this.toggleNewRecord();

            this.renderView();

            return this;
        },

        showNewRecordModal: function() {
            $('#modal-new-zone').text( this.zone.get('name') );
            $('#modal-new-record').text( this.record_type );
        },

        // Show or Hide "New Record" function
        toggleNewRecord: function( ) {
            if( this.record_type === 'soa' ) {
                this.$show_new_record.hide();
            } else {
                this.$show_new_record.show();
            }
        },

        subview: null,

        changeRecordView: function( view ) {
            if( null != this.subview ) {
                this.subview.undelegateEvents();
            }

            this.subview = new view({ zone_id: this.zone_id, zone: this.zone });
            this.$el.html( this.subview.render().el );
        },

        renderView: function() {
            var view = null;
            switch( this.record_type ) {
                case 'soa':
                    view = SoaRecord.Views.Layout;
                    break;

                case 'a':
                    view = ARecord.Views.Layout;
                    break;

                case 'ns':
                    view = NsRecord.Views.Layout;
                    break;

                case 'cname':
                    view = CnameRecord.Views.Layout;
                    break;

                case 'mx':
                    view = MxRecord.Views.Layout;
                    break;

                case 'aaaa':
                    view = AaaaRecord.Views.Layout;
                    break;

                case 'txt':
                    view = TxtRecord.Views.Layout;
                    break;
            }

            this.changeRecordView( view );

            return false;
        }
    });

    return Zone;

});