#import "SpotifyCall.h"
#import "SpotifyiOSHeaders.h"

static SpotifyCall *sharedInstance = nil;


@interface SpotifyCall ()

@end

@implementation SpotifyCall

- (void) pluginInitialize {
    __weak id <CDVCommandDelegate> _commandDelegate = self.commandDelegate;
    self.spotifyiOS = [[SpotifyiOS sharedInstance] initWithCommandDelegate:_commandDelegate];
}

+ (SpotifyCall *)sharedInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedInstance = [[SpotifyCall alloc] init];
    });
    return sharedInstance;
}


- (void)initialize:(CDVInvokedUrlCommand*)command {
    NSLog(@"%@", command.callbackId);
    [[SpotifyiOS sharedInstance] setCallbackId:command.callbackId];
    [[SpotifyiOS sharedInstance] initialize:command.arguments[0] callbackId:command.callbackId];
}

- (void)doConnect:(CDVInvokedUrlCommand*)command {
    return [[SpotifyRemote sharedInstance] initializeAppRemote:command.arguments[0] playURI:command.arguments[1]];
}

- (void) getToken:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                               messageAsString: [[SpotifyiOS sharedInstance] accessToken]];

    return [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
}


@end
