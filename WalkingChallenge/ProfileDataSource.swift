
import Foundation
import FBSDKCoreKit

import HealthKit

protocol DataProvider {
  func retrieveStepCountForDateRange(_ interval : NSDateInterval,
                                     _ completion : @escaping (_ steps : Int) -> Void)
}

class HealthKitDataProvider : DataProvider {
  let store = HKHealthStore()

  func retrieveStepCountForDateRange(_ interval : NSDateInterval,
                                     _ completion: @escaping (_ steps : Int) -> Void) {
    let stepCount = HKSampleType.quantityType(forIdentifier: .stepCount)
    let predicate = HKQuery.predicateForSamples(withStart: interval.startDate, end: interval.endDate, options: .init(rawValue: 0))
    let query = HKSampleQuery(sampleType: stepCount!, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in
      var steps = 0.0
      if let count = results?.count {
        if count > 0 {
        for result in results as! [HKQuantitySample] {
          steps = steps + result.quantity.doubleValue(for: .count())
        }
        }
      }
      completion(Int(steps))
    }
    store.execute(query)
  }
}

class ProfileDataSource {
  var realName : String = ""
  var teamName : String = ""
  var dataProviders : [DataProvider] = []

  init() {
    dataProviders.append(HealthKitDataProvider())
  }

  func updateProfile(completion: @escaping SuccessBlock) {
    // TODO(compnerd) enumerate across all data providers
    dataProviders[0].retrieveStepCountForDateRange(NSDateInterval()) {
     steps in NSLog("steps: %d", steps)
    }

    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name"])
    let _ = request?.start(completionHandler: { [weak self] (_, result: Any?, error: Error?) in
      guard
        error == nil,
        let result = result as? [String: Any],
        let name = result["name"] as? String
        else {
          completion(false)
          return
      }

      // TODO(compnerd) fetch this from our dasta source
      self?.realName = name
      self?.teamName = "Team Name"

      onMain {
        completion(true)
      }
    })
  }
}

