import UIKit
import FBSDKCoreKit

class AppController {
    
    static let shared = AppController()
    
    var window: UIWindow?
    
    var tabBarController = UITabBarController()
    
    func launch(in window: UIWindow?) {
        self.window = window
        
        configureApp()
    }
}

// MARK: - Configuration
extension AppController {
    
    fileprivate func configureApp() {
        configureAnalytics()
        configureTabBarController()
        configureWindow()
    private func configureTabBarController() {
        let profileNVC = UINavigationController(rootViewController: ProfileViewController())
        let teamNVC = UINavigationController(rootViewController: TeamViewController())
        let sponsorNVC = UINavigationController(rootViewController: SponsorViewController())
        
        tabBarController.viewControllers = [
            profileNVC, teamNVC, sponsorNVC
        ]
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
