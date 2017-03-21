
import FBSDKCoreKit

class FriendList {
  private func getTaggableFriends(cursor: String?) {
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
          print("friend (\(name), \(id), \(picture_url))")
        }
      }
      if let pagination = (result as! NSDictionary).value(forKey: "paging") as? NSDictionary {
        if let cursors = pagination.value(forKey: "cursors") as? NSDictionary {
          if let after = cursors.value(forKey: "after") as? String {
            self.getTaggableFriends(cursor: after)
          }
        }
      }
    }
  }

  func getTaggableFriends() {
    getTaggableFriends(cursor: nil)
  }
}

