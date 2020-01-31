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
  let sequence: Int
  let distance: Int
  let name: String
  let flagName: String
  let journeyMap: String
  let description: String
  let title: String
  let subtitle: String
  let media: String
  let content: String
  
  init?(json: JSON?) {
    guard
      let json = json,
      let sequence = json["sequence"]?.intValue,
      let distance = json["distance"]?.intValue,
      let name = json["name"]?.stringValue,
      let flagName = json["flagName"]?.stringValue,
      let journeyMap = json["journeyMap"]?.stringValue,
      let description = json["description"]?.stringValue,
      let title = json["title"]?.stringValue,
      let subtitle = json["subtitle"]?.stringValue,
      let media = json["media"]?.stringValue,
      let content = json["content"]?.stringValue
    else { return nil }

    self.sequence = sequence
    self.distance = distance
    self.name = name
    self.flagName = flagName
    self.journeyMap = journeyMap
    self.description = description
    self.title = title
    self.subtitle = subtitle
    self.media = media
    self.content = content
  }

  func getMediaURLs() -> [String] {
    var result = [String]()
    let splitMedia = self.media.split(separator: " ")
    for mediaURL in splitMedia {
      let url = mediaURL.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)[safe: 1]
      if let url = url {
        result.append(String(url))
      }
    }
    return result
  }
}
