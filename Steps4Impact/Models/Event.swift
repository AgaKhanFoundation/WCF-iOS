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

struct Event {
  struct DateRange {
    let start: Date
    let end: Date
  }

  let image: URL?

  let id: Int?                                                                  // swiftlint:disable:this identifier_name line_length
  let name: String
  let description: String?
  let challengePhase: DateRange
  let teamFormationPhase: DateRange
  let teamLimit: Int
  let defaultStepCount: Int
  let cause: Cause?

  let commitment: Commitment?

  init?(json: JSON?) {
    guard let json = json else { return nil }

    self.image = nil
    self.id = json["id"]?.intValue
    self.name = json["name"]?.stringValue ?? ""
    self.description = json["description"]?.stringValue
    self.challengePhase = DateRange(start: Date.formatter.date(from: json["start_date"]?.stringValue ?? "") ?? Date.distantFuture, // swiftlint:disable:this line_length
                                    end: Date.formatter.date(from: json["end_date"]?.stringValue ?? "") ?? Date.distantFuture) // swiftlint:disable:this line_length
    self.teamFormationPhase = DateRange(start: Date.formatter.date(from: json["team_building_start"]?.stringValue ?? "") ?? Date.distantFuture, // swiftlint:disable:this line_length
                                        end: Date.formatter.date(from: json["team_building_end"]?.stringValue ?? "") ?? Date.distantFuture) // swiftlint:disable:this line_length
    self.teamLimit = json["team_limit"]?.intValue ?? 0
    if let defaultSteps = json["default_steps"]?.intValue {
      self.defaultStepCount = defaultSteps
    } else {
      self.defaultStepCount = 10000 * challengePhase.start.daysUntil(challengePhase.end)
    }
    self.cause = Cause(json: json["cause"])
    self.commitment = Commitment(json: json["participant_event"])
  }
}

extension Event {
  var lengthInDays: Int { challengePhase.start.daysUntil(challengePhase.end) }
}
