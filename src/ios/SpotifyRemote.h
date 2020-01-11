#define SpotifyRemote_h

@interface SpotifyRemote : NSObject

+(instancetype)sharedInstance;

-(void)initializeAppRemote:(NSString*)accessToken playURI:(NSString*)uri;

-(void)playUri:(NSString*)uri;

@end
