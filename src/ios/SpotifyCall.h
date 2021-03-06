#define SpotifyCall_h
#import <Cordova/CDVPlugin.h>
#import "SpotifyiOSHeaders.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpotifyCall : CDVPlugin

@property(nonatomic) SpotifyiOS *spotifyiOS;
@property(nonatomic) SpotifyRemote *spotifyRemote;

+(SpotifyCall*)sharedInstance;

-(void)initialize:(CDVInvokedUrlCommand*)command;
-(void)initAndPlay:(CDVInvokedUrlCommand*)command;
-(void)connect:(CDVInvokedUrlCommand*)command;
-(void)getToken:(CDVInvokedUrlCommand*)command;
-(void)isSpotifyAppInstalled:(CDVInvokedUrlCommand*)command;
-(void)playURI:(CDVInvokedUrlCommand*)command;
-(void)queueURI:(CDVInvokedUrlCommand*)command;
-(void)pause:(CDVInvokedUrlCommand*)command;
-(void)resume:(CDVInvokedUrlCommand*)command;
-(void)seek:(CDVInvokedUrlCommand*)command;
-(void)playPlaylist:(CDVInvokedUrlCommand*)command;
-(void)isAppRemoteConnected:(CDVInvokedUrlCommand*)command;
-(void)authAndPlay:(CDVInvokedUrlCommand*)command;
-(void)contentLinking:(CDVInvokedUrlCommand*)command;
@end

NS_ASSUME_NONNULL_END
