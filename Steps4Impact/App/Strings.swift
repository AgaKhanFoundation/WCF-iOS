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
    static let name = NSLocalizedString("Application.name", comment: "Name of Application")
  }

  struct Navigation {
    static let dashboard = NSLocalizedString("Navigation.dashboard", comment: "")
    static let challenge = NSLocalizedString("Navigation.challenge", comment: "")
    static let leaderboard = NSLocalizedString("Navigation.leaderboard", comment: "")
    static let notifications = NSLocalizedString("Navigation.notifications", comment: "")
  }

  struct AKFCausesServiceError {
    static let unableToConnect = NSLocalizedString("AKFCausesServiceError.unableToConnect", comment: "")
  }

  struct Login {
    static let conditions = NSLocalizedString("Login.conditions", comment: "")
  }

  struct Welcome {
    static let title = String(format: NSLocalizedString("Welcome.title", comment: ""), Application.name)
    static let thanks = NSLocalizedString("Welcome.thanks", comment: "")
    static let `continue` = NSLocalizedString("Welcome.continue", comment: "")
    static let skip = NSLocalizedString("Welcome.skip", comment: "")
  }

  struct Onboarding {
    static let createTeam = NSLocalizedString("Onboarding.createTeam", comment: "")
    static let journey = NSLocalizedString("Onboarding.journey", comment: "")
    static let dashboard = NSLocalizedString("Onboarding.dashboard", comment: "")
    static let `continue` = NSLocalizedString("Onboarding.continue", comment: "")
    static let begin = NSLocalizedString("Onboarding.begin", comment: "")
  }

  struct Dashboard {
    static let title = NSLocalizedString("Dashboard.title", comment: "")
    static let badges = NSLocalizedString("Dashboard.badges", comment: "")

    struct Activity { // swiftlint:disable:this nesting
      static let title = NSLocalizedString("Dashboard.Activity.title", comment: "")
      static let disconnected = NSLocalizedString("Dashboard.Activity.disconnected", comment: "")
      static let connect = NSLocalizedString("Dashboard.Activity.connect", comment: "")
    }

    struct ChallengeProgress { // swiftlint:disable:this nesting
      static let title = NSLocalizedString("Dashboard.ChallengeProgress.title", comment: "")
      static let unavailable = NSLocalizedString("Dashboard.ChallengeProgress.unavailable", comment: "")
    }

    struct FundraisingProgress { // swiftlint:disable:this nesting
      static let title = NSLocalizedString("Dashboard.FundraisingProgress.title", comment: "")
      static let unavailable = NSLocalizedString("Dashboard.FundraisingProgress.unavailable", comment: "")
      static let invite = NSLocalizedString("Dashboard.FundraisingProgress.invite", comment: "")
    }
  }

  struct Journey {
    static let title = NSLocalizedString("Journey.title", comment: "")
  }

  struct Badges {
    static let title = NSLocalizedString("Badges.title", comment: "")
    static let empty = NSLocalizedString("Badges.empty", comment: "")

    struct HeaderTittes {       // swiftlint:disable:this nesting
      static let noBadges = NSLocalizedString("Badges.HeaderTitles.noBadges", comment: "")
      static let bottomSectionTitle = NSLocalizedString("Badges.HeaderTitles.bottomSectionTitle", comment: "")
    }
  }

  struct ProfileCard {
    static let challengeTimeline = NSLocalizedString("ProfileCard.challengeTimeline", comment: "")
    static let team = NSLocalizedString("ProfileCard.team", comment: "")
  }

  struct ActivityCard {
    static let title = NSLocalizedString("ActivityCard.title", comment: "")
    static let joinChallenge = NSLocalizedString("ActivityCard.joinChallenge", comment: "")
    static let daily = NSLocalizedString("ActivityCard.daily", comment: "")
    static let weekly = NSLocalizedString("ActivityCard.weekly", comment: "")
    static let total = NSLocalizedString("ActivityCard.total", comment: "")
  }

  struct FundraisingCard {
    static let title = NSLocalizedString("FundraisingCard.title", comment: "")
    static let inviteSupporters = NSLocalizedString("FundraisingCard.inviteSupporters", comment: "")
    static let viewSupporters = NSLocalizedString("FundraisingCard.viewSupporters", comment: "")
  }

  struct Challenge {
    static let title = NSLocalizedString("Challenge.title", comment: "")

    struct CreateTeam { // swiftlint:disable:this nesting
      static let title = NSLocalizedString("Challenge.CreateTeam.title", comment: "")
      static let create = NSLocalizedString("Challenge.CreateTeam.create", comment: "")
      static let formTitle = NSLocalizedString("Challenge.CreateTeam.formTitle", comment: "")
      static let formPlaceholder = NSLocalizedString("Challenge.CreateTeam.formPlaceholder", comment: "")
      static let errorTitle = NSLocalizedString("Challenge.CreateTeam.errorTitle", comment: "")
      static let errorBody = NSLocalizedString("Challenge.CreateTeam.errorBody", comment: "")
      static let successTitle = NSLocalizedString("Challenge.CreateTeam.successTitle", comment: "")
      static let `continue` = NSLocalizedString("Challenge.CreateTeam.continue", comment: "")
      static let visibilityBodyOn = NSLocalizedString("Challenge.CreateTeam.visibilityBodyOn", comment: "")
      static let visibilityBodyOff = NSLocalizedString("Challenge.CreateTeam.visibilityBodyOff", comment: "")
      static let teamVisibilityTitleText = NSLocalizedString("Challenge.CreateTeam.teamVisibilityTitleText", comment: "")
      static let teamVisibilitySwitchStatusPublic = NSLocalizedString("Challenge.CreateTeam.teamVisibilitySwitchStatusPublic", comment: "")
      static let teamVisibilitySwitchStatusPrivate = NSLocalizedString("Challenge.CreateTeam.teamVisibilitySwitchStatusPrivate", comment: "")
      static let uploadTeamPhotoLabelText = NSLocalizedString("Challenge.CreateTeam.uploadTeamPhotoLabelText", comment: "")
      static let uploadImageButtonText = NSLocalizedString("Challenge.CreateTeam.uploadImageButtonText", comment: "")
    }

    struct JoinTeam { // swiftlint:disable:this nesting
      static let title = NSLocalizedString("Challenge.JoinTeam.title", comment: "")
    }

    struct TeamNeededCard { // swiftlint:disable:this nesting
      static let title = NSLocalizedString("Challenge.TeamNeededCard.title", comment: "")
      static let body = NSLocalizedString("Challenge.TeamNeededCard.body", comment: "")
      static let primaryButton = NSLocalizedString("Challenge.TeamNeededCard.primaryButton", comment: "")
      static let secondaryButton = NSLocalizedString("Challenge.TeamNeededCard.secondaryButton", comment: "")
    }
  }

  struct Leaderboard {
    static let title = NSLocalizedString("Leaderboard.title", comment: "")
    static let empty = NSLocalizedString("Leaderboard.empty", comment: "")
  }

  struct ChallengeCard {
    static let title = NSLocalizedString("ChallengeCard.title", comment: "")
    static let joinChallenge = NSLocalizedString("ChallengeCard.joinChallenge", comment: "")
  }

  struct Notifications {
    static let title = NSLocalizedString("Notifications.title", comment: "")
    static let youHaveNoNotifications = NSLocalizedString("Notifications.youHaveNoNotifications", comment: "")
  }

  struct Settings {
    static let title = NSLocalizedString("Settings.title", comment: "")
    static let delete = NSLocalizedString("Settings.delete", comment: "")
    static let deleteBody = NSLocalizedString("Settings.deleteBody", comment: "")
  }

  struct TeamSettings {
    static let title = NSLocalizedString("TeamSettings.title", comment: "")
    static let edit = NSLocalizedString("TeamSettings.edit", comment: "")
    static let done = NSLocalizedString("TeamSettings.done", comment: "")
    static let leave = NSLocalizedString("TeamSettings.leave", comment: "")
    static let leaveBody = NSLocalizedString("TeamSettings.leaveBody", comment: "")
    static let deleteTeam = NSLocalizedString("TeamSettings.deleteTeam", comment: "")
    static let deleteTeamBody = NSLocalizedString("TeamSettings.deleteTeamBody", comment: "")
    static let editTeamNameMessage = NSLocalizedString("TeamSettings.editTeamNameMessage", comment: "")
    static let editTeamName = NSLocalizedString("TeamSettings.editTeamName", comment: "")
    static let editImage = NSLocalizedString("TeamSettings.editImage", comment: "")
    static let update = NSLocalizedString("TeamSettings.update", comment: "")
  }

  struct ConnectSource {
    static let title = NSLocalizedString("ConnectSource.title", comment: "")
    static let connect = NSLocalizedString("ConnectSource.connect", comment: "")
    static let disconnect = NSLocalizedString("ConnectSource.disconnect", comment: "")
    static let missingDevice = NSLocalizedString("ConnectSource.missingDevice", comment: "")
    static let missingDeviceDetails = NSLocalizedString("ConnectSource.missingDeviceDetails", comment: "")
  }

  struct InviteSupporters {
    static let title = NSLocalizedString("InviteSupporters.title", comment: "")
    static let getSupported = NSLocalizedString("InviteSupporters.getSupported", comment: "")
    static let inviteSupporters = NSLocalizedString("InviteSupporters.inviteSupporters", comment: "")
    static let request = NSLocalizedString("InviteSupporters.request", comment: "")
  }

  struct Share {
    static func item(teamName: String) -> String {
      return String(format: NSLocalizedString("Share.item", comment: ""), teamName)
    }
  }
}
