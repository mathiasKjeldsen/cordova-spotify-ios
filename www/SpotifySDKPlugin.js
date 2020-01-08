var exec = require('cordova/exec');

var PLUGIN_NAME = "SpotifySDKPlugin";

var SpotifySDKPlugin = function() {}

SpotifySDKPlugin.runAuth = function(clientId, redirectURL, onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "runAuth", [clientId, redirectURL]);
};

module.exports = SpotifySDKPlugin;