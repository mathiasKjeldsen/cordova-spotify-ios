//
//  SpotifyiOSController.h
//  soundseek-party
//
//  Created by Mathias Kjeldsen on 10/01/2020.
//
#ifndef SpotifyiOSController_h
#define SpotifyiOSController_h

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVInvokedUrlCommand.h>

@interface SpotifyiOSController : CDVPlugin {}

- (void) pluginInitialize:(CDVInvokedUrlCommand*)command;

- (void) execute:(CDVInvokedUrlCommand*)command;

@end


#endif /* SpotifyiOSController_h */
