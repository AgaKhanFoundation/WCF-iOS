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

import FacebookCore
import FacebookShare

struct Friend {
  let fbid: String
  let displayName: String
  let firstName: String
  let lastName: String
  let pictureRawURL: String

  init?(json: JSON) {
    guard
      let fbid = json["id"]?.stringValue,
      let displayName = json["name"]?.stringValue,
      let firstName = json["first_name"]?.stringValue,
      let lastName = json["last_name"]?.stringValue,
      let pictureURL = json["picture"]?["data"]?["url"]?.stringValue
    else { return nil }

    self.fbid = fbid
    self.displayName = displayName
    self.firstName = firstName
    self.lastName = lastName
    self.pictureRawURL = pictureURL
  }
}

enum QueryLimit {
  case none
  case count(Int)
}

private enum FriendType {
  case taggable
  case appUsers
}

class Facebook {
  typealias EnumerationCallback = (_: Friend) -> Void

  static var id: String {                                                       // swiftlint:disable:this identifier_name line_length
    return AccessToken.current?.userID ?? ""
  }

  static func getRealName(for fbid: String,
                          completion: @escaping (_: String?) -> Void) {
    let request: GraphRequest =
        GraphRequest(graphPath: fbid, parameters: ["fields" : "name"],          // swiftlint:disable:this colon
          tokenString: AccessToken.current?.tokenString, version: nil,
          httpMethod: .get)
    request.start { (_, result, error) in
      guard let result = result else {
        print("unable to execute GraphQL query \(String(describing: error))")
        completion(nil)
        return
      }
      if let deserialised = JSON(result) {
        completion(deserialised["name"]?.stringValue)
      }
    }
  }

  static func getLocation(completion: @escaping (_: String?) -> Void) {
    let request: GraphRequest =
        GraphRequest(graphPath: "me", parameters: ["fields" : "location"],      // swiftlint:disable:this colon
          tokenString: AccessToken.current?.tokenString, version: nil,
          httpMethod: .get)
    request.start { (_, result, error) in
      guard let result = result else {
        print("unable to execute GraphQL query: \(String(describing: error))")
        completion(nil)
        return
      }
      if let deserialised = JSON(result) {
        completion(deserialised["location"]?["name"]?.stringValue)
      }
    }
  }

  static func profileImage(for fbid: String,
                           completion: @escaping (_: URL?) -> Void) {
    let request: GraphRequest =
        GraphRequest(graphPath: "/\(fbid)/picture?type=large&redirect=false",
                     parameters: ["fields" : ""],                               // swiftlint:disable:this colon
                     tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)
    request.start { (_, result, error) in
      guard let result = result else {
        print("unable to execute GraphQL query: \(String(describing: error))")
        completion(nil)
        return
      }
      if let deserialised = JSON(result) {
        if let url = deserialised["data"]?["url"]?.stringValue {
          completion(URL(string: url))
        }
      }
    }
  }
}
