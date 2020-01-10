#define SpotifyiOS_h
#import <SpotifyiOS/SpotifyiOS.h>
#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyiOS : CDVPlugin <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

+ (instancetype) sharedInstance;

- (void) initialize:(CDVInvokedUrlCommand*)command;

- (SPTConfiguration*) configuration;
- (NSString*) accessToken;

@end

NS_ASSUME_NONNULL_END
