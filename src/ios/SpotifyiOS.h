#ifndef SpotifyiOS_h
#define SpotifyiOS_h

#import <SpotifyiOS/SpotifyiOS.h>
#import <Cordova/CDVPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyiOS: CDVPlugin <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

- (void) pluginInitialize;
- (void) run:(CDVInvokedUrlCommand*)command;

@end

NS_ASSUME_NONNULL_END