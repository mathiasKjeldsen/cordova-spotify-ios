#import "SpotifyRemote.h"
#import <SpotifyiOS/SpotifyiOS.h>
#import "SpotifyiOSHeaders.h"
#import "SpotifyConvert.h"
#define SPOTIFY_API_BASE_URL @"https://api.spotify.com/"
#define SPOTIFY_API_URL(endpoint) [NSURL URLWithString:NSString_concat(SPOTIFY_API_BASE_URL, endpoint)]

static SpotifyRemote *sharedInstance = nil;

@interface SpotifyRemote () <SPTAppRemoteDelegate,SPTAppRemotePlayerStateDelegate>
{
    BOOL _isConnected;
    NSString* _connectCallbackMessage;
    NSString* _uri;
    NSInteger* _position;
    NSInteger _index;
    NSDictionary* _contentItem;
    SPTAppRemote* _appRemote;
}
- (void)initializeAppRemote:(NSString*)accessToken playURI:(NSString*)uri;
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

- (void)initializeAppRemote:(NSString*)accessToken playURI:(NSString*)uri{
    _appRemote = [[SPTAppRemote alloc] initWithConfiguration:[[SpotifyiOS sharedInstance] configuration] logLevel:SPTAppRemoteLogLevelDebug];

    _appRemote.connectionParameters.accessToken = accessToken != nil ? accessToken : [[SpotifyiOS sharedInstance] accessToken];

    _appRemote.delegate = self;
    BOOL spotifyInstalled = [_appRemote authorizeAndPlayURI:uri];
    if(!spotifyInstalled) {
        [self emit:@"Spotify is not installed" withError:@"YES"];
    }
}

- (BOOL)isconnected {
    return (_appRemote != nil && _appRemote.isConnected) ? YES : NO;
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"App Remote disconnected");
    _isConnected = NO;
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"App Failed To Connect to Spotify");
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)connectedRemote {
    NSLog(@"App Remote Connection Initiated");
    _isConnected = YES;
    [self subToPlayerState];
    [_appRemote.playerAPI setRepeatMode:1 callback:[self logCallbackAndEmit:@"setRepeatMode"]];
    [_appRemote.playerAPI setShuffle:NO callback:[self logCallbackAndEmit:@"setShuffle"]];
    if(_connectCallbackMessage) {
        if([_connectCallbackMessage  isEqual: @"playUri"]) {
            [self playUri:_uri];
        } else if([_connectCallbackMessage  isEqual: @"pause"]) {
            [self pause];
        } else if([_connectCallbackMessage  isEqual: @"resume"]) {
            [self resume];
        } else if([_connectCallbackMessage  isEqual: @"getPlayerState"]) {
            [self getPlayerState];
        } else if([_connectCallbackMessage  isEqual: @"seek"]) {
            [self seek:*(_position)];
        } else if([_connectCallbackMessage  isEqual: @"queueUri"]) {
            [self queueUri:_uri];
        } else if([_connectCallbackMessage  isEqual: @"getPlaylistAndPlay"]) {
            [self getPlaylistAndPlay:_uri index:_index];
        }
    }
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"didFailConnectionAttemptWithError %@", error.description);
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
                NSLog( @"%@", [SpotifyConvert SPTAppRemoteContentItem:result] );
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
    [_appRemote.playerAPI playItem:item skipToTrackIndex:index callback:[self logCallbackAndEmit:@"playItemFromIndex"]];
}

- (void) getPlayerState {
    if(_isConnected) {
        [_appRemote.playerAPI getPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
             if(error) {
                NSLog(@"getPlayerState err: %@", error.description);
             } else {
                 if (self.eventCallbackId == nil) {
                     NSLog(@"callbackid is nil");
                     return;
                 }
                 CDVPluginResult *plResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
                     messageAsDictionary:[SpotifyConvert SPTAppRemotePlayerState:result]];
                 
                 [self.commandDelegate sendPluginResult: plResult
                                             callbackId: self.eventCallbackId];
             }
        }];
    } else {
        [self connect:@"getPlayerState"];
    }
}

- (void) connect:(NSString*)callback{
    _connectCallbackMessage = callback;
    _appRemote = [[SPTAppRemote alloc] initWithConfiguration:[[SpotifyiOS sharedInstance] configuration] logLevel:SPTAppRemoteLogLevelDebug];
    _appRemote.connectionParameters.accessToken = [[SpotifyiOS sharedInstance] accessToken];
    _appRemote.delegate = self;
    [_appRemote connect];
}

- (void) subToPlayerState {
    _appRemote.playerAPI.delegate = self;
    [_appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
    }];
}


- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    NSLog( @"%@", [SpotifyConvert SPTAppRemotePlayerState:playerState] );
}

- (void)emit:(NSString*)message withError:(NSString*)err {
    
    if (self.eventCallbackId == nil) {
        NSLog(@"callbackid is nil");
        return;
    }
    
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
