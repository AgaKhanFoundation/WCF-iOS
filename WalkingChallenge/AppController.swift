import UIKit
import FBSDKCoreKit

class AppController {
    
    static let shared = AppController()
    
    var window: UIWindow?
    
    func launch(in window: UIWindow?) {
        self.window = window
        
        configureApp()
    }
}

// MARK: - Configuration
extension AppController {
    
    fileprivate func configureApp() {
        configureAnalytics()
        configureWindow()
    }
    
    private func configureWindow() {
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }
    
    private func configureAnalytics() {
        FBSDKAppEvents.activateApp()
    }
    
}
