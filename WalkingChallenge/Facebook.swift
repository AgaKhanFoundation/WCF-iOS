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

import FBSDKCoreKit
import FBSDKShareKit

struct Friend {
  let fbid: String
  let displayName: String
  let firstName: String
  let lastName: String
  let pictureRawURL: String
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

  private static func deserialiseFriend(_ json: [String:Any])
      -> Friend? {
    guard
      let id = json["id"] as? String,
      let name = json["name"] as? String,
      let first_name = json["first_name"] as? String,
      let last_name = json["last_name"] as? String,

      let picture = json["picture"] as? [String:Any],
      let picture_data = picture["data"] as? [String:Any],
      let picture_url = picture_data["url"] as? String
    else {
      return nil
    }

    return Friend(fbid: id, displayName: name, firstName: first_name,
                      lastName: last_name, pictureRawURL: picture_url)
  }

  private static func enumerateFriends(type: FriendType,
                                       limit: QueryLimit,
                                       cursor: String?,
                                       handler: @escaping EnumerationCallback) {
    var retrieved = 0
    var params = [ "fields": "id, name, first_name, last_name, picture" ]

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
    let request = FBSDKGraphRequest(graphPath: path, parameters: params)
    _ = request?.start {
      (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        guard error == nil else {
          print("error executing GraphQL query: \(String(describing: error))")
          return
        }
        guard let deserialised = result as? [String:Any] else {
          print("unable to deserialise response \(String(describing: result))")
          return
        }

        if let data = deserialised["data"] as? [Any] {
          for serialised in data {
            guard
              let deserialised = serialised as? [String:Any],
              let friend = deserialiseFriend(deserialised)
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
              }
            }
          }
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
    let request = FBSDKGraphRequest(graphPath: "me",
                                    parameters: ["fields": "name"])
    _ = request?.start {
      (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        guard error == nil else {
          print("unable to execute GraphQL query: \(String(describing: error))")
          return
        }
        guard let deserialised = result as? [String:Any] else {
          print("unable to deserialise response \(String(describing: result))")
          return
        }

        completion(deserialised["name"] as? String)
    }
  }

  static func getLocation(completion: @escaping (_: String?) -> Void) {
    let request = FBSDKGraphRequest(graphPath: "me",
                                    parameters: ["fields": "location"])
    _ = request?.start {
      (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        guard error == nil else {
          print("unable to execute GraphQL query: \(String(describing: error))")
          return
        }
        guard let deserialised = result as? [String:Any] else {
          print("unable to deserialise response \(String(describing: result))")
          return
        }

        if let location = deserialised["location"] as? Dictionary<String, Any> {
          completion(location["name"] as? String)
        }
    }
  }

  static func invite(url: String, image: String? = nil) {
    let invite = FBSDKAppInviteContent()
    invite.appLinkURL = URL(string: url)!
    if let image = image {
      invite.appInvitePreviewImageURL = URL(string: image)!
    }

    let dialog = FBSDKAppInviteDialog()
    dialog.content = invite
    if dialog.canShow() {
      dialog.show()
    }
  }

  static func profileImage(for fbid: String,
                           completion: @escaping (_: URL?) -> Void) {
    let request =
      FBSDKGraphRequest(graphPath: "/\(fbid)/picture?type=large&redirect=false",
                        parameters: ["fields": ""])
    _ = request?.start {
      (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        guard error == nil else {
          print("unable to execute GraphQL query: \(String(describing: error))")
          return
        }
        guard let deserialised = result as? [String:Any] else {
          print("unable to deserialise response \(String(describing: result))")
          return
        }

        if let data = deserialised["data"] as? [String:Any] {
          if let url = data["url"] as? String {
            completion(URL(string: url))
          }
        }
    }
  }
}
