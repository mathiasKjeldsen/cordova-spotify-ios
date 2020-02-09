var exec = require('cordova/exec');

var SpotifyCall = function () { }

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

SpotifyCall.initialize = function (onSuccess, onError, options) {
    exec(onSuccess, onError, "SpotifyCall", "initialize", [options]);
};

/**
 * Check if the Spotify App is installed on the device
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Boolean returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 */

SpotifyCall.isSpotifyAppInstalled = function (onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "isSpotifyAppInstalled", []);
};

/**
 * Check if the Spotify AppRemote is connected
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Boolean returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 */

SpotifyCall.isSpotifyAppInstalled = function (onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "isAppRemoteConnected", []);
};


/**
 * If a session has been initiated and the user requests to play a track - the Spotify app must be woken using authorizeAndPlay.
 * This function wakes up the Spotify app and starts playing the requests URI. 
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Event is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 * 
 * @param {string} accessToken AccessToken returned by initialize function.
 * @param {string} playURI URI of the requested track.
 */

SpotifyCall.doConnect = function (onSuccess, onError, token, playURI) {
    exec(onSuccess, onError, "SpotifyCall", "doConnect", [token, playURI]);
};

/**
 * Function that returns the accessToken for the current session.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. AccessToken is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 */

SpotifyCall.getToken = function (onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "getToken", []);
};

/**
 * Function that starts playing a track in the Spotify app.
 * If appRemote is not connected - this will happen first.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Event is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 * @param {string} playURI URI of the requested track.
 */

SpotifyCall.playURI = function (onSuccess, onError, playuri) {
    exec(onSuccess, onError, "SpotifyCall", "playURI", [playuri]);
};

/**
 * Function that queues a track in the Spotify app.
 * If appRemote is not connected - this will happen first.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Event is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 * @param {string} playURI URI of the requested track.
 */

SpotifyCall.queueURI = function (onSuccess, onError, playuri) {
    exec(onSuccess, onError, "SpotifyCall", "queueURI", [playuri]);
};

/**
 * Function that starts playing a playlist at a given index by a URI.
 * If appRemote is not connected - this will happen first.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Event is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 * @param {string} playURI URI of the requested playlist.
 * @param {string} index Index of the desired track in the playlist.

 */

SpotifyCall.playPlaylistByUriAndIndex = function (onSuccess, onError, playuri, index) {
    exec(onSuccess, onError, "SpotifyCall", "playPlaylist", [playuri, index]);
};

/**
 * Function that pauses the currently playing track in the Spotify app.
 * If appRemote is not connected - this will happen first.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Event is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 */

SpotifyCall.pause = function (onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "pause", []);
};

/**
 * Function that resumes the currently loaded track in the Spotify app.
 * If appRemote is not connected - this will happen first.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Event is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 */

SpotifyCall.resume = function (onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "resume", []);
};

/**
 * Function that seeks to the provided position of the currently playing track in the Spotify app.
 * If appRemote is not connected - this will happen first.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. Event is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 * @param {number} position Target position in milliseconds
 */

SpotifyCall.seek = function (onSuccess, onError, position) {
    exec(onSuccess, onError, "SpotifyCall", "seek", [position]);
};

/**
 * Function that returns the Spotify app's current playerState.
 * If appRemote is not connected - this will happen first.
 *
 * @param {function} onSuccess Function to call when a session has been initialized. playerState object is returned.
 * @param {function} onError Function to call if a session could not be initialized. Error description is returned.
 */

SpotifyCall.getPlayerState = function (onSuccess, onError) {
    exec(onSuccess, onError, "SpotifyCall", "getPlayerState", []);
};

/**
 * Events
 */

SpotifyCall.events = {
    onPause: function () { },
    onResume: function () { },
    /**
     * 
     * @param number state 
     * 0 = didFailConnectionAttemptWithError
     * 1 = didDisconnectWithError
     * 2 = appRemoteDidEstablishConnection
     */
    appRemoteStateChange: function (state) {}
}


module.exports = SpotifyCall;
