
#import "Team.h"

@implementation Team
@synthesize name = _name;
@synthesize members = _members;

- (void)update {
  // TODO(compnerd) fetch team name from backend
  _name = @"Team Name";
  [self.delegate teamNameUpdated];

  // TODO(compnerd) fetch team members from backend
  _members = @[ @"Team Member 1", @"Team Member 2", @"Team Member 3" ];
  [self.delegate teamMembersUpdated];
}

@end


