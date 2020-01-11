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

- (void)setEmitEventCallbackId:(NSString *) callbackId {
    self.emitEventCallbackId = callbackId;
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
    BOOL canPlay = [_appRemote authorizeAndPlayURI:uri];
    if(canPlay) {
        [self connect:nil];
    }
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"App Remote disconnected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"App Failed To Connect to Spotify");
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)connectedRemote {
    NSLog(@"App Remote Connection Initiated");
    _isConnected = YES;
    [self subToPlayerState];
    if(_connectCallbackMessage) {
        if([_connectCallbackMessage  isEqual: @"playUri"]) {
            [self playUri:_uri];
        } else if([_connectCallbackMessage  isEqual: @"pause"]) {
            [self pause];
        } else if([_connectCallbackMessage  isEqual: @"resume"]) {
            [self resume];
        }
    }
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"didFailConnectionAttemptWithError %@", error.description);
}


- (void)playUri:(NSString*)uri{
    if(_isConnected) {
        [_appRemote.playerAPI play:uri callback:^(id  _Nullable result, NSError * _Nullable error) {
            NSLog(@"playURI error %@", error.description);
            if(error) {
                NSLog(@"%@", error.description);
                [self emit:[NSString stringWithFormat:@"%@,%s", uri, "playbackerrorfam"] withError:@"YES"];
            } else {
                [self emit:[NSString stringWithFormat:@"%@,%s", uri, "Started playing"] withError:nil];
            }
        }];
    } else {
        [self connect:@"playUri"];
    }
}

- (void) pause {
    if(_isConnected) {
        [_appRemote.playerAPI pause:^(id  _Nullable result, NSError * _Nullable error) {
            NSLog(@"pause err: %@", error.description);
        }];
    } else {
        [self connect:@"pause"];
    }
}

- (void) resume {
    if(_isConnected) {
        [_appRemote.playerAPI resume:^(id  _Nullable result, NSError * _Nullable error) {
            NSLog(@"resume err: %@", error.description);
        }];
    } else {
        [self connect:@"resume"];
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
        NSLog(@"%@", error.description);
    }];
}


- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    NSLog(@"%@", playerState.track.name);
}

- (void)emit:(NSString*)message withError:(NSString*)err {
    
    if (self.eventCallbackId == nil) {
        NSLog(@"callbackid is nil");
        return;
    }
    
    NSLog(@"%@", [[SpotifyRemote sharedInstance] eventCallbackId]);
    CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
    messageAsString: message];
    
    if(!err) {
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
        messageAsString: message];
    }
        
    [self.commandDelegate sendPluginResult: result
                                callbackId: self.eventCallbackId];
}

@end
