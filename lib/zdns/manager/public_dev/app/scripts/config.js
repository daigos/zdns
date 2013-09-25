require.config({
    deps: ['main'],
    paths: {
        templates: '../templates',

        jquery: '../bower_components/jquery/jquery',
        underscore: '../bower_components/underscore/underscore',
        backbone: '../bower_components/backbone/backbone',
        text: '../bower_components/requirejs-text/text',
        modal: 'vendor/modals'
    },
    shim: {
        modal: {
            deps: ['jquery']
        },

        underscore: {
            exports: '_'
        },

        backbone: {
            deps: ['underscore', 'jquery'],
            exports: 'Backbone'
        }
    }
});
