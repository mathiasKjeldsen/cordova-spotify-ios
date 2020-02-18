#import "SpotifyCall.h"
#import "SpotifyiOSHeaders.h"

static SpotifyCall *sharedInstance = nil;


@interface SpotifyCall ()

@end

@implementation SpotifyCall

- (void) pluginInitialize {
    __weak id <CDVCommandDelegate> _commandDelegate = self.commandDelegate;
    self.spotifyiOS = [[SpotifyiOS sharedInstance] initWithCommandDelegate:_commandDelegate];
    self.spotifyRemote = [[SpotifyRemote sharedInstance] initWithCommandDelegate:_commandDelegate];

}

+ (SpotifyCall *)sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedInstance = [[SpotifyCall alloc] init];
    });
    return sharedInstance;
}

- (void)isAppRemoteConnected:(CDVInvokedUrlCommand*)command {  
    CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                                   messageAsBool:[[SpotifyRemote sharedInstance] isConnected]];

    return [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
}

- (void)initialize:(CDVInvokedUrlCommand*)command {
    [[SpotifyiOS sharedInstance] setCallbackId:command.callbackId];
    [[SpotifyiOS sharedInstance] initialize:command.arguments[0]];
}

- (void)initAndPlay:(CDVInvokedUrlCommand*)command {
    [[SpotifyiOS sharedInstance] setCallbackId:command.callbackId];
    [[SpotifyiOS sharedInstance] initAndPlay:command.arguments[0]];
}

- (void)connect:(CDVInvokedUrlCommand*)command {
    [[SpotifyRemote sharedInstance] setCallbackId:command.callbackId];
    return [[SpotifyRemote sharedInstance] connectAppRemote];
}

- (void) getToken:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                                   messageAsString:[[SpotifyiOS sharedInstance] accessToken]];

    return [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
}

- (void) isSpotifyAppInstalled:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                                   messageAsBool:[[SpotifyiOS sharedInstance] isSpotifyAppInstalled]];

    return [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
}

- (void) playURI:(CDVInvokedUrlCommand*)command {
    [[SpotifyRemote sharedInstance] setCallbackId:command.callbackId];
    return [[SpotifyRemote sharedInstance] playUri:command.arguments[0]];
}

- (void) queueURI:(CDVInvokedUrlCommand*)command {
    [[SpotifyRemote sharedInstance] setCallbackId:command.callbackId];
    return [[SpotifyRemote sharedInstance] queueUri:command.arguments[0]];
}

- (void) pause:(CDVInvokedUrlCommand*)command {
    [[SpotifyRemote sharedInstance] setCallbackId:command.callbackId];
    return [[SpotifyRemote sharedInstance] pause];
}

- (void) resume:(CDVInvokedUrlCommand*)command {
    [[SpotifyRemote sharedInstance] setCallbackId:command.callbackId];
    return [[SpotifyRemote sharedInstance] resume];
}

- (void) seek:(CDVInvokedUrlCommand*)command {
    [[SpotifyRemote sharedInstance] setCallbackId:command.callbackId];
    NSInteger pos = [command.arguments[0] intValue];
    return [[SpotifyRemote sharedInstance] seek:pos];
}

- (void) playPlaylist:(CDVInvokedUrlCommand*)command {
    [[SpotifyRemote sharedInstance] setCallbackId:command.callbackId];
    NSInteger index = [command.arguments[1] intValue];
    return [[SpotifyRemote sharedInstance] getPlaylistAndPlay:command.arguments[0] index:index];
}

@end
