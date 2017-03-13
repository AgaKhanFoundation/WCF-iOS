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
    
    enum ViewController {
        case login
        case tabBar
        
        var viewController: UIViewController {
            switch self {
            case .login: return LoginViewController()
            case .tabBar: return AppController.shared.tabBarController
            }
        }
    }
    
    func transition(to viewController: ViewController) {
        guard let window = window else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: { 
            window.rootViewController = viewController.viewController
        }, completion: nil)
    }
    
    func login() {
        transition(to: .tabBar)
    }
    
    func logout() {
        transition(to: .login)
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
