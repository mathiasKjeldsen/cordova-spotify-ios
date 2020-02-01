#define SpotifyiOS_h
#import <SpotifyiOS/SpotifyiOS.h>
#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyiOS : NSObject <SPTSessionManagerDelegate>

@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;
@property (nonatomic) NSString *eventCallbackId;

-(void) setCallbackId:(NSString *) callbackId;

-(BOOL)isSpotifyAppInstalled;

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

+(SpotifyiOS*)sharedInstance;

-(void)initialize:(NSDictionary*)options;

-(SPTConfiguration*) configuration;
-(NSString*) accessToken;

- (instancetype)initWithCommandDelegate: (id <CDVCommandDelegate>) commandDelegate;

@end

NS_ASSUME_NONNULL_END
