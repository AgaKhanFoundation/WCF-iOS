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

struct Milestone {
  let sequence: Int?                                // swiftlint:disable:this identifier_name line_length
  let distance: Int?
  let name: String?
  let flagName: String?
  let journeyMap: String?
  let description: String?
  let title: String?
  let subtitle: String?
  let media: String?
  let content: String?

  init?(json: JSON?) {
    guard let json = json else { return nil }

    self.sequence = json["sequence"]?.intValue
    self.distance = json["distance"]?.intValue
    self.name = json["name"]?.stringValue
    self.flagName = json["flagName"]?.stringValue
    self.journeyMap = json["journeyMap"]?.stringValue
    self.description = json["description"]?.stringValue
    self.title = json["title"]?.stringValue
    self.subtitle = json["subtitle"]?.stringValue
    self.media = json["media"]?.stringValue
    self.content = json["content"]?.stringValue
  }
}

