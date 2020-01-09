#import "SpotifyiOS.h"

static NSString * const SpotifyClientID = @"9b257073946649de9b1a2f37de3e0763";
static NSString * const SpotifyRedirectURLString = @"soundseek-party://callback";

@interface SpotifyiOS ()
@end

@implementation SpotifyiOS


- (void)pluginInitialize
{
    /*
     This configuration object holds your client ID and redirect URL.
     */
    SPTConfiguration *configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID
                                                                      redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];

    // Set these url's to your backend which contains the secret to exchange for an access token
    // You can use the provided ruby script spotify_token_swap.rb for testing purposes
    configuration.tokenSwapURL = [NSURL URLWithString: @"https://soundseek-mobile.herokuapp.com/exchange"];
    configuration.tokenRefreshURL = [NSURL URLWithString: @"https://soundseek-mobile.herokuapp.com/refresh"];

    /*
     The session manager lets you authorize, get access tokens, and so on.
     */
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration
                                                                    delegate:self];}

- (void) runAuth:(CDVInvokedUrlCommand*)command {
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

@end