
import FBSDKCoreKit

struct Friend {
  let fbid: String
  let display_name: String
  let first_name: String
  let last_name: String
  let picture_url: String
}

enum QueryLimit {
  case none
  case count(Int)
}

private enum FriendType {
  case Taggable
  case AppUsers
}

class Facebook {
  typealias EnumerationCallback = (_: Friend) -> Void

  private static func deserialiseFriend(_ json: NSDictionary) -> Friend? {
    guard
      let id = json.value(forKey: "id") as? String,
      let name = json.value(forKey: "name") as? String,
      let first_name = json.value(forKey: "first_name") as? String,
      let last_name = json.value(forKey: "last_name") as? String,

      let picture = json.value(forKey: "picture") as? NSDictionary,
      let picture_data = picture.value(forKey: "data") as? NSDictionary,
      let picture_url = picture_data.value(forKey: "url") as? String
    else {
      return nil
    }

    return Friend(fbid: id, display_name: name, first_name: first_name,
                  last_name: last_name, picture_url: picture_url)
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

    let path = type == .Taggable ? "me/taggable_friends" : "me/friends"
    let request = FBSDKGraphRequest(graphPath: path, parameters: params)
    _ = request?.start { (_: FBSDKGraphRequestConnection?,
                          result: Any?,
                          error: Error?) in
      guard error == nil else {
        print("error executing GraphQL query: \(String(describing: error))")
        return
      }
      guard let deserialised = result as? NSDictionary else {
        print("unable to deserialise response \(String(describing: result))")
        return
      }

      if let data = deserialised.value(forKey: "data") as? NSArray {
        for serialised in data {
          guard
            let deserialised = serialised as? NSDictionary,
            let friend = deserialiseFriend(deserialised)
          else {
            print("unable to deserialise friend \(serialised)")
            continue
          }

          handler(friend)
          retrieved = retrieved + 1
        }
      }

      if let pagination = deserialised.value(forKey: "paging") as? NSDictionary {
        if let cursors = pagination.value(forKey: "cursors") as? NSDictionary {
          if let after = cursors.value(forKey: "after") as? String {
            switch limit {
            case .none:
              self.enumerateFriends(type: type, limit: .none, cursor: after,
                                    handler: handler)
              break
            case .count(let count):
              self.enumerateFriends(type: type, limit: .count(count - retrieved),
                                    cursor: after, handler: handler)
            }
          }
        }
      }
    }
  }

  static func getTaggableFriends(limit : QueryLimit,
                                 handler: @escaping EnumerationCallback) {
    enumerateFriends(type: .Taggable, limit: limit, cursor: nil,
                     handler: handler)
  }

  static func getUserFriends(limit: QueryLimit,
                             handler: @escaping EnumerationCallback) {
    enumerateFriends(type: .AppUsers, limit: limit, cursor: nil,
                     handler: handler)
  }
}

