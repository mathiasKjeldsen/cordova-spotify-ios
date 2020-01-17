#define SpotifyRemote_h
#import <Cordova/CDVPlugin.h>
@interface SpotifyRemote : NSObject

@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;
@property (nonatomic) NSString *eventCallbackId;

-(void) setCallbackId:(NSString *) callbackId;

- (instancetype)initWithCommandDelegate: (id <CDVCommandDelegate>) commandDelegate;

+(instancetype)sharedInstance;

-(void)initializeAppRemote:(NSString*)accessToken playURI:(NSString*)uri;
-(BOOL)isConnected;
-(void)playUri:(NSString*)uri;
-(void)getPlaylistAndPlay:(NSString*)uri index:(NSInteger)index;
-(void)queueUri:(NSString*)uri;
-(void)seek:(NSInteger)position;
-(void)pause;
-(void)resume;
-(void)getPlayerState;
@end
