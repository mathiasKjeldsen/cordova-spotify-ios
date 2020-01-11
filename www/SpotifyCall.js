var exec = require('cordova/exec');

var SpotifyCall = function() {}

/**
 * Initialize a session in the Spotify App
 * 
 * @param {function} onSuccess Function to call when a session has been initialized. Authorization token is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 * 
 *  @param {object} options Options to use for initialization:
 * * clientId: string
 * * redirectURL: string
 * * tokenExhangeURL: string
 * * tokenRefreshURL: string
 */

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

SpotifyCall.resume = function(onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "resume", []);
};

SpotifyCall.getPlayerState = function(onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "getPlayerState", []);
};

module.exports = SpotifyCall;