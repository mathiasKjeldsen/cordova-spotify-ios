# cordova-spotify-ios
Cordova integration with the Spotify iOS SDK

https://github.com/spotify/ios-sdk


## Install

```
cordova plugin add cordova-spotify-ios
```

Download the latest version of the Spotify iOS SDK and import it into Xcode

https://github.com/spotify/ios-sdk/releases


## Spotify App Redirect
For the Spotify App to be able to redirect back to your application, with a session, you need to add the following code to your AppDelegate in Xcode.

```objective-c

#import "SpotifyiOSHeaders.h"

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if([[SpotifyRemote sharedInstance]eventCallbackId] != nil) {
        [[SpotifyRemote sharedInstance] emit:@"CONNECT" withError:nil];
        [[SpotifyRemote sharedInstance] authParamsFromURL:URL];
    }
    return [[SpotifyiOS sharedInstance] application:application openURL:URL options:options];
}
```


## Access through window
```javascript
private spotifyiOS = window.cordova.plugins.spotifyCall
```

## Initialization and authorization
A Spotify developer application has to be registered in the Spotify developer dashboard
https://developer.spotify.com/dashboard/applications

The Spotify App must be installed on the device for the plugin to work.

#### Check if Spotify is installed
```javascript
this.spotifyiOS.isSpotifyAppInstalled(onSuccess); // true or false
```

#### Config

A JSON object config needs to be assembled to initialize with the Spotify App

```javascript
config: {
    clientID: "############################",
    redirectURL: "url-scheme://callback",
    tokenRefreshURL: "your-server/refresh",
    tokenSwapURL: "your-server/exchange",
},
```

#### Initialize a session with the Spotify App
```javascript
this.spotifyiOS.initialize(onSuccess, onError, config);
```

Example
```javascript

this.spotifyiOS.initialize(({accessToken, refreshToken}) => {
    let date = new Date();
    const expirationDate = date.setHours(date.getHours() + 1).toString();
    window.localStorage.setItem('accessToken', accessToken);
    window.localStorage.setItem('refreshToken', refreshToken);
    window.localStorage.setItem('expirationDate', expirationDate);
}, this.handleError, this.config);
```


## App Remote

#### Check if App Remote is connected

```javascript
this.spotifyiOS.isAppRemoteConnected(onSuccess); // true or false
```

#### Play

If App Remote is not connected
```javascript
this.spotifyiOS.authAndPlay(onSuccess, onError, config);
```
If App remote is connected
```javascript
this.spotifyiOS.queueURI(onSuccess, onError, playuri); // URI of the requested track
this.spotifyiOS.playURI(onSuccess, onError, playuri); // URI of the requested track
```

#### Play playlist
Requirements
- PlaylistURI: spotify:playlist:**playlistid**
- Index: Start index
```javascript
this.spotifyiOS.playPlaylistByUriAndIndex(onSucess, onError, playuri, index);
```
#### Control
```javascript
this.spotifyiOS.resume(onSuccess, onError);
this.spotifyiOS.pause(onSuccess, onError);
this.spotifyiOS.seek(onSuccess, onError, position); // target position in milliseconds
```

## Events

```javascript
this.spotifyiOS.events.onPause = () => {}
this.spotifyiOS.events.onResume = () => {}
this.spotifyiOS.events.onTrackEnded = (trackURI: string) => {}
this.spotifyiOS.events.appRemoteStateChange = (state: number) => {
 0 = didFailConnectionAttemptWithError  
 1 = didDisconnectWithError
 2 = appRemoteDidEstablishConnection    
}

```
