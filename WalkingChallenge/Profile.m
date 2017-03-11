
#import "Profile.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation Profile
@synthesize name = _name;

- (void)update {
  FBSDKGraphRequest *request =
      [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                        parameters:@{
                                          @"fields" : @"name"
                                        }];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                        id result, NSError *error) {
    _name = result[@"name"];
    [self.delegate profileNameUpdated];
  }];
}
@end

