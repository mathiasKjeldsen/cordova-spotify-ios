var exec = require('cordova/exec');

var SpotifyCall = function() {}

SpotifyCall.initialize = function(onSuccess, onError, options) {
    exec(onSuccess, onError, "SpotifyCall", "initialize", [options]);
};

SpotifyCall.doConnect = function(onSuccess, onError, token, playuri) {
    exec(onSuccess, onError, "SpotifyCall", "doConnect", [token, playuri]);
};

SpotifyCall.getToken = function(onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "getToken", []);
};

SpotifyCall.playURI = function(onSuccess, onError, playuri) {
    exec(onSuccess, onError, "SpotifyCall", "playURI", [playuri]);
};

SpotifyCall.pause = function(onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "pause", []);
};

module.exports = SpotifyCall;