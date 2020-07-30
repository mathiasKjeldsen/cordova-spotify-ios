# cordova-spotify-ios
Cordova integration with the Spotify iOS SDK


### Install

```
npm install cordova-spotify-ios
```


### Access through window
```javascript
private spotifyiOS = window.cordova.plugins.spotifyCall
```

## Initialization and authorization
A Spotify developer application has to be registered in the Spotify developer dashboard
https://developer.spotify.com/dashboard/applications

### Config

A JSON object config needs to be assembled to initialize with the Spotify App

```javascript
config: {
    clientID: "############################",
    redirectURL: "url-scheme://callback",
    tokenRefreshURL: "your-server/refresh",
    tokenSwapURL: "your-server/exchange",
},
```



### Initialize a session with the Spotify App
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



# window.cordova.plugins.spotifyCall
