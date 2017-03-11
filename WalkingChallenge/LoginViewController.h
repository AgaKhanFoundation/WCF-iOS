
#ifndef WalkingChallenge_WalkingChallenge_LoginViewController_h
#define WalkingChallenge_WalkingChallenge_LoginViewController_h

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate
@required
- (void)loginDidSucceed;
@end

@interface LoginViewController : UIViewController
@property(weak, nonatomic) id<LoginViewControllerDelegate> delegate;
@end

#endif

