
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

class Facebook {
  private static func enumerateFriends(limit : QueryLimit, cursor: String?, handler: @escaping (_ : Friend) -> Void) {
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

    let request = FBSDKGraphRequest(graphPath: "me/taggable_friends",
                                    parameters: params)
    _ = request?.start { (_: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
      guard error == nil else {
        return
      }
      // print("result: \(result)")
      if let data = (result as! NSDictionary).value(forKey: "data") as! NSArray? {
        for friend in data {
          let friend = friend as! NSDictionary
          let name = friend.value(forKey: "name") as! String
          let first_name = friend.value(forKey: "first_name") as! String
          let last_name = friend.value(forKey: "last_name") as! String
          let id = friend.value(forKey: "id") as! String
          let picture = friend.value(forKey: "picture") as! NSDictionary
          let picture_url = (picture.value(forKey: "data") as! NSDictionary).value(forKey: "url") as! String
          handler(Friend(fbid: id, display_name: name, first_name: first_name, last_name: last_name, picture_url: picture_url))
          retrieved = retrieved + 1
          switch limit {
          case .none:
            break
          case .count(let count):
            if retrieved == count {
              return
            }
            break
          }
        }
      }
      if let pagination = (result as! NSDictionary).value(forKey: "paging") as? NSDictionary {
        if let cursors = pagination.value(forKey: "cursors") as? NSDictionary {
          if let after = cursors.value(forKey: "after") as? String {
            switch limit {
            case .none:
              self.enumerateFriends(limit: .none, cursor: after, handler: handler)
              break
            case .count(let count):
              self.enumerateFriends(limit: .count(count - retrieved), cursor: after, handler: handler)
            }
          }
        }
      }
    }
  }

  static func getTaggableFriends(limit : QueryLimit, handler: @escaping (_ : Friend) -> Void) {
    enumerateFriends(limit : limit, cursor: nil, handler: handler)
  }
}

