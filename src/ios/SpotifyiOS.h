#define SpotifyiOS_h
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyiOS : NSObject <SPTSessionManagerDelegate>

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

+(SpotifyiOS*)sharedInstance;

-(void)initialize:(NSDictionary*)options;

-(SPTConfiguration*) configuration;
-(NSString*) accessToken;
@end

NS_ASSUME_NONNULL_END
