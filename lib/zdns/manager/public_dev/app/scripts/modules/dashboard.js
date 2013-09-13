define([
    'zdns'
], function( zdns ) {

    var Dashboard = zdns.module({
        Models: {},
        Collections: {}
    });

    // Composed zone model
    Dashboard.Models.Zone = Backbone.Model.extend({

    });

    // Composed zones collection
    Dashboard.Collections.ZoneList = Backbone.Collection.extend({
        url: '/api/zone',
        order: '',
        initialize: function( options ) {
            if(!options) { options = {}; }

            this.order = options.order || 'id'
        },
        comparator: function( zone ) {
            return zone.get( this.order );
        }
    });

    // application view
    Dashboard.Views.Layout = Backbone.View.extend({

        el: '#zdns',

        initialize: function() {
            this.$zone_list = $('#zone-list');
            this.$composit = $('#compose-zone');
            this.$zone = $('#zone-container');
            this.$order_menu = $('#order-menu');
            this.$record_nav = $('#record-nav nav');

            this.$current_zone = $('#current-zone-name');
            this.$current_record = $('#current-record-type');

            this.active_zone_name = '';
            this.active_record_type = 'soa';

            zdns.zone_list = new Dashboard.Collections.ZoneList();

            this.listenTo( zdns.zone_list, 'sync', this.renderZoneList );
            this.listenTo( zdns.zone_list, 'sort', this.renderZoneList );
            this.listenTo( zdns.zone_list, 'error', this.onErrorCreateZone );

            zdns.zone_list.fetch();
        },

        events: {
            'click #compose-zone': 'showCompose',
            'click #toggle-order-menu': 'toggleOrderMenu',
            'click #order-menu .menu-items div': 'doSort',
            'click #zone-list .zone a': 'onSelectZone',
            'click .record-type-btn': 'onSelectRecord'
        },

        showCompose: function() {
        },

        // Set selected record to active
        onSelectRecord: function( ev ) {
            var $t = $(ev.target).closest('.record-type-btn');

            _.each(this.$record_nav.find('.record-type-btn'), function( item ) {
                $(item).removeClass('active');
            });

            $t.addClass('active');

            console.log( zdns.router, this );
            zdns.router.navigate( 'zone/' + zdns.current_zone_id + '/' + $t.data('recordtype'), { trigger: true } );
        },

        // Set selected zone to active
        onSelectZone: function( ev ) {
            var $t = $(ev.target).closest('.zone');

            _.each(this.$zone_list.find('.zone'), function( item ) {
                $(item).removeClass('active');
            });

            $t.addClass('active');

            _.each(this.$record_nav.find('.record-type-btn'), function( item ) {
                $(item).removeClass('active');
            });

            $('#show-soa').addClass('active');
        },

        // Show/hide list menu
        toggleOrderMenu: function() {
            this.$order_menu.toggleClass('active');
        },

        // Sort Zone collection
        doSort: function( ev ) {
            zdns.zone_list.order = $(ev.target).data('order');
            this.toggleOrderMenu();

            zdns.zone_list.sort( zdns.zone_list.order );

            this.setOrderMenu();
        },

        // Mark current order
        setOrderMenu: function() {
            var order = zdns.zone_list.order,
                $items = this.$order_menu.find('.menu-item'),
                $item = null;

            _.each($items, function(item) {
                $item = $(item);
                $item.removeClass('active');
                if( $item.data('order') == order ) {
                    $item.addClass('active'); 
                }
            });
        },

        // Render zone list
        renderZoneList: function(ev) {
            var self = this,
                tmpl;

            if( !zdns.zone_list.length ) {
                return false;
            }

            tmpl = '<li class="zone" data-name="<%= name %>"><a href="#zone/<%= id %>/soa"><%= name %></a></li>';

            this.$zone_list.html('');

            zdns.zone_list.each(function( zone ) {
                self.$zone_list.append( _.template( tmpl, zone.toJSON() ) );
            });

            this.setOrderMenu();
        }

    });

    return Dashboard;

});