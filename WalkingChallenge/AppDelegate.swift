
import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  let appController = AppController.shared
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    // TODO: Eventually move this into AppController when other frameworks require setup
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

    window = UIWindow()
    appController.launch(in: window)

    return true
  }

  func application(_ app: UIApplication, open url: URL,
                   options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    // TODO: Eventually move this into AppController when other frameworks require setup
    return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
  }
}
