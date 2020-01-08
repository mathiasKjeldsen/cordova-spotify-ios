var exec = require('cordova/exec');

var PLUGIN_NAME = "SpotifySDKPlugin";

var SpotifySDKPlugin = function() {}

SpotifySDKPlugin.runAUth = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "runAuth", []);
};

module.exports = SpotifySDKPlugin;