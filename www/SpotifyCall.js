var exec = require('cordova/exec');

var SpotifyCall = function() {}

SpotifyCall.initialize = function(onSuccess, onError, options) {
    exec(onSuccess, onError, "SpotifyCall", "initialize", [options]);
};

SpotifyCall.doConnect = function(onSuccess, onError, options) {
    exec(onSuccess, onError, "SpotifyCall", "doConnect", [options]);
};

SpotifyCall.getToken = function(onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "getToken", []);
};

module.exports = SpotifyCall;