/**
 * Copyright © 2017 Aga Khan Foundation
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

  init?(json: [String:Any]) {
    guard
      let fbid = json["id"] as? String,
      let displayName = json["name"] as? String,
      let firstName = json["first_name"] as? String,
      let lastName = json["last_name"] as? String,

      let picture = json["picture"] as? [String:Any],
      let picture_data = picture["data"] as? [String:Any],
      let picture_url = picture_data["url"] as? String
    else { return nil }

    self.fbid = fbid
    self.displayName = displayName
    self.firstName = firstName
    self.lastName = lastName
    self.pictureRawURL = picture_url
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

  private static func enumerateFriends(type: FriendType, limit: QueryLimit,
                                       cursor: String?,
                                       handler: @escaping EnumerationCallback) {
    var retrieved = 0
    var params = [ "fields" : "id, name, first_name, last_name, picture" ]

    switch limit {
    case .none:
      break
    case .count(let count):
      params["limit"] = String(count)
      break
    }

    if cursor != nil {
      params["after"] = cursor!
    }

    let path = type == .taggable ? "me/taggable_friends" : "me/friends"

    let request: GraphRequest =
        GraphRequest(graphPath: path, parameters: params,
                     accessToken: AccessToken.current, httpMethod: .GET,
                     apiVersion: .defaultVersion)
    request.start { (response, result) in
      switch result {
      case .success(let response):
        if let deserialised = response.dictionaryValue {
          if let data = deserialised["data"] as? [Any] {
            for serialised in data {
              guard
                let deserialised = serialised as? [String: Any],
                let friend = Friend(json: deserialised)
              else {
                print("unable to deserialise friend \(serialised)")
                continue
              }

              handler(friend)
              retrieved += 1
            }
          }

          if let pagination = deserialised["paging"] as? [String:Any] {
            if let cursors = pagination["cursors"] as? [String:Any] {
              if let after = cursors["after"] as? String {
                switch limit {
                case .none:
                  self.enumerateFriends(type: type, limit: .none, cursor: after,
                                        handler: handler)
                  break
                case .count(let count):
                  self.enumerateFriends(type: type,
                                        limit: .count(count - retrieved),
                                        cursor: after, handler: handler)
                  break
                }
              }
            }
          }
        }
        break
      case .failed(let error):
        print("error executing GraphQL query: \(String(describing: error))")
        break
      }
    }
  }

  static func getTaggableFriends(limit: QueryLimit,
                                 handler: @escaping EnumerationCallback) {
    enumerateFriends(type: .taggable, limit: limit, cursor: nil,
                     handler: handler)
  }

  static func getUserFriends(limit: QueryLimit,
                             handler: @escaping EnumerationCallback) {
    enumerateFriends(type: .appUsers, limit: limit, cursor: nil,
                     handler: handler)
  }

  static func getRealName(completion: @escaping (_: String?) -> Void) {
    let request: GraphRequest =
        GraphRequest(graphPath: "me", parameters: ["fields" : "name"],
                     accessToken: AccessToken.current, httpMethod: .GET,
                     apiVersion: .defaultVersion)
    request.start { (response, result) in
      switch result {
      case .success(let response):
        if let deserialised = response.dictionaryValue {
          if let name = deserialised["name"] as? String {
            completion(name)
          }
        }
        break
      case .failed(let error):
        print("unable to execute GraphQL query \(String(describing: error))")
        break
      }
    }
  }

  static func getLocation(completion: @escaping (_: String?) -> Void) {
    let request: GraphRequest =
        GraphRequest(graphPath: "me", parameters: ["fields" : "location"],
                     accessToken: AccessToken.current, httpMethod: .GET,
                     apiVersion: .defaultVersion)
    request.start { (response, result) in
      switch result {
      case .success(let response):
        if let deserialised = response.dictionaryValue {
          if let location = deserialised["location"] as? [String:Any] {
            completion(location["name"] as? String)
          }
        }
        break
      case .failed(let error):
        print("unable to execute GraphQL query: \(String(describing: error))")
        break
      }
    }
  }

  static func invite(url: String, image: String? = nil) {
    var invite: AppInvite = AppInvite(appLink: URL(string: url)!)
    if let image = image {
      invite.previewImageURL = URL(string: image)!
    }

    let dialog: AppInvite.Dialog = AppInvite.Dialog(invite: invite)
    try? dialog.show()
  }

  static func profileImage(for fbid: String,
                           completion: @escaping (_: URL?) -> Void) {
    let request: GraphRequest =
        GraphRequest(graphPath: "/\(fbid)/picture?type=large&redirect=false",
                     parameters: ["fields" : ""],
                     accessToken: AccessToken.current, httpMethod: .GET,
                     apiVersion: .defaultVersion)
    request.start { (response, result) in
      switch result {
      case .success(let response):
        if let deserialised = response.dictionaryValue {
          if let data = deserialised["data"] as? [String:Any] {
            if let url = data["url"] as? String {
              completion(URL(string: url))
            }
          }
        }
        break
      case .failed(let error):
        print("unable to execute GraphQL query: \(String(describing: error))")
        break
      }
    }
  }
}
