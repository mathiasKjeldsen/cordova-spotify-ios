#define SpotifyRemote_h
#import <Cordova/CDVPlugin.h>
@interface SpotifyRemote : NSObject

@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;
@property (nonatomic) NSString *eventCallbackId;
@property (nonatomic) NSString *emitEventCallbackId;

-(void) setCallbackId:(NSString *) callbackId;

-(void) setEmitEventCallbackId:(NSString *) emitEventCallbackId;

- (instancetype)initWithCommandDelegate: (id <CDVCommandDelegate>) commandDelegate;

+(instancetype)sharedInstance;

-(void)initializeAppRemote:(NSString*)accessToken playURI:(NSString*)uri;

-(void)playUri:(NSString*)uri;

-(void)pause;

-(void)resume;

@end
