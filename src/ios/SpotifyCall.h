#define SpotifyCall_h
#import <Cordova/CDVPlugin.h>
#import "SpotifyiOSHeaders.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpotifyCall : CDVPlugin

@property(nonatomic) SpotifyiOS *spotifyiOS;

+(SpotifyCall*)sharedInstance;

-(void)initialize:(CDVInvokedUrlCommand*)command;

-(void)doConnect:(CDVInvokedUrlCommand*)command;

-(void)getToken:(CDVInvokedUrlCommand*)command;

@end

NS_ASSUME_NONNULL_END
