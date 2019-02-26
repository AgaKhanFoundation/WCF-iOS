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

import Foundation

struct Strings {
  struct Application {
    static let unableToConnect: String =
        NSLocalizedString("Unable to access AKF Causes at this time.  Please try again later.",
                          comment: "Unable to access AKF Causes at this time.  Please try again later.")
  }

  struct Navigation {
    static let dashboard: String =
        NSLocalizedString("Dashboard", comment: "Dashboard")
    static let challenge: String =
        NSLocalizedString("Challenge", comment: "Challenge")
    static let leaderboard: String =
        NSLocalizedString("Leaderboard", comment: "Leaderboard")
    static let notifications: String =
        NSLocalizedString("Notifications", comment: "Notifications")
  }

  struct Dashboard {
    static let title: String =
        NSLocalizedString("Dashboard", comment: "Dashboard")
  }

  struct ProfileCard {
    static let challengeTimeline: String =
        NSLocalizedString("Challenge Timeline", comment: "Challenge Timeline")

    static let team: String =
        NSLocalizedString("Team:", comment: "Team:")
  }

  struct ActivityCard {
    static let title: String =
        NSLocalizedString("Your Miles Walked", comment: "Your Miles Walked")

    static let joinChallenge: String =
        NSLocalizedString("Join Challenge", comment: "Join Challenge")

    static let daily: String =
        NSLocalizedString("Daily", comment: "Daily")
    static let weekly: String =
        NSLocalizedString("Weekly", comment: "Weekly")
    static let total: String =
        NSLocalizedString("Total", comment: "Total")
  }

  struct FundraisingCard {
    static let title: String =
        NSLocalizedString("Fundraising Progress",
                          comment: "Fundraising Progress")

    static let inviteSupporters: String =
        NSLocalizedString("Invite Supporters", comment: "Invite Supporters")
    static let viewSupporters: String =
      NSLocalizedString("View Supporters \u{203a}", comment: "View Suppoters >")
  }

  struct ChallengeCard {
    static let title: String =
        NSLocalizedString("Challenge Progress", comment: "Challenge Progress")
    static let joinChallenge: String =
        NSLocalizedString("Join Challenge", comment: "Join Challenge")
  }

  struct Assets {
    static let gear = "GearIcon"

    static let gearIcon = "GearIcon"
  }
}
