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
import FacebookLogin
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import HealthKit

class AppController {
  static let shared = AppController()

  var window: UIWindow?
  var navigation: UITabBarController = Navigation()

  func launch(_ app: UIApplication, with options: [UIApplication.LaunchOptionsKey: Any]?, in window: UIWindow?) {
    self.window = window

    // Facebook SDK Setup
    ApplicationDelegate.shared.application(app, didFinishLaunchingWithOptions: options)

    // AppCenter Setup
    MSAppCenter.start(AppConfig.appCenterSecret, withServices: [
      MSAnalytics.self,
      MSCrashes.self
    ])

    // Setup Telemetry
    AppEvents.activateApp()

    // Setup Window
    window?.frame = UIScreen.main.bounds
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()

    // Select Default View
    // TODO(samisuteria) add check for akf profile?
    if Facebook.id.isEmpty {
      transition(to: .login)
    } else if !UserInfo.onboardingComplete {
      transition(to: .onboarding)
    } else {
      transition(to: .navigation)
    }

    healthCheckHealth()
    healthCheckServer()
  }

  func can(_ app: UIApplication, open url: URL, with options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    return ApplicationDelegate.shared.application(
      app,
      open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options)
  }

  enum ViewController {
    case login
    case akf
    case onboarding
    case navigation

    var viewController: UIViewController {
      switch self {
      case .login:
        // Rebuild navigation so data is wiped on logout
        AppController.shared.navigation = Navigation()
        return LoginViewController()
      case .akf: return AKFLoginViewController()
      case .onboarding: return OnboardingViewController()
      case .navigation: return AppController.shared.navigation
      }
    }
  }

  func onAKFLoginCompleted() {
    if !UserInfo.onboardingComplete {
      AppController.shared.transition(to: .onboarding)
    } else {
      AppController.shared.transition(to: .navigation)
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
    // TODO: Add check to go to akf sign up form 
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

  private func healthCheckHealth() {
    if UserInfo.pedometerSource == .healthKit {
      if HKHealthStore.isHealthDataAvailable() {
        switch HKHealthStore().authorizationStatus(for: ConnectSourceViewController.steps) {
        case .notDetermined:
          return
        case .sharingAuthorized:
          UserInfo.pedometerSource = .healthKit
          return
        case .sharingDenied:
          fallthrough
        @unknown default:
          break
        }
      }
    }
  }

  private func updateRecords() {
    guard let pedometer = UserInfo.pedometerSource else { return }

    let group: DispatchGroup = DispatchGroup()

    var sourceName: String?
    var source: Source?
    var provider: PedometerDataProvider?

    switch pedometer {
    case .fitbit:
      provider = FitbitDataProvider()
      sourceName = "Fitbit"
    case .healthKit:
      provider = HealthKitDataProvider()
      sourceName = "HealthKit"
    }

    guard let name = sourceName else { return }

    group.enter()
    AKFCausesService.getSourceByName(source: name) { (result) in
      source = Source(json: result.response)
      group.leave()
    }
    group.wait()

    guard let sourceID = source?.id else { return }

    AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
      if let participant = Participant(json: result.response), let participantId = participant.id {
        guard let start = (participant.records?.sorted { $0.date! < $1.date! }.last?.date // swiftlint:disable:this force_unwrapping line_length
                            ?? participant.currentEvent?.challengePhase.start) else { return }

        guard start < Date(timeIntervalSinceNow: 0) else { return }

        let interval: DateInterval = DateInterval(start: start, end: Date.init(timeIntervalSinceNow: 0))

        provider?.retrieveStepCount(forInterval: interval) { (result) in
          switch result {
          case .failure(let error):
            print("unable to query pedometer: \(error)")
          case .success(let steps):
            AKFCausesService.createRecord(for: participantId, dated: interval.end,
                                          steps: steps, sourceID: sourceID)
          }
        }
      }
    }
  }

  private func healthCheckServer() {
    AKFCausesService.performAPIHealthCheck { (result) in
      switch result {
      case .failed:
        let loginManager = LoginManager()
        loginManager.logOut()
        self.transition(to: .login)
        if let view = self.window?.rootViewController {
          let alert = AlertViewController()
          alert.title = Strings.AKFCausesServiceError.unableToConnect
          alert.add(.okay())
          self.present(alert: alert, in: view, completion: nil)
        }
      case .success:
        onBackground {
          self.updateRecords()
        }
      }
    }
  }

  func shareTapped(viewController: UIViewController, shareButton: UIButton?, string: String) {
    let activityItems: [Any] = [string]

    let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    activityVC.popoverPresentationController?.sourceView = shareButton
    viewController.present(activityVC, animated: true, completion: nil)
  }
}
