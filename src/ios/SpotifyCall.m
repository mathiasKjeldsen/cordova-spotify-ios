#import "SpotifyCall.h"
#import "SpotifyiOSHeaders.h"

@interface SpotifyCall () 

@end

@implementation SpotifyCall

- (void)initialize:(CDVInvokedCommandURL*)command {
    return [[SpotifyiOS sharedInstance] initialize withOptions:command.arguments[0]];
}