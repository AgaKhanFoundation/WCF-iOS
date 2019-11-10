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
import Foundation

class Navigation: UITabBarController {
  private let dashboard: UINavigationController =
      NavigationController(rootVC: DashboardViewController())
  private let challenge: UINavigationController =
      NavigationController(rootVC: ChallengeViewController())
  private let leaderboard: UINavigationController =
      NavigationController(rootVC: LeaderboardViewController())
  private let notifications: UINavigationController =
      NavigationController(rootVC: NotificationsViewController())

  init() {
    super.init(nibName: nil, bundle: nil)

    self.dashboard.tabBarItem =
        UITabBarItem(title: Strings.Navigation.dashboard,
                     image: Assets.tabbarDashboardUnselected.image,
                     selectedImage: Assets.tabbarDashboardSelected.image)
    self.challenge.tabBarItem =
        UITabBarItem(title: Strings.Navigation.challenge,
                     image: Assets.tabbarChallengeUnselected.image,
                     selectedImage: Assets.tabbarChallengeSelected.image)
    self.leaderboard.tabBarItem =
        UITabBarItem(title: Strings.Navigation.leaderboard,
                     image: Assets.tabbarLeaderboardUnselected.image,
                     selectedImage: Assets.tabbarLeaderboardSelected.image)
    self.notifications.tabBarItem =
        UITabBarItem(title: Strings.Navigation.notifications,
                     image: Assets.tabbarNotificationsUnselected.image,
                     selectedImage: Assets.tabbarNotificationsSelected.image)

    // FIXME(compnerd) enumerate the notifications
    self.notifications.tabBarItem.badgeValue = "0"
    AppController.shared.askForPushNotificationPermissions()

    self.viewControllers = [dashboard, challenge, leaderboard, notifications]
  
    NotificationCenter.default.addObserver(forName: .receivedNotification, object: nil, queue: nil) { [weak self] (notification) in
      guard let this = self else { return }
      let oldValue = Int(this.notifications.tabBarItem.badgeValue ?? "0") ?? 0
      this.notifications.tabBarItem.badgeValue = String(oldValue + 1)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
