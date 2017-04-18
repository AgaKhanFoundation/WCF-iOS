
import HealthKit

class HealthKitDataProvider: PedometerDataProvider {
  private typealias HK = HealthKitDataProvider
  private static let store = HKHealthStore()

  func retrieveStepCountForDateRange(_ interval: DateInterval,
                                     _ completion: @escaping PedometerCallback) {
    guard
      let stepCount = HKSampleType.quantityType(forIdentifier: .stepCount)
    else { return }

    if HK.store.authorizationStatus(for: stepCount) != .sharingAuthorized {
      HK.store.requestAuthorization(toShare: nil, read: [stepCount]) {
        (success: Bool, error: Error?) in
          guard error == nil && success else {
            print("Error getting HealthKit access: \(String(describing: error))")
            return
          }
      }
    }

    query(sampleType: stepCount, interval: interval, completion: completion)
  }

  private func query(sampleType: HKSampleType, interval: DateInterval,
                     completion: @escaping PedometerCallback) {
    let predicate = HKQuery.predicateForSamples(withStart: interval.start,
                                                end: interval.end, options: [])

    let query = HKSampleQuery(sampleType: sampleType, predicate: predicate,
                              limit: 0, sortDescriptors: nil) {
      (query, results, _) in
        guard let results = results as? [HKQuantitySample] else {
          // FIXME(compnerd) should we be invoking the completion here?
          completion(0)
          return
        }

        var steps = 0
        for result in results {
          steps += Int(result.quantity.doubleValue(for: .count()))
        }

        completion(steps)
    }

    HK.store.execute(query)
  }
}
