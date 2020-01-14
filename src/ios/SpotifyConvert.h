#import <SpotifyiOS/SpotifyiOS.h>

@interface SpotifyConvert : NSObject

+(id)SPTAppRemotePlayerState:(NSObject<SPTAppRemotePlayerState>*) state;
+(id)SPTAppRemotePlaybackRestrictions:(NSObject<SPTAppRemotePlaybackRestrictions>*) restrictions;
+(id)SPTAppRemotePlaybackOptions:(NSObject<SPTAppRemotePlaybackOptions>*) options;
+(id)SPTAppRemoteTrack:(NSObject<SPTAppRemoteTrack> *) track;
+(id)SPTAppRemoteContentItem:(NSObject<SPTAppRemoteContentItem> *) item;

@end
