#import "SpotifyCall.h"
#import "SpotifyiOSHeaders.h"

@interface SpotifyCall () 

@end

@implementation SpotifyCall

- (void)initialize:(CDVInvokedUrlCommand*)command {
    [[SpotifyiOS sharedInstance] initialize:command.arguments[0]];

    /*CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                               messageAsString: nil];

    [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];*/
}

- (void)doConnect:(CDVInvokedUrlCommand*)command {
    return [[SpotifyRemote sharedInstance] initializeAppRemote withOptions:command.arguments[0]];
}


@end