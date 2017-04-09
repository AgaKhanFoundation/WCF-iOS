
enum Pedometer {
  case None
  case HealthKit
}

class Preferences {
  static var instance = Preferences()
  var source: Pedometer = .None
  var profileStatsRange: Int = 0

  init() {
    // TODO(compnerd) deserialise user preferences
    source = .HealthKit
    profileStatsRange = 0
  }
}
