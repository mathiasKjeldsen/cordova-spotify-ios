var exec = require('cordova/exec');

var PLUGIN_NAME = "SpotifyCall";

var SpotifyCall = function() {}

SpotifyCall.initialize = function(onSuccess, onError, options) {
    exec(onSuccess, onError, PLUGIN_NAME, "initialize", [options]);
};


module.exports = SpotifyCall;