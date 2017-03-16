
import Foundation

class TeamDataSource: TableDataSource {
  var cells = [CellInfo]()

  func reload(completion: @escaping SuccessBlock) {
    // TODO: Fetch team from backend

    if cells.isEmpty {
      cells = [
        TeamNameCellInfo(name: "Team Name"),
        TeamMemberCellInfo(name: "Sarah Jane"),
        TeamMemberCellInfo(name: "Mark Stevens"),
        TeamMemberCellInfo(name: "Ali Noorali")
      ]
    }

    onMain {
      completion(true)
    }
  }

  func addTeamMember(completion: @escaping SuccessBlock) {
    // TODO: Push data to backend and refresh cells

    cells.append(TeamMemberCellInfo(name: "Someone New"))

    onMain {
      completion(true)
    }
  }
}
