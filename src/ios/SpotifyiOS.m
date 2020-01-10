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
-(instancetype)init NS_UNAVAILABLE;

@end

@implementation SpotifyiOS

- (NSString*) accessToken{
    return _sessionManager.session.accessToken;
}

- (SPTConfiguration*) configuration{
    return _apiConfiguration;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SpotifyiOS alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {}
    return self;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSLog(@"application from spotifyiOS");
    BOOL returnVal = NO;
    NSLog(@"init session manager:");
    NSLog(@"%@", _options[@"clientID"]);
    NSLog(@"%@", _options[@"redirectURL"]);
    NSLog(@"%@", _options[@"tokenSwapURL"]);
    NSLog(@"%@", _options[@"tokenRefreshURL"]);
    if(_sessionManager != nil){
        NSLog(@"Setting application openURL and options on session manager");
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:TRUE];
        NSURLQueryItem * errorDescription = [[[urlComponents queryItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", SPTAppRemoteErrorDescriptionKey]] firstObject];
        
        // If there was an error we should reject our pending Promise
        if(errorDescription){
            returnVal = NO;
        }
        returnVal = [_sessionManager application:application openURL:URL options:options];
    } else {
        NSLog(@"sessionManager is nil");
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

    NSLog(@"INIT CDV CALL");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SpotifyiOS alloc] init];
        NSLog(@"instance created??");
    });
    
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

    _options = command.arguments[0];
    [self initializeSessionManager:command.arguments[0]];
}


- (void)initializeSessionManager:(NSDictionary*)options{
    
    NSLog(@"init session manager:");
    NSLog(@"%@", options[@"clientID"]);
    NSLog(@"%@", options[@"redirectURL"]);
    NSLog(@"%@", options[@"tokenSwapURL"]);
    NSLog(@"%@", options[@"tokenRefreshURL"]);

    _apiConfiguration = [SPTConfiguration configurationWithClientID:options[@"clientID"] redirectURL:[NSURL URLWithString:options[@"redirectURL"]]];
        _apiConfiguration.tokenSwapURL = [NSURL URLWithString: options[@"tokenSwapURL"]];
        _apiConfiguration.tokenRefreshURL = [NSURL URLWithString: options[@"tokenRefreshURL"]];
    
    SPTScope scope = SPTAppRemoteControlScope | SPTUserFollowReadScope;
    
    _sessionManager = [SPTSessionManager sessionManagerWithConfiguration:_apiConfiguration delegate:self];

    if(_sessionManager != nil) {
        NSLog(@"session manager is alive @init");
    }
    if (@available(iOS 11, *)) {
        [_sessionManager
             initiateSessionWithScope:scope
             options:SPTDefaultAuthorizationOption
        ];
    }
}
@end
