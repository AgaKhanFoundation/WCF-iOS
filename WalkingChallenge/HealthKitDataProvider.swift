/**
 * Copyright © 2017 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import HealthKit

class HealthKitDataProvider: PedometerDataProvider {
  private typealias HealthKit = HealthKitDataProvider
  private static let store = HKHealthStore()

  func retrieveStepCountForDateRange(_ interval: DateInterval,
                                     _ completion: @escaping PedometerCallback) {
    guard
      let stepCount = HKSampleType.quantityType(forIdentifier: .stepCount)
    else {
      completion(.error(.quantityType))
      return
    }

    switch HealthKit.store.authorizationStatus(for: stepCount) {
    case .notDetermined:
      HealthKit.store.requestAuthorization(toShare: [stepCount], read: [stepCount]) { (success: Bool, error: Error?) in
        guard success, error == nil else {
          print("Error getting HealthKit access: \(String(describing: error))")
          completion(.error(.sharingNotAuthorized))
          return
        }
        self.query(sampleType: stepCount, interval: interval, completion: completion)
      }
    case .sharingDenied:
      completion(.error(.sharingDenied))
    case .sharingAuthorized:
      query(sampleType: stepCount, interval: interval, completion: completion)
    }
  }

  private func query(sampleType: HKSampleType, interval: DateInterval,
                     completion: @escaping PedometerCallback) {
    let predicate = HKQuery.predicateForSamples(withStart: interval.start,
                                                end: interval.end, options: [])

    let query = HKSampleQuery(sampleType: sampleType, predicate: predicate,
                              limit: 0, sortDescriptors: nil) {
      (_, results, _) in
        guard let results = results as? [HKQuantitySample] else {
          completion(.error(.resultsNotPresent))
          return
        }

        var steps = 0
        for result in results {
          steps += Int(result.quantity.doubleValue(for: .count()))
        }

        completion(.success(steps))
    }

    HealthKit.store.execute(query)
  }
}
