
#import "ProfileViewController.h"
#import "RootViewController.h"
#import "Profile.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString *kLogoutString = @"Logout";
static const float kNameFontSize = 32.0f;

@interface ProfileViewController () <ProfileUpdateDelegate,
                                     FBSDKLoginButtonDelegate> {
  UILabel *_name;
  FBSDKLoginButton *_logoutButton;
}
@end

@implementation ProfileViewController
- (instancetype)init {
  if (self = [super init]) {
    _profile = [Profile new];
    _profile.delegate = self;

    _name = [UILabel new];

    _logoutButton = [FBSDKLoginButton new];
    _logoutButton.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  _name.font = [UIFont boldSystemFontOfSize:kNameFontSize];
  // TODO(compnerd) use auto-layout constraints
  _name.frame = CGRectMake(self.view.frame.origin.x, 32.0f,
                           self.view.frame.size.width, 40.0f);
  _name.textAlignment = NSTextAlignmentCenter;

  // TODO(comperd) use auto-layout constraints
  CGRect buttonFrame = _logoutButton.frame;
  CGRect viewFrame = self.view.frame;
  _logoutButton.frame =
      CGRectMake((viewFrame.size.width - buttonFrame.size.width) / 2,
                 viewFrame.size.height - 56.0f - buttonFrame.size.height,
                 buttonFrame.size.width, buttonFrame.size.height);

  [self.view addSubview:_name];
  [self.view addSubview:_logoutButton];

  self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark ProfileUpdateDelegate methods

- (void)profileNameUpdated {
  _name.text = self.profile.name;
}

#pragma mark FBSDKLoginButtonDelegate methods

- (void)loginButton:(FBSDKLoginButton *)loginButton
    didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                    error:(NSError *)error {
  NSLog(@"login should have already occurred");
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  _profile = nil;
  // TODO(compnerd) do this more cleanly -- we shouldn't have to go digging
  RootViewController *controller =
      (RootViewController *)[[UIApplication sharedApplication] keyWindow]
          .rootViewController;
  [controller showLoginView];
}
@end

