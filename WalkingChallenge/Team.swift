
import Foundation

class Team: TableDataSource {
  var cells = [CellInfo]()

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var name: String {
    // TODO(compnerd) fetch this from the backend
    return "Team Name"
  }

  func reload(completion: @escaping SuccessBlock) {
    guard cells.isEmpty else { return }

    self.cells.append(TeamNameCellInfo(name: Team.name))
    Facebook.getTaggableFriends(limit: .count(12)) { (friend) in
      self.cells.append(TeamMemberCellInfo(for: friend))
      onMain {
        completion(true)
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
