
import Foundation

struct Strings {
  struct Login {
    static let title = NSLocalizedString("Walking Challenge", comment: "Title for login screen")
    static let desciption = NSLocalizedString("Please login in via facebook to continue", comment: "Description for login screen")
  }

  struct Profile {
    static let myTeam = NSLocalizedString("My Team", comment: "Description label for team")
  }

  struct ContactPicker {
    static let title = NSLocalizedString("Select Contacts", comment: "Title for Contact Picker")
  }

  struct NavBarTitles {
    static let profile = NSLocalizedString("Profile", comment: "Navigation bar title for profile tab")
    static let team = NSLocalizedString("Team", comment: "Navigation bar title for team tab")
    static let sponsor = NSLocalizedString("Sponsor", comment: "Navigation bar title for sponsor tab")
  }
}

