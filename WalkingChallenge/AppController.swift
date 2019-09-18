/**
 * Copyright © 2019 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import UIKit
import FacebookCore
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

class AppController {
  static let shared = AppController()

  var window: UIWindow?
  var navigation: UITabBarController = Navigation()

  func launch(_ app: UIApplication, with options: [UIApplication.LaunchOptionsKey: Any]?, in window: UIWindow?) {
    self.window = window

    // Facebook SDK Setup
    SDKApplicationDelegate.shared.application(app, didFinishLaunchingWithOptions: options)

    // AppCenter Setup
    MSAppCenter.start(AppConfig.appCenterSecret, withServices: [
      MSAnalytics.self,
      MSCrashes.self
    ])

    // Setup Telemetry
    AppEventsLogger.activate()

    // Setup Window
    window?.frame = UIScreen.main.bounds
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()

    // Select Default View
    if Facebook.id.isEmpty {
      transition(to: .login)
    } else {
      transition(to: .navigation)
    }

    healthCheckServer()
  }

  func can(_ app: UIApplication, open url: URL, with options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    return SDKApplicationDelegate.shared.application(app, open: url, options: options)
  }

  enum ViewController {
    case login
    case onboarding
    case navigation

    var viewController: UIViewController {
      switch self {
      case .login: return LoginViewController()
      case .onboarding: return Onboarding()
      case .navigation: return AppController.shared.navigation
      }
    }
  }

  func transition(to viewController: ViewController) {
    guard let window = window else { return }

    UIView.transition(with: window, duration: 0.3,
                      options: .transitionCrossDissolve,
                      animations: {
                        window.rootViewController = viewController.viewController
                      },
                      completion: nil)
  }

  func login() {
    if !UserInfo.onboardingComplete {
      transition(to: .onboarding)
    } else {
      transition(to: .navigation)
    }
  }

  func logout() {
    transition(to: .login)
  }

  // Disable the following rule because something needs to keep a reference to the delegate
  // swiftlint:disable weak_delegate
  var alertDelegate: AlertModalTransitioningDelegate?

  func present(alert: AlertViewController, in viewController: UIViewController, completion: (() -> Void)?) {
    alertDelegate = AlertModalTransitioningDelegate()

    alert.modalPresentationStyle = .custom
    alert.transitioningDelegate = alertDelegate

    viewController.present(alert, animated: true, completion: completion)
  }

  private func healthCheckServer() {
    AKFCausesService.performAPIHealthCheck { (result) in
      switch result {
      case .failed:
        // TODO: Launch Blocker -- Add error handling
        self.transition(to: .login)
        if let view = self.window?.rootViewController {
          view.alert(message: Strings.Application.unableToConnect)
        }

      case .success:
        break
      }
    }
  }
}
