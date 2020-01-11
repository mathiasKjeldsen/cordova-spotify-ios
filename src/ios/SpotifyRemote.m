#import "SpotifyRemote.h"
#import <SpotifyiOS/SpotifyiOS.h>
#import "SpotifyiOSHeaders.h"

#define SPOTIFY_API_BASE_URL @"https://api.spotify.com/"
#define SPOTIFY_API_URL(endpoint) [NSURL URLWithString:NSString_concat(SPOTIFY_API_BASE_URL, endpoint)]

static SpotifyRemote *sharedInstance = nil;

@interface SpotifyRemote () <SPTAppRemoteDelegate,SPTAppRemotePlayerStateDelegate>
{
    BOOL _isConnecting;
    NSString* _accessToken;
    
    SPTAppRemote *_appRemote;
}
- (void)initializeAppRemote:(NSString*)accessToken;
@end

@implementation SpotifyRemote

+ (SpotifyRemote *)sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedInstance = [[SpotifyRemote alloc] init];
    });
    return sharedInstance;
}

- (void)initializeAppRemote:(NSString*)accessToken playURI:(NSString*)uri{
    NSLog(@"init app remote: %@", accessToken);
    _appRemote = [[SPTAppRemote alloc] initWithConfiguration:[[SpotifyiOS sharedInstance] configuration] logLevel:SPTAppRemoteLogLevelDebug];

    _appRemote.connectionParameters.accessToken = accessToken != nil ? accessToken : [[SpotifyiOS sharedInstance] accessToken];

    _appRemote.delegate = self;
    [_appRemote authorizeAndPlayURI:uri];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"App Remote disconnected");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"App Failed To Connect to Spotify");
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)connectedRemote {
    NSLog(@"App Remote Connection Initiated");
    _appRemote.playerAPI.delegate = self;
    //[self playUri:@"spotify:track:22nyEAEM29tcBRhukR089b"];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    //<#code#>
}


- (void)playUri:(NSString*)uri{
    if(_appRemote && _appRemote.playerAPI != nil) {
        [_appRemote.playerAPI play:uri callback:^(id  _Nullable result, NSError * _Nullable error) {
            NSLog(@"error????????");
        }];
    }
     
}


- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
   // <#code#>
}

@end