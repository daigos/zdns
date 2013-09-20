define([
    'jquery',
    'underscore',
    'backbone'
], function( $, _, Backbone ) {

    var zdns = { Models: {}, Collections: {} };

    zdns = _.extend(zdns, Backbone.Events);

    // record default data
    zdns.defaults = {
        soa: {
            name: "example.com.",
            ttl: 3600,
            mname: "ns.example.com.",
            rname: "root.example.com.",
            serial: (function(){
                var d = new Date();
                var y = d.getFullYear()*10000;
                var m = (d.getMonth()+1)*100;
                var d = d.getDate();
                return y+m+d+"";
            })(),
            refresh: "14400",
            retry: "3600",
            expire: "604800",
            minimum: "7200"
        },
        a: {
            name: "www",
            ttl: 3600,
            address: "192.168.1.80",
            enable_ptr: true
        },
        ns: {
            name: "@",
            ttl: 3600,
            nsdname: "ns"
        },
        cname: {
            name: "@",
            ttl: 3600,
            cname: "www.example.com."
        },
        mx: {
            name: "@",
            ttl: 3600,
            preference: 10,
            exchange: "mx.example.com."
        },
        txt: {
            name: "@",
            ttl: 3600,
            txt_data: "v=spf1 +ip4:192.168.1.25/32 -all"
        },
        aaaa: {
            name: "@",
            ttl: 3600,
            address: "2001:db8::80",
            enable_ptr: true
        }
    };

    return _.extend(zdns, {

        // Initialize module base object
        module: function( options ) {
            return _.extend( { Views: {} }, options );
        },

        setZoneNav: function( zoneName, recordType, externalLink ) {
            var $record_nav = $('.record-type-btn'),
                $soa = $('#show-soa'),
                $name = $('#current-zone-name'),
                $record = $('#current-record-type'),
                $link = $('#external-link');

            // set nav texts
            $name.text( zoneName );
            $record.text( recordType );

            if( !externalLink ) {
                $link.hide();
            } else {
                $link.show();
                $link.attr({
                    title: externalLink,
                    href: externalLink
                });
            }

            return true;
        },

    });

});