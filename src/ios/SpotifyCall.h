#define SpotifyCall_h
#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyCall : CDVPlugin

-(void)initialize:(CDVInvokedUrlCommand*)command;

-(void)test:(NSString*)callbackId;

@end

NS_ASSUME_NONNULL_END
