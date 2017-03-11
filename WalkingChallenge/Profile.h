
#ifndef WalkingChallenge_WalkingChallenge_Profile_h
#define WalkingChallenge_WalkingChallenge_Profile_h

#import <Foundation/Foundation.h>

@protocol ProfileUpdateDelegate
@required
- (void)profileNameUpdated;
@end

@interface Profile : NSObject
@property(readonly, nonatomic) NSString *name;
@property(weak, nonatomic) id<ProfileUpdateDelegate> delegate;
- (void)update;
@end

#endif

