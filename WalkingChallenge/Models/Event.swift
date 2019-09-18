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
  let image: URL?

  let id: Int?                                                                  // swiftlint:disable:this identifier_name line_length
  let name: String
  let description: String
  let start: Date
  let end: Date
  let teamLimit: Int
  let cause: Cause?

  init?(json: JSON?) {
    guard
      let json = json,
      let name = json["name"]?.stringValue,
      let description = json["description"]?.stringValue,
      let startDate = json["start_date"]?.stringValue,
      let endDate = json["end_date"]?.stringValue,
      let teamLimit = json["team_limit"]?.intValue
    else { return nil }

    let formatter: ISO8601DateFormatter = ISO8601DateFormatter()

    self.id = json["id"]?.intValue
    self.name = name
    self.description = description
    self.start = formatter.date(from: startDate) ?? Date()
    self.end = formatter.date(from: endDate) ?? Date()
    self.teamLimit = teamLimit

    if let cause = json["cause"] {
      self.cause = Cause(json: cause)
    } else {
      self.cause = nil
    }

    self.image = nil
  }
}
