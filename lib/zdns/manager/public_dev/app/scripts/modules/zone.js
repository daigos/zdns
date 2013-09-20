define([
    'zdns',
    'text!templates/a.html',
    'text!templates/a_row.html',
    'text!templates/aaaa.html',
    'text!templates/aaaa_row.html',
    'text!templates/cname.html',
    'text!templates/cname_row.html',
    'text!templates/mx.html',
    'text!templates/mx_row.html',
    'text!templates/ns.html',
    'text!templates/ns_row.html',
    'text!templates/soa.html',
    'text!templates/txt.html',
    'text!templates/txt_row.html'
], function( zdns, aTmpl, aRowTmpl, aaaaTmpl, aaaaRowTmpl, cnameTmpl, cnameRowTmpl,
    mxTmpl, mxRowTmpl, nsTmpl, nsRowTmpl, soaTmpl, txtTmpl, txtRowTmpl ) {

    var Zone = zdns.module({ Collections: {}, Models: {} });

    Zone.Models.Record = Backbone.Model.extend({});

    Zone.Collections.Records = Backbone.Collection.extend({
        urlRoot: '/api/zone/',
        model: Zone.Models.Record,
        initialize: function( options ) {
            this.url = this.urlRoot + options.zone_id + '/' + options.type;
        }
    });

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

    Zone.Views.Record = Backbone.View.extend({

        el: '#zone-container',

        loader: '<div id="zone-loader"><p class="msg">Loading...</p><p><i class="icon-spinner icon-spin"></i></p></div>',

        initialize: function( options ) {
            this.zone_id = options.id;
            this.record_type = options.record_type;

            this.$el.html( this.loader );

            this.zone = zdns.zone_list.get( this.zone_id );

            this.records = new Zone.Collections.Records({
                zone_id: this.zone_id,
                type: this.record_type
            });

            this.listenTo( this.records, 'reset', this.renderRecords );
        },

        render: function() {
            this.setZoneNav();
            this.records.fetch({ reset: true });
            return this;
        },

        setZoneNav: function() {
            zdns.setZoneNav(
                this.zone.get('name'),
                this.record_type,
                this.zone.get('name') );

            return true;
        },

        renderRecords: function(ev) {
            var res = this.getTemplate();

            this.$el.html( res.base_tmpl );

            if( !_.isNull( res.callback ) ) {
                res.callback.call(this, res.selector, res.row_tmpl );
            }
        },

        renderRecord: function( container_selector, template ) {
            var $container = $(container_selector);

            this.records.each(function(item) {
                $container.append( _.template( template, item.toJSON() ) );
            });
        },

        getTemplate: function() {
            var base_tmpl = '',
                row_templ = '',
                selector = '',
                callback = this.renderRecord;

            switch( this.record_type ) {
                case 'a':
                    base_tmpl = _.template( aTmpl );
                    selector = '#a-records';
                    row_tmpl = aRowTmpl;
                break;

                case 'aaaa':
                    base_tmpl = aaaaTmpl;
                    selector = '#aaaa-records';
                    row_tmpl = aaaaRowTmpl;
                break;
                
                case 'cname':
                    base_tmpl = cnameTmpl;
                    selector = '#cname-records';
                    row_tmpl = cnameRowTmpl;
                break;
                
                case 'mx':
                    base_tmpl = mxTmpl;
                    selector = '#mx-records';
                    row_tmpl = mxRowTmpl;
                break;
                
                case 'ns':
                    base_tmpl = nsTmpl;
                    selector = '#ns-records';
                    row_tmpl = nsRowTmpl;
                break;
                
                case 'soa':
                    base_tmpl = _.template( soaTmpl, this.records.first().toJSON() );
                    callback = null;
                break;
                
                case 'txt':
                    base_tmpl = txtTmpl;
                    selector = '#txt-records';
                    row_tmpl = txtRowTmpl;
                break;
            }

            return {
                base_tmpl: base_tmpl,
                row_tmpl: row_tmpl,
                selector: selector,
                callback: callback
            };
        }
    });

    return Zone;

});