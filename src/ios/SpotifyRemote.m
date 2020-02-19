#import "SpotifyRemote.h"
#import <SpotifyiOS/SpotifyiOS.h>
#import "SpotifyiOSHeaders.h"
#import "SpotifyConvert.h"

static SpotifyRemote *sharedInstance = nil;

@interface SpotifyRemote () <SPTAppRemoteDelegate,SPTAppRemotePlayerStateDelegate>
{
    BOOL _isConnected;
    NSString* _connectCallbackMessage;
    NSString* _uri;
    NSInteger* _position;
    NSInteger _index;
    NSDictionary* _contentItem;
    NSObject<SPTAppRemotePlayerState>* _playerState;
    SPTConfiguration* _apiConfiguration;
    SPTAppRemote* _appRemote;
    SPTAppRemoteConnectionParams* _appRemoteConnectionParams;
    NSString* _accessToken;
    BOOL _authAndPlay;
    NSString* _playURI;
    SPTSessionManager* _sessionManager;

    
}
- (void)initializeAppRemote:(NSDictionary*)options accessToken:(NSString *)accessToken;
@end

@implementation SpotifyRemote

- (instancetype)initWithCommandDelegate:(id <CDVCommandDelegate>)commandDelegate {
    self.commandDelegate = commandDelegate;
    return self;
}

- (void)setCallbackId:(NSString *) callbackId {
    self.eventCallbackId = callbackId;
}

+ (SpotifyRemote *)sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedInstance = [[SpotifyRemote alloc] init];
    });
    return sharedInstance;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return YES;
}

- (void)initializeAppRemote:(NSDictionary*)options accessToken:(NSString*)accessToken{
    _accessToken = accessToken;
    _authAndPlay = YES;
    _playURI = options[@"playURI"];
    _apiConfiguration = [[SPTConfiguration alloc] initWithClientID:options[@"clientID"] redirectURL:[NSURL URLWithString:options[@"redirectURL"]]];
    _apiConfiguration.tokenSwapURL = [NSURL URLWithString: options[@"tokenSwapURL"]];
    _apiConfiguration.tokenRefreshURL = [NSURL URLWithString: options[@"tokenRefreshURL"]];
    _apiConfiguration.playURI = _playURI;
    
    
    _appRemote = [[SPTAppRemote alloc] initWithConfiguration:_apiConfiguration logLevel:SPTAppRemoteLogLevelDebug];
    _appRemote.delegate = self;
    [_appRemote authorizeAndPlayURI:_playURI];
}

-(void) authParamsFromURL:(NSURL *)url {
    NSDictionary* parameters = [_appRemote authorizationParametersFromURL:url];
    
    NSString* token = parameters[SPTAppRemoteAccessTokenKey];
    NSString* err = parameters[SPTAppRemoteErrorDescriptionKey];
    _appRemote.connectionParameters.accessToken = token;
    [_appRemote connect];
}


- (BOOL)isConnected {
    return (_appRemote != nil && _appRemote.isConnected) ? YES : NO;
}

- (void)connectAppRemote {
    [_appRemote connect];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"App Remote disconnected");
    _isConnected = NO;
    [self.commandDelegate evalJs:@"window.cordova.plugins.spotifyCall.events.appRemoteStateChange(1)"];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"App Failed To Connect to Spotify");
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)connectedRemote {
    
    [self.commandDelegate evalJs:@"window.cordova.plugins.spotifyCall.events.appRemoteStateChange(2)"];
    NSLog(@"App Remote Connection Initiated");
    _isConnected = YES;
    [self subToPlayerState];
    [_appRemote.playerAPI setRepeatMode:0 callback:[self logCallbackAndEmit:@"setRepeatMode"]];
    [_appRemote.playerAPI setShuffle:NO callback:[self logCallbackAndEmit:@"setShuffle"]];
    if(_connectCallbackMessage) {
        if([_connectCallbackMessage  isEqual: @"playUri"]) {
            [self playUri:_uri];
        } else if([_connectCallbackMessage  isEqual: @"pause"]) {
            [self pause];
        } else if([_connectCallbackMessage  isEqual: @"resume"]) {
            [self resume];
        } else if([_connectCallbackMessage  isEqual: @"seek"]) {
            [self seek:*(_position)];
        } else if([_connectCallbackMessage  isEqual: @"queueUri"]) {
            [self queueUri:_uri];
        } else if([_connectCallbackMessage  isEqual: @"getPlaylistAndPlay"]) {
            [self getPlaylistAndPlay:_uri index:_index];
        }
        _connectCallbackMessage = nil;
    }
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"didFailConnectionAttemptWithError %@", error.description);
    
    [self.commandDelegate evalJs:@"window.cordova.plugins.spotifyCall.events.appRemoteStateChange(0)"];
}

- (void)playUri:(NSString*)uri{
    if(_isConnected) {
        [_appRemote.playerAPI play:uri callback:[self logCallbackAndEmit:@"playUri"]];
    } else {
        _uri = uri;
        [self connect:@"playUri"];
    }
}

- (void)queueUri:(NSString*)uri{
    if(_isConnected) {
        [_appRemote.playerAPI enqueueTrackUri:uri callback:[self logCallbackAndEmit:@"queueUri"]];
    } else {
        _uri = uri;
        [self connect:@"queueUri"];
    }
}

- (void) pause {
    if(_isConnected) {
        [_appRemote.playerAPI pause:[self logCallbackAndEmit:@"pause"]];
    } else {
        [self connect:@"pause"];
    }
}

- (void) resume {
    if(_isConnected) {
        [_appRemote.playerAPI resume:[self logCallbackAndEmit:@"resume"]];
    } else {
        [self connect:@"resume"];
    }
}

- (void) seek:(NSInteger)position {
    if(_isConnected) {
        
        [_appRemote.playerAPI seekToPosition:position callback:[self logCallbackAndEmit:@"seekToPosition"]];
    } else {
        _position = &position;
        [self connect:@"seek"];
    }
}

- (void) getPlaylistAndPlay:(NSString*)uri index:(NSInteger)index {
    if(_isConnected) {
        [_appRemote.contentAPI fetchContentItemForURI:uri callback:^(id  _Nullable result, NSError * _Nullable error) {
            if(result) {
                NSObject<SPTAppRemoteContentItem> *item = result;
                if(item.playable) {
                    [self playItemFromIndex:result index:index];
                } else {
                    [self emit:@"The provided playlist can not be played." withError:@"YES"];
                }
            } else {
                [self emit:error.description withError:@"YES"];
            }
        }];
    } else {
        _uri = uri;
        _index = index;
        [self connect:@"getPlaylistAndPlay"];
    }
}

- (void) playItemFromIndex:(NSObject<SPTAppRemoteContentItem>*)item index:(NSInteger)index {
    [_appRemote.playerAPI setRepeatMode:0 callback:[self logCallbackAndEmit:@"setRepeatMode"]];
    [_appRemote.playerAPI playItem:item skipToTrackIndex:index callback:[self logCallbackAndEmit:@"playItemFromIndex"]];
}

- (void) connect:(NSString*)callback{
    _connectCallbackMessage = callback;
    _appRemote = [[SPTAppRemote alloc] initWithConfiguration:_apiConfiguration logLevel:SPTAppRemoteLogLevelDebug];
    _appRemote.connectionParameters.accessToken = _accessToken;
    _appRemote.delegate = self;
    [_appRemote connect];
}

- (void) subToPlayerState {
    _appRemote.playerAPI.delegate = self;
    [_appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
    }];
}


- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    
    if(_playerState != nil) {
        if(![_playerState.track.URI isEqualToString:playerState.track.URI]) {
            NSString *str = [NSString stringWithFormat:@"window.cordova.plugins.spotifyCall.events.onTrackEnded('%@')",playerState.track.URI];
            [self.commandDelegate evalJs:str];
        }
    }
    
    if(playerState.paused && !_playerState.isPaused) {
        [self.commandDelegate evalJs:@"window.cordova.plugins.spotifyCall.events.onPause()"];
    }
    
    if(!playerState.paused && _playerState.isPaused) {
        [self.commandDelegate evalJs:@"window.cordova.plugins.spotifyCall.events.onResume()"];
    }
    _playerState = playerState;
}

- (void)emit:(NSString*)message withError:(NSString*)err {
    
    if (self.eventCallbackId == nil) {
        NSLog(@"callbackid is nil");
        return;
    }
    NSLog(@"%@", self.eventCallbackId);
    CDVPluginResult *result;
    if(err) {
        NSDictionary *response = @{
            @"error": message
        };
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
        messageAsDictionary: response];
    } else {
        NSDictionary *response = @{
            @"success": message
        };
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
        messageAsDictionary:response];
        NSLog(@"%@", response);
    }
        
    [result setKeepCallbackAsBool:YES];
        
    [self.commandDelegate sendPluginResult: result
                                callbackId: self.eventCallbackId];
}

- (void (^)(id _Nullable, NSError * _Nullable))logCallbackAndEmit:(NSString*)context {
    return ^(id  _Nullable result, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@" %@ %@", context, error.description);
            [self emit:[NSString stringWithFormat:@"%@,%@", context, error.description] withError:@"YES"];
        } else {
            if(result) {
                NSLog(@" %@ %s", context, "SUCCESS");
                [self emit:[NSString stringWithFormat:@"%@,%s", context, "SUCCESS"] withError:nil];
            }
        }
    };
}

@end
