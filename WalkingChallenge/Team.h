
#ifndef WalkingChallenge_WalkingChallenge_Team_h
#define WalkingChallenge_WalkingChallenge_Team_h

#import <Foundation/Foundation.h>

@protocol TeamUpdateDelegate
@required
- (void)teamNameUpdated;
- (void)teamMembersUpdated;
@end

@interface Team : NSObject
@property(readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) NSArray<NSString *> *members;
@property(weak, nonatomic) id<TeamUpdateDelegate> delegate;
- (void)update;
@end

#endif


