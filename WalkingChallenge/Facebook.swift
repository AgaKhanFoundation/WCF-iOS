
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

  private static func deserialiseFriend(_ json: Dictionary<String, Any>)
      -> Friend? {
    guard
      let id = json["id"] as? String,
      let name = json["name"] as? String,
      let first_name = json["first_name"] as? String,
      let last_name = json["last_name"] as? String,

      let picture = json["picture"] as? Dictionary<String, Any>,
      let picture_data = picture["data"] as? Dictionary<String, Any>,
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
    var params = [ "fields" : "id, name, first_name, last_name, picture" ]

    switch limit {
    case .none:
      break
    case .count(let count):
      params["limit"] = String(count)
      break
    }

    if (cursor != nil) {
      params["after"] = cursor!
    }

    let path = type == .taggable ? "me/taggable_friends" : "me/friends"
    let request = FBSDKGraphRequest(graphPath: path, parameters: params)
    _ = request?.start { (_: FBSDKGraphRequestConnection?,
                          result: Any?,
                          error: Error?) in
      guard error == nil else {
        print("error executing GraphQL query: \(String(describing: error))")
        return
      }
      guard let deserialised = result as? Dictionary<String, Any> else {
        print("unable to deserialise response \(String(describing: result))")
        return
      }

      if let data = deserialised["data"] as? [Any] {
        for serialised in data {
          guard
            let deserialised = serialised as? Dictionary<String, Any>,
            let friend = deserialiseFriend(deserialised)
          else {
            print("unable to deserialise friend \(serialised)")
            continue
          }

          handler(friend)
          retrieved += 1
        }
      }

      if let pagination = deserialised["paging"] as? Dictionary<String, Any> {
        if let cursors = pagination["cursors"] as? Dictionary<String, Any> {
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

  static func getTaggableFriends(limit : QueryLimit,
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
                                    parameters: ["fields" : "name"])
    _ = request?.start {
      (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        guard error == nil else {
          print("unable to execute GraphQL query: \(String(describing: error))")
          return
        }
        guard let deserialised = result as? Dictionary<String, Any> else {
          print("unable to deserialise response \(String(describing: result))")
          return
        }

        completion(deserialised["name"] as? String)
    }
  }

  static func getLocation(completion: @escaping (_: String?) -> Void) {
    let request = FBSDKGraphRequest(graphPath: "me",
                                    parameters: ["fields" : "location"])
    _ = request?.start {
      (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        guard error == nil else {
          print("unable to execute GraphQL query: \(String(describing: error))")
          return
        }
        guard let deserialised = result as? Dictionary<String, Any> else {
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
                           completion: @escaping (_: URL?) -> ()) {
    let request =
      FBSDKGraphRequest(graphPath: "/\(fbid)/picture?type=large&redirect=false",
                        parameters: ["fields" : ""])
    _ = request?.start {
      (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
        guard error == nil else {
          print("unable to execute GraphQL query: \(String(describing: error))")
          return
        }
        guard let deserialised = result as? Dictionary<String, Any> else {
          print("unable to deserialise response \(String(describing: result))")
          return
        }

        if let data = deserialised["data"] as? Dictionary<String, Any> {
          if let url = data["url"] as? String {
            completion(URL(string: url))
          }
        }
    }
  }
}
