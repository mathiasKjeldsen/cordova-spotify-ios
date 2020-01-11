#import "SpotifyCall.h"
#import "SpotifyiOSHeaders.h"

@interface SpotifyCall () 

@end

@implementation SpotifyCall

- (void)initialize:(CDVInvokedUrlCommand*)command {
   return [[SpotifyiOS sharedInstance] initialize:command.arguments[0] callbackId:command.callbackId];
}

- (void)doConnect:(CDVInvokedUrlCommand*)command {
    return [[SpotifyRemote sharedInstance] initializeAppRemote:command.arguments[0]];
}

- (void) getToken:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                               messageAsString:  [[SpotifyiOS sharedInstance] accessToken]];

    return [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];
}


@end
