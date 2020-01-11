#define SpotifyRemote_h

@interface SpotifyRemote : NSObject

+(instancetype)sharedInstance;

-(void)initializeAppRemote:(NSString*)accessToken;

-(void)playUri:(NSString*)uri;

@end
