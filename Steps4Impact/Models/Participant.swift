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

struct Participant {
  let id: Int?
  let fbid: String
  let team: Team?
  let events: [Event]
  let preferredCause: Cause?
  let records: [Record]

  let currentEventCommitment: Int?
  let currentEventCommitmentId: Int?

  init?(json: JSON?) {
    guard let json = json else { return nil }
    guard
      let fbid = json["fbid"]?.stringValue
    else { return nil }

    let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
    formatter.formatOptions = [
      .withInternetDateTime,
      .withFractionalSeconds
    ]

    self.id = json["id"]?.intValue
    self.fbid = fbid

    if let team = json["team"] {
      self.team = Team(json: team)
    } else {
      self.team = nil
    }
    if let events = json["events"]?.arrayValue {
      self.events = events.compactMap({ (json) in Event(json: json) })

      var commitment: Int?
      var commitmentId: Int?
      for event in events {
        if formatter.date(from: event["end_date"]?.stringValue ?? "")?.timeIntervalSinceNow.sign == .plus {
          commitment = event["participant_event"]?["commitment"]?.intValue
          commitmentId = event["participant_event"]?["id"]?.intValue
        }
      }
      if let commitment = commitment, let commitmentId = commitmentId {
        self.currentEventCommitment = commitment / 2000 // steps to miles
        self.currentEventCommitmentId = commitmentId
      } else {
        self.currentEventCommitment = nil
        self.currentEventCommitmentId = nil
      }
    } else {
      self.events = []
      self.currentEventCommitment = nil
      self.currentEventCommitmentId = nil
    }
    if let cause = json["cause"] {
      self.preferredCause = Cause(json: cause)
    } else {
      self.preferredCause = nil
    }
    if let records = json["records"]?.arrayValue {
      self.records = records.compactMap { return Record(json: $0) }
    } else {
      self.records = []
    }
  }

  public var currentEvent: Event? {
    return self.events.filter { $0.challengePhase.end.timeIntervalSinceNow.sign == .plus }.first
  }
}
