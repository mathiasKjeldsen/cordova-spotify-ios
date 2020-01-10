var exec = require('cordova/exec');

var PLUGIN_NAME = "SpotifyiOS";

var SpotifyiOS = function() {}

SpotifyiOS.initialize = function(onSuccess, onError, options) {
    exec(onSuccess, onError, PLUGIN_NAME, "initialize", [options]);
};


module.exports = SpotifyiOS;