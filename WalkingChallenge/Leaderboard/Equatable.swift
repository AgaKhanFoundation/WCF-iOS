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

extension Team {
  func calculateTotalMiles() -> Int {
    var sum = 0
    for team in members {
      for record in team.records {
        sum += record.distance
      }
    }
    return sum
  }
}

extension Team: Equatable {
  static func == (lhs: Team, rhs: Team) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.members == rhs.members
  }
}
extension Participant: Equatable {
  static func == (lhs: Participant, rhs: Participant) -> Bool {
    return lhs.fbid == rhs.fbid && lhs.team == rhs.team &&
      lhs.event == rhs.event && lhs.preferredCause == rhs.preferredCause &&
      lhs.records == rhs.records
  }
}
extension Event: Equatable {
  static func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.image == rhs.image && lhs.id == rhs.id && lhs.name == rhs.name &&
      lhs.description == rhs.description && lhs.start == rhs.start &&
      lhs.end == rhs.end && lhs.teamLimit == rhs.teamLimit &&
      lhs.cause == rhs.cause
  }
}
extension Cause: Equatable {
  static func == (lhs: Cause, rhs: Cause) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
  }
}
extension Record: Equatable {
  static func == (lhs: Record, rhs: Record) -> Bool {
    return lhs.id == rhs.id && lhs.date == rhs.date &&
      lhs.distance == rhs.distance && lhs.distance == rhs.distance &&
      lhs.fbid == rhs.fbid && lhs.source == rhs.source
  }
}
extension Source: Equatable {
  static func == (lhs: Source, rhs: Source) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
  }
}
