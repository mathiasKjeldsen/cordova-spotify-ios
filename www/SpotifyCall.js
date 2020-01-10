var exec = require('cordova/exec');

var SpotifyCall = function() {}

SpotifyCall.initialize = function(onSuccess, onError, options) {
    exec(onSuccess, onError, "SpotifyCall", "initialize", [options]);
};

module.exports = SpotifyCall;