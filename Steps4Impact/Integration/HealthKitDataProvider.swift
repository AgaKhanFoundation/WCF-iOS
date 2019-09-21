/**
 * Copyright © 2019 Aga Khan Foundation
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
  private let HK: HKHealthStore = HKHealthStore()                               // swiftlint:disable:this identifier_name line_length

  func retrieveStepCount(forInterval interval: DateInterval,
                         _ completion: @escaping (Result<Int, PedometerDataProvider.Error>) -> Void) {
    return retrieve(.stepCount, forInterval: interval, completion)
  }

  func retrieveDistance(forInterval interval: DateInterval,
                        _ completion: @escaping (Result<Int, PedometerDataProviderError>) -> Void) {
    return retrieve(.distanceWalkingRunning, forInterval: interval, completion)
  }

  private func retrieve(_ typeid: HKQuantityTypeIdentifier, forInterval: DateInterval,
                        _ completion: @escaping (Result<Int, PedometerDataProvider.Error>) -> Void) {
    guard
      let quantityType = HKSampleType.quantityType(forIdentifier: typeid)
    else { return completion(.failure(.quantityType)) }

    switch HK.authorizationStatus(for: quantityType) {
    case .sharingDenied:
      return completion(.failure(.sharingDenied))
    case .notDetermined:
      HK.requestAuthorization(toShare: nil, read: [quantityType]) { (success: Bool, error: Error?) in
        guard success, error == nil else {
          print("Error getting HealthKit access: \(String(describing: error))")
          return completion(.failure(.sharingNotAuthorized))
        }
      }
      fallthrough
    case .sharingAuthorized:
      query(sampleType: quantityType, interval: forInterval, completion: completion)
    @unknown default:
      completion(.failure(.unknown))
    }
  }

  private func query(sampleType: HKSampleType, interval: DateInterval,
                     completion: @escaping (Result<Int, PedometerDataProvider.Error>) -> Void) {
    let predicate = HKQuery.predicateForSamples(withStart: interval.start,
                                                end: interval.end, options: [])

    let query = HKSampleQuery(sampleType: sampleType, predicate: predicate,
                              limit: 0, sortDescriptors: nil) { (_: HKSampleQuery, samples: [HKSample]?, _: Error?) in
        guard let samples = samples as? [HKQuantitySample] else {
          return completion(.failure(.resultsNotPresent))
        }
        completion(.success(Int(samples.reduce(0, { $0 + $1.quantity.doubleValue(for: .count()) }))))
    }

    HK.execute(query)
  }
}
