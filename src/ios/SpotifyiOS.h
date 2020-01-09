#import <SpotifyiOS/SpotifyiOS.h>
#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyiOS: CDVPlugin <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

@end

NS_ASSUME_NONNULL_END