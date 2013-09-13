/*global define */
define([
    'zdns',
    'router',
    'modules/header',
    'modules/dashboard'
], function ( zdns, Router, Header, Dashboard ) {
    zdns.router = new Router();

    new Header.Views.Layout();
    // render layout
    new Dashboard.Views.Layout();

    Backbone.history.start();
});