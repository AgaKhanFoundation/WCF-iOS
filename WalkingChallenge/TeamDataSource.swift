
import Foundation

class TeamDataSource: TableDataSource {
  var cells = [CellInfo]()

  func reload(completion: @escaping SuccessBlock) {
    // TODO: Fetch team from backend

    if cells.isEmpty {
      self.cells.append(TeamNameCellInfo(name: "Team Name"))
      Facebook.getTaggableFriends(limit: .count(12)) { (friend) in
        self.cells.append(TeamMemberCellInfo(name: friend.display_name, picture: friend.picture_url))
        onMain {
          completion(true)
        }
      }
    }
  }

  func addTeamMember(completion: @escaping SuccessBlock) {
    // TODO: Push data to backend and refresh cells

    // cells.append(TeamMemberCellInfo(name: "Someone New"))

    onMain {
      completion(true)
    }
  }
}
