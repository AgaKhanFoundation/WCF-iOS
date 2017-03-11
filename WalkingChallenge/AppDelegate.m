
#import "AppDelegate.h"
#import "RootViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate () {
  FBSDKApplicationDelegate *_facebook;
  UIWindow *_window;
}
@end

@implementation AppDelegate
- (instancetype)init {
  if (self = [super init])
    _facebook = [FBSDKApplicationDelegate sharedInstance];
  return self;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
                (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {

  return [_facebook
            application:application
                openURL:url
      sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
             annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [_facebook application:application
      didFinishLaunchingWithOptions:launchOptions];

  _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  _window.rootViewController = [RootViewController new];
  [_window makeKeyAndVisible];
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
}
@end
