
import Foundation

struct UserInfo {
  private static let defaults = UserDefaults.standard

  // Add new keys to store to UserDefaults here
  private static let pedometerKey = "UserInfo.Keys.Pedometer"
  private static let profileStatsRangeKey = "UserInfo.Keys.ProfileStatsRange"
  private static let teamLeaderStatsRangeKey =
      "UserInfo.Keys.TeamLeaderboardStatsRange"

  enum Pedometer: String {
    case healthKit = "UserInfo.Pedometer.HealthKit"
    // case fitbit
  }

  static var pedometerSource: Pedometer? {
    get {
      guard
        let pedometerRaw = defaults.string(forKey: pedometerKey)
      else { return nil }
      return Pedometer(rawValue: pedometerRaw)
    }
    set {
      guard let newValue = newValue else { return }
      defaults.set(newValue.rawValue, forKey: pedometerKey)
    }
  }

  static var profileStatsRange: Int {
    get { return defaults.integer(forKey: profileStatsRangeKey) } // 0 returned by default if none set
    set { defaults.set(newValue, forKey: profileStatsRangeKey) }
  }

  static var teamLeaderStatsRange: Int {
    get { return defaults.integer(forKey: teamLeaderStatsRangeKey) }
    set { defaults.set(newValue, forKey: teamLeaderStatsRangeKey) }
  }
}
