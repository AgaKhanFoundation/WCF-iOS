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

import Foundation
import OAuthSwift

class FitbitDataProvider: PedometerDataProvider {
  func retrieveStepCount(forInterval interval: DateInterval, _ completion: @escaping PedometerDataCompletion) {
    OAuthFitbit.shared.fetchSteps(forInterval: interval) { [weak self] (result) in
      guard
        let `self` = self,
        case .success(let response) = result,
        let steps = self.convert(response: response)
      else { return completion(.failure(.unknown)) }
      
      completion(.success(steps))
    }
  }
  
  func retrieveDistance(forInterval interval: DateInterval, _ completion: @escaping PedometerDataCompletion) {
    OAuthFitbit.shared.fetchSteps(forInterval: interval) { [weak self] (result) in
      guard
        let `self` = self,
        case .success(let response) = result,
        let steps = self.convert(response: response)
      else { return completion(.failure(.unknown)) }
      
      let miles = steps
        .map { PedometerData(date: $0.date, count: $0.count / 2000) }
      
      completion(.success(miles))
    }
  }
  
  private func convert(response: OAuthSwiftResponse) -> [PedometerData]? {
    guard
      let jsonObject = try? response.jsonObject(),
      let activitySteps = JSON(jsonObject)?["activities-steps"]?.arrayValue
    else { return nil }
    
    return activitySteps
      .compactMap { return FitbitStep(json: $0) }
      .map { return PedometerData(date: $0.date, count: Double($0.steps)) }
  }
}
