
import FBSDKCoreKit

struct Friend {
  let fbid : String
  let name : String
  let picture_url : String
}

class Facebook {
  private static func enumerateFriends(cursor: String?, handler: @escaping (_ : Friend) -> Void) {
    var params = [ "fields" : "id, name, picture" ]
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
          let name = (friend as! NSDictionary).value(forKey: "name") as! String
          let id = (friend as! NSDictionary).value(forKey: "id") as! String
          let picture = (friend as! NSDictionary).value(forKey: "picture") as! NSDictionary
          let picture_url = (picture.value(forKey: "data") as! NSDictionary).value(forKey: "url") as! String
          handler(Friend(fbid: id, name: name, picture_url: picture_url))
        }
      }
      if let pagination = (result as! NSDictionary).value(forKey: "paging") as? NSDictionary {
        if let cursors = pagination.value(forKey: "cursors") as? NSDictionary {
          if let after = cursors.value(forKey: "after") as? String {
            self.enumerateFriends(cursor: after, handler: handler)
          }
        }
      }
    }
  }

  static func getTaggableFriends(handler: @escaping (_ : Friend) -> Void) {
    enumerateFriends(cursor: nil, handler: handler)
  }
}

