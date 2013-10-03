/*global define */
define([
    'zdns',
    'router',
    'modules/header',
    'modules/dashboard'
], function ( zdns, Router, Header, Dashboard ) {
    window.setTimeout(function() {
        $(window).scrollTop(0);
    }, 0);

    zdns.router = new Router();

    new Header.Views.Layout();
    // render layout
    new Dashboard.Views.Layout();

    Backbone.history.start();
});