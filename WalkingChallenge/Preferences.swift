
enum Pedometer {
  case None
  case HealthKit
}

class Preferences {
  static var instance = Preferences()
  var source: Pedometer = .None

  init() {
    // TODO(compnerd) deserialise user preferences
    source = .HealthKit
  }
}
