
import Foundation

class ProfileDataSource {
  var realName: String = ""
  var dataProvider: PedometerDataProvider?

  init() {
    if let dataSource = UserInfo.pedometerSource {
      switch dataSource {
      case .healthKit:
        dataProvider = HealthKitDataProvider()
      }
    }
  }

  func updateProfile(completion: @escaping SuccessBlock) {
    Facebook.getRealName { [weak self] (name) in
      guard name != nil else { return }
      self?.realName = name!

      onMain {
        completion(true)
      }
    }
  }
}

