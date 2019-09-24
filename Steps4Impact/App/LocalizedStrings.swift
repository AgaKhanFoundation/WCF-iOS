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

import Foundation
import UIKit

struct Strings {
  struct Application {
    static let name: String = "Steps4Impact"

    static let unableToConnect: String =
        NSLocalizedString("Unable to access AKF Causes at this time.  Please try again later.",
                          comment: "Unable to access AKF Causes at this time.  Please try again later.")
  }

  struct Login {
    static let conditions: String =
        NSLocalizedString("Terms and Conditions Apply",
                          comment: "Terms and Conditions Apply")
  }

  struct Welcome {
    static let title: String =
        NSLocalizedString("Welcome to Steps for Change!",
                          comment: "Welcome to Steps for Change!")
    static let thanks: String =
        NSLocalizedString("""
Thanks for registering!
Click continue for a quick tour of the app.
""",
                          comment: """
Thanks for registering!
Click continue for a quick tour of the app.
""")
    static let `continue`: String =
        NSLocalizedString("Continue", comment: "Continue")
    static let skip: String =
        NSLocalizedString("Skip", comment: "Skip")
  }

  struct Onboarding {
    static let createTeam: String =
        NSLocalizedString("Create a team or join an existing team",
                          comment: "Create a team or join an existing team")
    static let journey: String =
        NSLocalizedString("Complete a challenge while reaching milestones",
                          comment: "Complete a challenge while reaching milestones")
    static let dashboard: String =
        NSLocalizedString("Track your progress using the dashboard",
                          comment: "Track your progress using the dashboard")
    static let `continue`: String =
        NSLocalizedString("Continue", comment: "Continue")
    static let begin: String =
        NSLocalizedString("Let's Begin!", comment: "Let's Begin!")
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
    static let badges: String =
        NSLocalizedString("View Badges", comment: "View Badges")

    struct Activity {                                                            // swiftlint:disable:this nesting
      static let title: String =
          NSLocalizedString("Activity", comment: "Activity")
      static let disconnected: String =
          NSLocalizedString("No activity yet. You will need to connect a fitness tracker to track your miles",
                            comment: "No activity yet. You will need to connect a fitness tracker to track your miles")
      static let connect: String =
          NSLocalizedString("Connect an App or Device",
                            comment: "Connect an App or Device")
    }

    struct ChallengeProgress {                                                   // swiftlint:disable:this nesting
      static let title: String =
          NSLocalizedString("Challenge Progress", comment: "Challenge Progress")
      static let unavailable: String =
          NSLocalizedString("No data available. You will be able to see your team's progress once the challenge has started", // swiftlint:disable:this line_length
                            comment: "No data available. You will be able to see your team's progress once the challenge has started") // swiftlint:disable:this line_length
    }

    struct FundrasingProgress {                                                  // swiftlint:disable:this nesting
      static let title: String =
          NSLocalizedString("Fundraising Progress",
                            comment: "Fundraising Progress")
      static let unavailable: String =
          NSLocalizedString("No data available. You will be able to see your progress once the challenge has started.",
                            comment: "No data available. You will be able to see your progress once the challenge has started.") // swiftlint:disable:this line_length
      static let invite: String =
          NSLocalizedString("Invite supporters to pledge",
                            comment: "Invite supporters to pledge")
    }
  }

  struct Badges {
    static let title: String =
      NSLocalizedString("Badges", comment: "Badges")
    static let empty: String =
      NSLocalizedString("Come back often to check on what badges you've earned", comment: "Badges empty state")
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

  struct Challenge {
    static let title: String =
      NSLocalizedString("Challenge", comment: "Challenge")

    struct CreateTeam { // swiftlint:disable:this nesting
      static let title: String =
        NSLocalizedString("Create a Team", comment: "Create a Team")
      static let create: String =
        NSLocalizedString("Create", comment: "Create")
      static let formTitle: String =
        NSLocalizedString("Your Team Name", comment: "Create team form title")
      static let formPlaceholder: String =
        NSLocalizedString("My Awesome Team", comment: "Create team form placeholder")

      struct ErrorAlert { // swiftlint:disable:this nesting
        static let title: String =
          NSLocalizedString("Error", comment: "Error Alert Title")
        static let body: String =
          NSLocalizedString("Could not create team - perhaps try a different name", comment: "Error Alert Body")
      }

      static let successTitle: String =
        NSLocalizedString("You have successfully created a team", comment: "Create team success")
    }

    struct JoinTeam { // swiftlint:disable:this nesting
      static let title: String =
        NSLocalizedString("Join a Team", comment: "Join a Team")
    }

    struct TeamNeededCard { // swiftlint:disable:this nesting
      static let title: String =
        NSLocalizedString("You will need a Team", comment: "TeamNeededCard Title")
      static let body: String =
        NSLocalizedString("Participating in a challenge is always more fun with friends", comment: "TeamNeededCard Body") // swiftlint:disable:this line_length
      static let primaryButton: String =
        NSLocalizedString("Create a New Team", comment: "TeamNeededCard PrimaryButton")
      static let secondaryButton: String =
        NSLocalizedString("Join an Existing Team", comment: "TeamNeededCard SecondaryButton")
    }
  }

  struct Leaderboard {
    static let title: String =
      NSLocalizedString("Leaderboard", comment: "Leaderboard")
    static let empty: String =
      NSLocalizedString("Check back for global team rankings.", comment: "Leaderboard empty state")
  }

  struct ChallengeCard {
    static let title: String =
        NSLocalizedString("Challenge Progress", comment: "Challenge Progress")
    static let joinChallenge: String =
        NSLocalizedString("Join Challenge", comment: "Join Challenge")
  }

  struct Notifications {
    static let title: String =
        NSLocalizedString("Notifications", comment: "Notifications")
    static let youHaveNoNotifications: String =
        NSLocalizedString("You don't have any notifications right now.",
                          comment: "You don't have any notifications right now.")
  }

  struct Settings {
    static let title: String =
      NSLocalizedString("Settings", comment: "Settings screen title")
    static let delete: String =
      NSLocalizedString("Delete Account?", comment: "Delete Account?")
    static let deleteBody: String =
      NSLocalizedString("You will be removed from any ongoing challenges and your mile progress will be lost.",
                        comment: "You will be removed from any ongoing challenges and your mile progress will be lost.")
  }

  struct TeamSettings {
    static let title: String =
      NSLocalizedString("Team", comment: "Team settings screen title")
    static let edit: String =
      NSLocalizedString("Edit", comment: "Team settings edit button in navigation bar")
    static let leave: String =
      NSLocalizedString("Leave Team?", comment: "Leave Team?")
    static let leaveBody: String =
      NSLocalizedString("""
This will remove your data linked to the team. You will not be able to participate in the challenge.
""", comment: """
This will remove your data linked to the team. You will not be able to participate in the challenge.
""")
  }

  struct ConnectSource {
    static let title: String =
        NSLocalizedString("Connected Apps & Devices", comment: "Connected Apps & Devices")
    static let connect: String =
        NSLocalizedString("Connect", comment: "Connect")
  }

  struct InviteSupporters {
    static let title: String =
        NSLocalizedString("Invite Supporters", comment: "Invite Supporters")
    static let getSupported: String =
        NSLocalizedString("""
Get sponsored by your friends. When your friends sign up to support you, you will raise money for every mile you move. Proceeds will be donated to AKF.
""", comment: """
Get sponsored by your friends. When your friends sign up to support you, you will raise money for every mile you move. Proceeds will be donated to AKF.
""")
    static let inviteSupporters: String =
        NSLocalizedString("Invite Supporters to Pledge",
                          comment: "Invite Supporters to Pledge")
    static let request: String =
        NSLocalizedString("""
Want to join me in supporting a good cause? I am participating in Aga Khan Foundation's (AKF) steps4impact challenge. You can support me by pledging http://www.akfusa.org/steps4impactpledge.
All proceeds will be donated to AKF. Learn about AKF https://www.akfusa.org/ Thank you for your support.
""", comment: """
Want to join me in supporting a good cause? I am participating in Aga Khan Foundation's (AKF) steps4impact challenge. You can support me by pledging http://www.akfusa.org/steps4impactpledge.
All proceeds will be donated to AKF. Learn about AKF https://www.akfusa.org/ Thank you for your support.
""")
  }

  struct Share {
    static let item: String =
      NSLocalizedString(
"""
Hey! I  created a team for the AKF Walk Challenge on the new Aga Khan Foundation app, Steps4Impact, and I want you on my team!
Download the app here:
http://rebrand.ly/steps4impact-iphone
http://rebrand.ly/steps4impact-android
""", comment: "Share item")
  }
}

enum Assets: String {
  // UI
  case gear = "GearIcon"
  case disclosure = "BlueBackButton"
  case close = "close"
  case checkmark = "checkmark"
  
  // Challenge
  case challengeJourney = "challengejourney"
  case inviteFriends = "invitefriends"
  case inviteSupporters = "invitesupporters"
  
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
