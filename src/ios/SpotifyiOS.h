#define SpotifyiOS_h
@import UIKit;
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyiOS : UIViewController <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

//- (void) pluginInitialize;
- (void) runAuth;
- (void) sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session;
- (void) sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session;
- (void) sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error;
- (BOOL) sessionManager:(SPTSessionManager *)manager shouldRequestAccessTokenWithAuthorizationCode:(SPTAuthorizationCode)code;

@end

NS_ASSUME_NONNULL_END
