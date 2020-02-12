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
  private let healthStore = HKHealthStore()
  
  func retrieveStepCount(forInterval interval: DateInterval, _ completion: @escaping PedometerDataCompletion) {
    retrieve(.stepCount, interval: interval, unit: .count(), completion: completion)
  }
  
  func retrieveDistance(forInterval interval: DateInterval, _ completion: @escaping PedometerDataCompletion) {
    retrieve(.distanceWalkingRunning, interval: interval, unit: .mile(), completion: completion)
  }
  
  private func retrieve(_ typeId: HKQuantityTypeIdentifier,
                        interval: DateInterval,
                        unit: HKUnit,
                        completion: @escaping PedometerDataCompletion) {
    guard let quantityType = HKSampleType.quantityType(forIdentifier: typeId) else {
      return completion(.failure(.quantityType))
    }
    
    healthStore.getRequestStatusForAuthorization(toShare: [], read: [quantityType]) { [weak self] (status, error) in
      guard let `self` = self, error == nil else { return completion(.failure(.unknown)) }
      
      switch status {
      case .unknown:
        completion(.failure(.unknown))
      case .shouldRequest:
        self.healthStore.requestAuthorization(toShare: nil, read: [quantityType]) { (success, error) in
          guard success, error == nil else {
            completion(.failure(.sharingNotAuthorized))
            return
          }
          self.retrieve(typeId, interval: interval, unit: unit, completion: completion)
        }
      case .unnecessary:
        self.query(quantityType: quantityType, interval: interval, unit: unit, completion: completion)
      @unknown default:
        completion(.failure(.unknown))
      }
    }
  }
  
  private func query(quantityType: HKQuantityType,
                     interval: DateInterval,
                     unit: HKUnit,
                     completion: @escaping PedometerDataCompletion) {
    
    let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                            quantitySamplePredicate: nil,
                                            options: .cumulativeSum,
                                            anchorDate: interval.start,
                                            intervalComponents: DateComponents(day: 1))
    query.initialResultsHandler = { (query, results, error) in
      guard error == nil, let results = results else {
        completion(.failure(.resultsNotPresent))
        return
      }
      
      var pedometerData = [PedometerData]()
      
      results.enumerateStatistics(from: interval.start, to: interval.end) { (statistics, _) in
        if let quantity = statistics.sumQuantity() {
          pedometerData.append(PedometerData(date: statistics.startDate, count: quantity.doubleValue(for: unit)))
        }
                
        if interval.end.timeIntervalSince(statistics.endDate) <= 0, pedometerData.count != 0 {
          completion(.success(pedometerData))
        }
      }
    }
    
    healthStore.execute(query)
  }
}
