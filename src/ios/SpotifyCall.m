#import "SpotifyCall.h"
#import "SpotifyiOSHeaders.h"

@interface SpotifyCall () 

@end

@implementation SpotifyCall

- (void)initialize:(CDVInvokedUrlCommand*)command {
    [[SpotifyiOS sharedInstance] initialize:command.arguments[0] callbackId:command.callbackId];

    /*CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                               messageAsString: nil];

    [self.commandDelegate sendPluginResult: result callbackId: command.callbackId];*/
}

- (void)doConnect:(CDVInvokedUrlCommand*)command {
    return [[SpotifyRemote sharedInstance] initializeAppRemote:command.arguments[0]];
}

- (void) test:(NSString*)callbackId {
    NSLog(@"TEST: %@", callbackId);
    CDVPluginResult *result = [CDVPluginResult
            resultWithStatus: CDVCommandStatus_OK
                               messageAsString: @"hi there my guy"];

    return [self.commandDelegate sendPluginResult: result callbackId: callbackId];
}


@end
