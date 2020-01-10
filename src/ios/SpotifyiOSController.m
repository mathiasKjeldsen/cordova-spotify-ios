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

- (void) execute:(CDVInvokedUrlCommand*)command {
    self.rootViewController = [[SpotifyiOS alloc] init];
    [self.rootViewController runAuth]
}

@end


