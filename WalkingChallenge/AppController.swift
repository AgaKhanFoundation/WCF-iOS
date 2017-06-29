/**
 * Copyright © 2017 Aga Khan Foundation
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

class AppController {
  static let shared = AppController()

  var window: UIWindow?
  var tabBarController = UITabBarController()

  func launch(in window: UIWindow?) {
    self.window = window

    configureApp()
    healthCheckServer()
    uploadHealthKitData()
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

    UIView.transition(with: window, duration: 0.3,
                      options: .transitionCrossDissolve,
                      animations: {
                        window.rootViewController = viewController.viewController
                      },
                      completion: nil)
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

    if Facebook.id.isEmpty {
      transition(to: .login)
    } else {
      transition(to: .tabBar)
    }
  }

  private func configureTabBarController() {
    let leaderboardNVC =
        UINavigationController(rootViewController: LeaderboardViewController())
    leaderboardNVC.tabBarItem =
        UITabBarItem(title: Strings.NavBarTitles.leaderboard, image: nil,
                     selectedImage: nil)

    let profile =
        UINavigationController(rootViewController: ProfileViewController())
    profile.tabBarItem =
        UITabBarItem(title: Strings.NavBarTitles.profile,
                     image: UIImage(imageLiteralResourceName: "person"),
                     selectedImage: nil)

    let events =
        UINavigationController(rootViewController: EventsViewController())
    events.tabBarItem =
        UITabBarItem(title: Strings.NavBarTitles.events,
                     image: UIImage(imageLiteralResourceName: "event"),
                     selectedImage: nil)

    tabBarController.viewControllers = [ profile, events, leaderboardNVC ]
  }

  private func configureWindow() {
    window?.frame = UIScreen.main.bounds
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()
  }

  private func configureAnalytics() {
    AppEventsLogger.activate()
  }

  fileprivate func healthCheckServer() {
    AKFCausesService.performAPIHealthCheck { (result) in
      switch result {
      case .failed(let error):
        print("error: \(String(describing: error?.localizedDescription))")
        break
      case .success(_, _):
        break
      }
    }
  }

  fileprivate func uploadHealthKitData() {
    AKFCausesService.getParticipant(fbid: Facebook.id) { (result) in
      switch result {
      case .success(_, let response):
        guard let response = response else { return }
        let participant = Participant(json: response)
        let lastDate = participant?.lastRecordDate() ?? Date.init(timeIntervalSince1970: 0)
          let dateInterval = DateInterval.init(start: lastDate, end: Date())
          let provider = HealthKitDataProvider.init()
          provider.retrieveStepCountForDateRange(dateInterval, { (distance) in
            var sourceDict:[String:Any] = Dictionary()
            sourceDict["id"] = 1
            sourceDict["name"] = "healthKit"
            let sourceJSON = JSON(sourceDict)
            let source = Source.init(json: sourceJSON!)
            
            var recordDict:[String:Any] = Dictionary()
            recordDict["date"] = Date()
            recordDict["distance"] = distance
            recordDict["participant_id"] = Facebook.id
            recordDict["source"] = source
            let recordJSON = JSON(recordDict)
            let record = Record.init(json: recordJSON!)
            
            if let record = record {
              AKFCausesService.createRecord(record: record)
            }
          })
        break
      case .failed(let error):
        print("unable to get participant: \(String(describing: error?.localizedDescription))")
        break
      }
    }
  }
 
}
