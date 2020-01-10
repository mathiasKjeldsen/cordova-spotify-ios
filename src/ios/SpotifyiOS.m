#import "SpotifyiOS.h"

static NSString * const SpotifyClientID = @"715e9350d6e54e6684ebd84775d91538";
static NSString * const SpotifyRedirectURLString = @"soundseek-party://callback";

static SpotifyiOS *sharedInstance = nil;


@interface SpotifyiOS () <SPTSessionManagerDelegate> {
    BOOL _initialized;
    BOOL _isInitializing;
    BOOL _isRemoteConnected;
    NSDictionary* _options;

    SPTConfiguration* _apiConfiguration;
    SPTSessionManager* _sessionManager;
}
- (void)initializeSessionManager:(NSDictionary*)options;

@end

@implementation SpotifyiOS

- (NSString*) accessToken{
    return _sessionManager.session.accessToken;
}

- (SPTConfiguration*) configuration{
    return _apiConfiguration;
}


+ (instancetype)sharedInstance {
    return sharedInstance;
}

-(id)init
{
    if(sharedInstance == nil){
        if(self = [super init])
        {
            _initialized = NO;
            _isInitializing = NO;
            _isRemoteConnected = NO;
            _apiConfiguration = nil;
            _sessionManager = nil;
        }
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            sharedInstance = self;
        });
    }else{
        NSLog(@"Returning shared instance");
    }
    return sharedInstance;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL returnVal = NO;
    if(_sessionManager != nil){
        NSLog(@"Setting application openURL and options on session manager");
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:TRUE];
        NSURLQueryItem * errorDescription = [[[urlComponents queryItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", SPTAppRemoteErrorDescriptionKey]] firstObject];
        
        // If there was an error we should reject our pending Promise
        if(errorDescription){
            returnVal = NO;
        }
        returnVal = [_sessionManager application:application openURL:URL options:options];
    }
    if(returnVal){
//        [self resolveCompletions:_sessionManagerCallbacks result:nil];
    }
    return returnVal;
}

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    NSLog(@"auth success %@", session.description);
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"auth failed %@", error.description);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    NSLog(@"session renewed %@", session.description);
}

- (BOOL)sessionManager:(SPTSessionManager *)manager shouldRequestAccessTokenWithAuthorizationCode:(SPTAuthorizationCode)code {
    NSLog(@"resquestaccesstokenwithauth %@", code);
    return YES;
}

- (void) initialize:(CDVInvokedUrlCommand*)command{
        
    if(_isInitializing){
        NSLog(@"isInitializing");
        return;
    }
    
    if(_initialized && [_sessionManager session]!= nil && [_sessionManager session].isExpired == NO)
    {
        NSLog(@"!initialized && session != nil %% isExpired == no");
        return;
    }
    _isInitializing = YES;

    // store the options
    _options = command.arguments[0];
    [self initializeSessionManager:command.arguments[0]];
}


- (void)initializeSessionManager:(NSDictionary*)options{
    // Create our configuration object
    _apiConfiguration = [SPTConfiguration configurationWithClientID:options[@"clientID"] redirectURL:[NSURL URLWithString:options[@"redirectURL"]]];
    // Add swap and refresh urls to config if present
    if(options[@"tokenSwapURL"] != nil){
        _apiConfiguration.tokenSwapURL = [NSURL URLWithString: options[@"tokenSwapURL"]];
    }
    
    if(options[@"tokenRefreshURL"] != nil){
        _apiConfiguration.tokenRefreshURL = [NSURL URLWithString: options[@"tokenRefreshURL"]];
    }
    
    // Default Scope
    SPTScope scope = SPTAppRemoteControlScope | SPTUserFollowReadScope;
    
    _sessionManager = [SPTSessionManager sessionManagerWithConfiguration:_apiConfiguration delegate:self];
    
    if (@available(iOS 11, *)) {
        [ self->_sessionManager
             initiateSessionWithScope:scope
             options:SPTDefaultAuthorizationOption
        ];
    }
}

/*const spotifyConfig: ApiConfig = {
    clientID: "SPOTIFY_CLIENT_ID",
    redirectURL: "SPOTIFY_REDIRECT_URL",
    tokenRefreshURL: "SPOTIFY_TOKEN_REFRESH_URL",
    tokenSwapURL: "SPOTIFY_TOKEN_SWAP_URL",
    scope: ApiScope.AppRemoteControlScope | ApiScope.UserFollowReadScope
}*/





///////////////


- (void)setConfig
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
    NSLog(@"trying to init session now");
    if (@available(iOS 11, *)) {
        [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
    }
}


@end
