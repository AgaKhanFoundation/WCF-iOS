
import Foundation

class ProfileDataSource {
  var realName: String = ""
  var teamName: String = ""
  var dataProvider: PedometerDataProvider? = nil

  init() {
    switch Preferences.instance.source {
    case .None:
      break
    case .HealthKit:
      dataProvider = HealthKitDataProvider()
      break
    }
  }

  func updateProfile(completion: @escaping SuccessBlock) {
    // TODO(compnerd) fetch this from our backend
    self.teamName = "Team Name"

    Facebook.getRealName { [weak self] (name) in
      guard name != nil else { return }
      self?.realName = name!

      onMain {
        completion(true)
      }
    }
  }
}

