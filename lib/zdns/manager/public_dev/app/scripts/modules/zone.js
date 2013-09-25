define([
    'zdns',
    'modules/record',
    'text!templates/a.html',
    'text!templates/aaaa.html',
    'text!templates/cname.html',
    'text!templates/ns.html',
    'text!templates/mx.html',
    'text!templates/soa.html',
    'text!templates/txt.html'
], function( zdns, Record, aTmpl, aaaaTmpl, cnameTmpl, nsTmpl, mxTmpl, soaTmpl, txtTmpl ) {

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

            this.records = new Record.Collections.Records({
                zone_id: this.zone_id,
                record_type: this.record_type
            });

            this.listenTo( this.records, 'reset', this.renderRecords );
        },

        render: function() {

            // if no zone info
            if( !this.zone ) {
                // show not found
                this.$el.html('Zone Not Found...');
                return false;
            }

            zdns.setZoneNav( this.zone.get('name'), this.record_type, this.zone.get('name') );
            this.records.fetch({ reset: true });
            return this;
        },

        renderRecords: function() {
            var self = this,
                els = this.getViews( this.record_type ),
                $table;

            this.$el.html( els.container );
            $table = this.$el.find('#rows');

            this.records.each(function( model ) {
                $table.append( new els.View({ model: model }).render().el );
            });

            $('#zone-loader').remove();
        },

        getViews: function( record_type ) {
            var View = null,
                container = '';

            switch( record_type ) {
                case 'soa':
                    View = Record.Views.SoaRecord;
                    container = soaTmpl;
                break;

                case 'a':
                    View = Record.Views.ARecord;
                    container = aTmpl;
                break;

                case 'ns':
                    View = Record.Views.NsRecord;
                    container = nsTmpl;
                break;

                case 'cname':
                    View = Record.Views.CnameRecord;
                    container = cnameTmpl;
                break;

                case 'mx':
                    View = Record.Views.MxRecord;
                    container = mxTmpl;
                break;

                case 'txt':
                    View = Record.Views.TxtRecord;
                    container = txtTmpl;
                break;

                case 'aaaa':
                    View = Record.Views.AaaaRecord;
                    container = aaaaTmpl;
                break;

                default:
                    View = Record.Views.SoaRecord;
                    container = soaTmpl;

            }

            return {
                View: View,
                container: container
            };
        }


    });

    return Zone;

});