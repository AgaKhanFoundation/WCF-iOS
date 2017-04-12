
import Foundation

struct Strings {
  struct Login {
    static let title = NSLocalizedString("Walking Challenge", comment: "Title for login screen")
    static let desciption = NSLocalizedString("Please login in via facebook to continue", comment: "Description for login screen")
  }

  struct Profile {
    static let thisWeek = NSLocalizedString("This Week", comment: "This Week range")
    static let thisMonth = NSLocalizedString("This Month", comment: "This Month range")
    static let thisEvent = NSLocalizedString("This Event", comment: "This Event range")
    static let overall = NSLocalizedString("Overall", comment: "Overall Range")
    static let supporters = NSLocalizedString("Supporters", comment: "Title for Supporters")
  }

  struct ContactPicker {
    static let title = NSLocalizedString("Select Contacts", comment: "Title for Contact Picker")
  }

  struct NavBarTitles {
    static let team = NSLocalizedString("My Team", comment: "Navigation bar title for team tab")
    static let profile = NSLocalizedString("My Profile", comment: "Navigation bar title for profile tab")
    static let leaderboard = NSLocalizedString("Leaderboard", comment: "Navigation bar title for leaderboard")
  }
}

