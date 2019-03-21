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
      UINavigationController(rootViewController: Dashboard())
  private let challenge: UINavigationController =
      UINavigationController(rootViewController: Challenge())
  private let leaderboard: UINavigationController =
      UINavigationController(rootViewController: Leaderboard())
  private let notifications: UINavigationController =
      UINavigationController(rootViewController: Notifications())

  init() {
    super.init(nibName: nil, bundle: nil)

    self.dashboard.tabBarItem =
        UITabBarItem(title: Strings.Navigation.dashboard,
                     image: #imageLiteral(resourceName: Assets.DashboardUnselected),
                     selectedImage: #imageLiteral(resourceName: Assets.DashboardSelected))
    self.challenge.tabBarItem =
        UITabBarItem(title: Strings.Navigation.challenge,
                     image: #imageLiteral(resourceName: Assets.ChallengeUnselected),
                     selectedImage: #imageLiteral(resourceName: Assets.ChallengeSelected))
    self.leaderboard.tabBarItem =
        UITabBarItem(title: Strings.Navigation.leaderboard,
                     image: #imageLiteral(resourceName: Assets.LeaderboardUnselected),
                     selectedImage: #imageLiteral(resourceName: Assets.LeaderboardSelected))
    self.notifications.tabBarItem =
        UITabBarItem(title: Strings.Navigation.notifications,
                     image: #imageLiteral(resourceName: Assets.NotificationsUnselected),
                     selectedImage: #imageLiteral(resourceName: Assets.NotificationsSelected))

    self.viewControllers = [dashboard, challenge, leaderboard, notifications]
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}