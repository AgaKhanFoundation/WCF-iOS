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
  struct Profile {
    static let thisWeek = NSLocalizedString("This Week", comment: "This Week range")
    static let thisMonth = NSLocalizedString("This Month", comment: "This Month range")
    static let thisEvent = NSLocalizedString("This Event", comment: "This Event range")
    static let overall = NSLocalizedString("Overall", comment: "Overall Range")
    static let supporters = NSLocalizedString("Supporters", comment: "Title for Supporters")
    static let seeMore = NSLocalizedString("See More \u{203a}", comment: "Show More")
    static let pastEvents = NSLocalizedString("Past Events", comment: "Past Evvents")
  }

  struct Team {
    static let thisWeek = NSLocalizedString("This Week", comment: "This Week range")
    static let thisMonth = NSLocalizedString("This Month", comment: "This Month range")
    static let thisEvent = NSLocalizedString("This Event", comment: "This Event range")
    static let overall = NSLocalizedString("Overall", comment: "Overall Range")
    static let leaderboard = NSLocalizedString("Leaderboard", comment: "Title for leaderboard")
  }

  struct Configuration {
    static let device = NSLocalizedString("Device", comment: "Title for device section")
  }

  struct ContactPicker {
    static let title = NSLocalizedString("Select Contacts", comment: "Title for Contact Picker")
  }

  struct SupportersAndSponsors {
    static let title = NSLocalizedString("Supporters and Sponsors", comment: "Supporters and Sponsors")
  }

  struct Settings {
    static let title = NSLocalizedString("Settings", comment: "Settings")
    static let device = NSLocalizedString("Device", comment: "Device")
    static let accountSettings = NSLocalizedString("Accounts Settings", comment: "Account Settings")
    static let editProfile = NSLocalizedString("Edit Profile", comment: "Edit Profile")
    static let changeEmailAddress = NSLocalizedString("Change Email Address", comment: "Change Email Address")
    static let notificationsAndReminders = NSLocalizedString("Notifications and Reminders", comment: "Notifications and Reminders")
    static let teams = NSLocalizedString("Teams", comment: "Teams")
    static let changeTeams = NSLocalizedString("Change Teams", comment: "Change Teams")
    static let helpAndSupport = NSLocalizedString("Help & Support", comment: "Help & Support")
    static let faq = NSLocalizedString("FAQ", comment: "FAQ")
    static let contactUs = NSLocalizedString("Contact Us", comment: "Contact Us")
  }

  struct Events {
    static let title = NSLocalizedString("Events", comment: "Events")
    static let join = NSLocalizedString("Join", comment: "Join")
    static let openVirtualChallenges = NSLocalizedString("Open Virtual Challenges", comment: "Open Virtual Challenges")
  }

  struct Event {
    static let myStats = NSLocalizedString("My Stats", comment: "My Stats")
    static let supportersSponsors = NSLocalizedString("Supporters/Sponsors", comment: "Supporters/Sponsors")
    static let createTeam = NSLocalizedString("Create a Team", comment: "Create a Team")
  }

  struct EventStatistics {
    static let missingStats = NSLocalizedString("Statistics are not available until the virtual challenge has started.  Check back soon!",
                                                comment: "Statistics are not available until the virtual challenge has started.  Check back soon!")
    static let joinTeam = NSLocalizedString("Do your friends already have a team setup?  Ask the team captain to add you to get started!",
                                            comment: "Do your friends already have a team setup?  Ask the team captain to add you to get started!")
  }

  struct PastEvents {
    static let title = NSLocalizedString("Past Events", comment: "Past Events")
  }

  struct NavBarTitles {
    static let team = NSLocalizedString("My Team", comment: "Navigation bar title for team tab")
    static let profile = NSLocalizedString("My Profile", comment: "Navigation bar title for profile tab")
    static let events = NSLocalizedString("Events", comment: "Events")
    static let leaderboard = NSLocalizedString("Leaderboard", comment: "Navigation bar title for leaderboard")
    static let teamMembers = NSLocalizedString("Team Members", comment: "Team Members")
    static let configuration = NSLocalizedString("Configuration", comment: "Configuration")
  }

  struct Assets {
    static let gearIcon = "GearIcon"
  }
}
