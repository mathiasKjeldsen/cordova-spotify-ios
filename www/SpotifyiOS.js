var exec = require('cordova/exec');

var PLUGIN_NAME = "SpotifyiOS";

var SpotifyiOS = function() {}

SpotifyiOS.runAuth = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "runAuth", []);
};

module.exports = SpotifyiOS;