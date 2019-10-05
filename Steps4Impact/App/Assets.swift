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

  // Challenge
  case challengeJourney = "challenge-journey"
  case inviteFriends = "invite-friends"
  case inviteSupporters = "invite-supporters"

  // Logos
  case AKFLogo = "AKFLogo"
  case logo = "logo"

  // Onboarding
  case onboardingLoginPeople = "login-couple"
  case onboardingCreateTeam = "create-team"
  case onboardingJourney = "journey"
  case onboardingDashboard = "dashboard"

  // Leaderboard
  case leaderboardEmpty = "leaderboard-empty"

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
