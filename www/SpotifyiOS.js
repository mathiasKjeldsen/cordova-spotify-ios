var exec = require('cordova/exec');

var PLUGIN_NAME = "SpotifyiOS";

var SpotifyiOS = function() {}

SpotifyiOS.initialize = function(onSuccess, onError, clientID) {
    exec(onSuccess, onError, PLUGIN_NAME, "initialize", [clientID]);
};


module.exports = SpotifyiOS;