#import "SpotifyConvert.h"

@interface SpotifyConvert ()

@end

@implementation SpotifyConvert



+(id)SPTAppRemotePlayerState:(NSObject<SPTAppRemotePlayerState>*) state{
    if(state == nil)
    {
        return [NSNull null];
    }
    return @{
        @"track": [SpotifyConvert SPTAppRemoteTrack:state.track],
        @"playbackPosition": [NSNumber numberWithInteger:state.playbackPosition],
        @"playbackSpeed": [NSNumber numberWithFloat:state.playbackSpeed],
        @"paused": [NSNumber numberWithBool:state.isPaused],
        @"playbackRestrictions": [SpotifyConvert SPTAppRemotePlaybackRestrictions:state.playbackRestrictions],
        @"playbackOptions": [SpotifyConvert SPTAppRemotePlaybackOptions:state.playbackOptions]
    };
}


+(id)SPTAppRemotePlaybackRestrictions:(NSObject<SPTAppRemotePlaybackRestrictions>*) restrictions{
    if(restrictions == nil){
        return [NSNull null];
    }
    
    return @{
         @"canSkipNext": [NSNumber numberWithBool:restrictions.canSkipNext],
         @"canSkipPrevious": [NSNumber numberWithBool:restrictions.canSkipPrevious],
         @"canRepeatTrack": [NSNumber numberWithBool:restrictions.canRepeatTrack],
         @"canRepeatContext": [NSNumber numberWithBool:restrictions.canRepeatContext],
         @"canToggleShuffle": [NSNumber numberWithBool:restrictions.canToggleShuffle],
     };
}

+(id)SPTAppRemotePlaybackOptions:(NSObject<SPTAppRemotePlaybackOptions>*) options{
    if(options == nil){
        return [NSNull null];
    }
    return @{
      @"isShuffling": [NSNumber numberWithBool:options.isShuffling],
      @"repeatMode": [NSNumber numberWithUnsignedInteger:options.repeatMode],
    };
}


+(id)SPTAppRemoteTrack:(NSObject<SPTAppRemoteTrack>*) track{
    if(track == nil){
        return [NSNull null];
    }
    return @{
             @"name": track.name,
             @"uri":track.URI,
             @"duration":[NSNumber numberWithUnsignedInteger:track.duration],
             @"artist":[SpotifyConvert SPTAppRemoteArtist:track.artist],
             @"album":[SpotifyConvert SPTAppRemoteAlbum:track.album]
    };
}

@end