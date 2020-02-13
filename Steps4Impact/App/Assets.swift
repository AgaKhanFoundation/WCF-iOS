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

enum Assets: String {

  // UI
  case gear = "GearIcon"
  case disclosure = "BlueBackButton"
  case close = "close"
  case checkmark = "checkmark"
  case chevronRight = "chevron_right"
  case chevronLeft = "chevron_left"

  // Challenge
  case challengeJourney = "challenge-journey"
  case inviteFriends = "invite-friends"
  case inviteSupporters = "invite-supporters"

  // Logos
  case AKFLogo = "AKFLogo"
  case logo = "logo"

  // Navigation Bar
  case backIcon = "back-icon"

  // Badges
  case badgeIcon = "badge_icon"

  // Onboarding
  case onboardingLoginPeople = "login-couple"
  case onboardingCreateTeam = "create-team"
  case onboardingJourney = "journey"
  case onboardingDashboard = "dashboard"

  // Leaderboard
  case leaderboardEmpty = "leaderboard-empty"

  // Journey
  case journeyEmpty = "journey_map_test"
  case journeyDetailMock = "journeyDetailMock"

  // Tab Bar
  case tabbarDashboardSelected = "tabbar-dashboard-selected"
  case tabbarDashboardUnselected = "tabbar-dashboard-unselected"
  case tabbarChallengeSelected = "tabbar-challenge-selected"
  case tabbarChallengeUnselected = "tabbar-challenge-unselected"
  case tabbarLeaderboardSelected = "tabbar-leaderboard-selected"
  case tabbarLeaderboardUnselected = "tabbar-leaderboard-unselected"
  case tabbarNotificationsSelected = "tabbar-notifications-selected"
  case tabbarNotificationsUnselected = "tabbar-notifications-unselected"

  case circumflex = "circumflex"
  case invertedCircumflex = "inverted-circumflex"

  case uploadImageIcon = "uploadImageIcon"

  case placeholder

  var image: UIImage? {
    switch self {
    case .disclosure:
      return UIImage(named: self.rawValue)?.withHorizontallyFlippedOrientation()
    case .placeholder:
      return UIImage(color: Style.Colors.FoundationGreen)
    default:
      return UIImage(named: self.rawValue)
    }
  }
}

enum BadgesAssets {
  case dailyStreak(count: Int)
  case personalProgress(miles: Int)
  case steps(count: Int)
  case teamProgress(progress: Int)
  case finalMedal(level: String)

  public var rawValue: String {
    switch self {
    case .dailyStreak(let count):
      return "dailyStreak\(count)"
    case .personalProgress(let miles):
      return "\(miles)mi"
    case .steps(let steps):
      return "\(steps)steps"
    case .teamProgress(let progress):
      return "\(progress)progress"
    case .finalMedal(let level):
      return "\(level)"
    }
  }

  var image: UIImage? {
    return UIImage(named: self.rawValue)
  }
}
