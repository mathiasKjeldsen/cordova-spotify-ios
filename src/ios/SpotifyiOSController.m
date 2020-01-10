//
//  SpotifyiOSController.m
//  soundseek-party
//
//  Created by Mathias Kjeldsen on 10/01/2020.
//

#import <Foundation/Foundation.h>
#import "SpotifyiOSController.h"
#import "SpotifyiOS.h"

@interface SpotifyiOSController ()

@property(nonatomic, strong) SpotifyiOS *rootViewController;

@end

@implementation SpotifyiOSController

- (void) pluginInitialize: (CDVInvokedUrlCommand*)command {
    NSLog(@"PLUGIN INIT");
    self.rootViewController = [[SpotifyiOS alloc] init];
}

- (void) execute:(CDVInvokedUrlCommand*)command {
    NSLog(@"EXECUTE RECEIVED");
    [self.rootViewController runAuth];
}

@end


