
enum Device {
  case None
  case HealthKit
}

class Preferences {
  static var instance = Preferences()
  var device: Device = .None

  init() {
    // TODO(compnerd) deserialise user preferences
    device = .HealthKit
  }
}
