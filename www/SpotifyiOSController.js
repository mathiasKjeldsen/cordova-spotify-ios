var exec = require('cordova/exec');

var PLUGIN_NAME = "SpotifyiOSController";

var SpotifyiOSController = function() {}

SpotifyiOSController.execute = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "execute", []);
};

module.exports = SpotifyiOSController;