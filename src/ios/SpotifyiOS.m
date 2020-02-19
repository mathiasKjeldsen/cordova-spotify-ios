#import "SpotifyiOS.h"
#import <Cordova/CDVPluginResult.h>
#import "SpotifyiOSHeaders.h"

static NSString * const SpotifyClientID = @"715e9350d6e54e6684ebd84775d91538";
static NSString * const SpotifyRedirectURLString = @"soundseek-party://callback";

static SpotifyiOS *sharedInstance = nil;

@interface SpotifyiOS () <SPTSessionManagerDelegate> {
    NSDictionary* _options;
    SPTConfiguration* _apiConfiguration;
    SPTSessionManager* _sessionManager;
    BOOL _initAndPlay;
}

@end

@implementation SpotifyiOS

- (instancetype)initWithCommandDelegate:(id <CDVCommandDelegate>)commandDelegate {
    self.commandDelegate = commandDelegate;
    return self;
}

- (void)setCallbackId:(NSString *) callbackId {
    self.eventCallbackId = callbackId;
}

- (NSString*) accessToken{
    return _sessionManager.session.accessToken;
}

- (SPTConfiguration*) configuration{
    return _apiConfiguration;
}

+ (SpotifyiOS *)sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedInstance = [[SpotifyiOS alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isSpotifyAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"spotify:"]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL returnVal = YES;
    if(_sessionManager != nil){
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:TRUE];
        NSURLQueryItem * errorDescription = [[[urlComponents queryItems] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", SPTAppRemoteErrorDescriptionKey]] firstObject];
        
        if(errorDescription){
            returnVal = NO;
        }
        returnVal = [_sessionManager application:application openURL:URL options:options];
    }
    
    return returnVal;
}

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    
    NSLog(@"%@", session);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ssSSSSSS"];
    NSString *stringDate = [dateFormatter stringFromDate:session.expirationDate];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
    messageAsDictionary:@{
        @"accessToken": session.accessToken,
        @"refreshToken": session.refreshToken,
        @"expirationDate": stringDate
    }];
    [result setKeepCallbackAsBool:YES];
        
    [self.commandDelegate sendPluginResult: result
                                callbackId: self.eventCallbackId];
    
    if(_initAndPlay) {
        _initAndPlay = NO;
        [[SpotifyRemote sharedInstance] connectAppRemote];
        [self emit:@"" withError:nil];
    }
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"auth failed %@", error.description);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    NSLog(@"session renewed %@", session.description);
}

- (void) initialize:(NSDictionary*)options{
    _apiConfiguration = [SPTConfiguration configurationWithClientID:options[@"clientID"] redirectURL:[NSURL URLWithString:options[@"redirectURL"]]];
    _apiConfiguration.tokenSwapURL = [NSURL URLWithString: options[@"tokenSwapURL"]];
    _apiConfiguration.tokenRefreshURL = [NSURL URLWithString: options[@"tokenRefreshURL"]];
    
    SPTScope scope = SPTAppRemoteControlScope | SPTUserFollowReadScope | SPTPlaylistModifyPrivateScope | SPTPlaylistReadPrivateScope  | SPTUserLibraryReadScope | SPTUserTopReadScope | SPTUserReadPrivateScope | SPTUserLibraryModifyScope | SPTPlaylistReadCollaborativeScope | SPTUserReadEmailScope;
    
    _sessionManager = [SPTSessionManager sessionManagerWithConfiguration:_apiConfiguration delegate:self];
    
    if (@available(iOS 11, *)) {
        [_sessionManager
             initiateSessionWithScope:scope
             options:SPTDefaultAuthorizationOption
        ];
    }
}

-(void)initAndPlay:(NSDictionary *)options {
    _initAndPlay = YES;
    _apiConfiguration = [SPTConfiguration configurationWithClientID:options[@"clientID"] redirectURL:[NSURL URLWithString:options[@"redirectURL"]]];
    _apiConfiguration.tokenSwapURL = [NSURL URLWithString: options[@"tokenSwapURL"]];
    _apiConfiguration.tokenRefreshURL = [NSURL URLWithString: options[@"tokenRefreshURL"]];
    _apiConfiguration.playURI = options[@"playURI"];
    
    SPTScope scope = SPTAppRemoteControlScope | SPTUserFollowReadScope | SPTPlaylistModifyPrivateScope | SPTPlaylistReadPrivateScope  | SPTUserLibraryReadScope | SPTUserTopReadScope | SPTUserReadPrivateScope | SPTUserLibraryModifyScope | SPTPlaylistReadCollaborativeScope | SPTUserReadEmailScope;
    
    _sessionManager = [SPTSessionManager sessionManagerWithConfiguration:_apiConfiguration delegate:self];
    
    if (@available(iOS 11, *)) {
        [_sessionManager
             initiateSessionWithScope:scope
             options:SPTDefaultAuthorizationOption
        ];
    }
}

- (void) renewSession {
    [_sessionManager renewSession];
}

- (void)emit:(NSString*)message withError:(NSString*)err {
    
    if (self.eventCallbackId == nil) {
        NSLog(@"callbackid is nil");
        return;
    }
    
    CDVPluginResult *result;
    if(err) {
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
        messageAsDictionary:@{
            @"error": message
        }];
    } else {
        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
        messageAsDictionary:@{
            @"success": message
        }];
    }
        
    [result setKeepCallbackAsBool:YES];
        
    [self.commandDelegate sendPluginResult: result
                                callbackId: self.eventCallbackId];
}

@end
