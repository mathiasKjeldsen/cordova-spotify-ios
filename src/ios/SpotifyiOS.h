#define SpotifyiOS_h
#import <SpotifyiOS/SpotifyiOS.h>
#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyiOS : CDVPlugin <SPTSessionManagerDelegate>

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

+(instancetype)sharedInstance;

-(void)initialize:(NSDictionary*)options;

-(SPTConfiguration*) configuration;
-(NSString*) accessToken;
@end

NS_ASSUME_NONNULL_END
