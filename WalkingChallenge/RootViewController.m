
#import "RootViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "SponsorViewController.h"
#import "TeamViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString *kProfileTabTitle = @"Profile";
static NSString *kTeamTabTitle = @"Team";
static NSString *kSponsorTabTitle = @"Sponsors";

static NSInteger kProfileTabTag = 0;
static NSInteger kTeamTabTag = 1;
static NSInteger kSponsorTabTag = 2;

@interface RootViewController () <LoginViewControllerDelegate> {
  FBSDKAccessToken *_token;
  LoginViewController *_loginViewController;
  ProfileViewController *_profileViewController;
  TeamViewController *_teamViewController;
  SponsorViewController *_sponsorViewController;
  UITabBarController *_tabBarController;
}
@end

@implementation RootViewController
- (instancetype)init {
  if (self = [super init]) {
    _profileViewController = [ProfileViewController new];
    _profileViewController.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:kProfileTabTitle
                                      image:nil
                                        tag:kProfileTabTag];

    _teamViewController = [TeamViewController new];
    _teamViewController.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:kTeamTabTitle
                                      image:nil
                                        tag:kTeamTabTag];

    _sponsorViewController = [SponsorViewController new];
    _sponsorViewController.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:kSponsorTabTitle
                                      image:nil
                                        tag:kSponsorTabTag];

    _tabBarController = [UITabBarController new];
    _tabBarController.viewControllers = @[
      _profileViewController, _teamViewController, _sponsorViewController
    ];

    _token = [FBSDKAccessToken currentAccessToken];
    if (_token) {
      [_profileViewController.profile update];
      [_teamViewController.team update];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_tabBarController.view];

  [self addChildViewController:_tabBarController];
  [_tabBarController didMoveToParentViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
  if (_token == nil)
    [self showLoginView];
}

- (void)showLoginView {
  if (_loginViewController == nil) {
    _loginViewController = [LoginViewController new];
    _loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    _loginViewController.modalTransitionStyle =
        UIModalTransitionStyleCoverVertical;
    _loginViewController.delegate = self;
  }

  [self presentViewController:_loginViewController animated:YES completion:nil];
}

#pragma mark LoginViewControllerDelegate methods

- (void)loginDidSucceed {
  _token = [FBSDKAccessToken currentAccessToken];
  [_profileViewController.profile update];
  [_teamViewController.team update];
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
