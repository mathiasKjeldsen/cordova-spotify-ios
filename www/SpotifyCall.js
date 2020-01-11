var exec = require('cordova/exec');

var SpotifyCall = function() {}

SpotifyCall.initialize = function(onSuccess, onError, options) {
    exec(onSuccess, onError, "SpotifyCall", "initialize", [options]);
};

SpotifyCall.doConnect = function(onSuccess, onError, options) {
    exec(onSuccess, onError, "SpotifyCall", "doConnect", [options]);
};

module.exports = SpotifyCall;