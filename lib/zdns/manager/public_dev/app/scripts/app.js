define([
    'jquery',
    'underscore',
    'backbone'
], function( $, _, Backbone ) {

    var app = {};

    app = _.extend(app, Backbone.Events);

    return _.extend(app, {
        // モジュールオブジェクトを初期化する
        module: function( options ) {
            return _.extend( { Views: {} }, options );
        }
    });

});