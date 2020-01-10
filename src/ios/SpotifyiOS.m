#import "SpotifyiOS.h"

static NSString * const SpotifyClientID = @"9b257073946649de9b1a2f37de3e0763";
static NSString * const SpotifyRedirectURLString = @"soundseek-party://callback";

@interface SpotifyiOS ()
@end

@implementation SpotifyiOS


- (void)viewDidLoad
{
    NSLog(@"doing auth now");
    
    SPTConfiguration *configuration =
        [[SPTConfiguration alloc] initWithClientID:SpotifyClientID redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    configuration.playURI = @"";
    configuration.tokenSwapURL = [NSURL URLWithString: @"http://localhost:1234/swap"];
    configuration.tokenRefreshURL = [NSURL URLWithString: @"http://localhost:1234/refresh"];
    
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration delegate:self];

    NSLog(@"jobsdone");
    
}

- (void) runAuth {
    SPTScope scope = SPTUserLibraryReadScope | SPTPlaylistReadPrivateScope;
    NSLog(@"Run auth!");
    if (@available(iOS 11, *)) {
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
    }
}

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    NSLog(@"auth success");
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"auth failed");
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    NSLog(@"session renewed");
}

- (BOOL)sessionManager:(SPTSessionManager *)manager shouldRequestAccessTokenWithAuthorizationCode:(SPTAuthorizationCode)code {
    NSLog(@"resquestaccesstokenwithauth");
    return YES;
}


- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"app remote disc w err");
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"app remote dod fail connect attemp");
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"app remote connecc");
}

@end
