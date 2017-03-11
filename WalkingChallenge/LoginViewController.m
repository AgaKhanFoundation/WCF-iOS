
#import "LoginViewController.h"
#import "RootViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController () <FBSDKLoginButtonDelegate> {
  FBSDKLoginButton *_loginButton;
}
@end

@implementation LoginViewController
- (instancetype)init {
  if (self = [super init]) {
    _loginButton = [FBSDKLoginButton new];
    _loginButton.delegate = self;
    _loginButton.readPermissions =
        @[ @"public_profile", @"email", @"user_friends" ];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _loginButton.center = self.view.center;

  [self.view addSubview:_loginButton];
  self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark FBSDKLoginButtonDelegate methods

- (void)loginButton:(FBSDKLoginButton *)loginButton
    didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                    error:(NSError *)error {
  if (!error)
    [self.delegate loginDidSucceed];
  else
    NSLog(@"unable to authenticate: %@", error);
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
}
@end
