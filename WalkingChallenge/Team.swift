
import Foundation

class Team: TableDataSource {
  var cells = [CellInfo]()

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var name: String {
    // TODO(compnerd) fetch this from the backend
    return "Walk4Change"
  }

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var size: Int {
    // TODO(compnerd) fetch this from the backend
    return 7
  }

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var limit: Int {
    // TODO(compnerd) fetch this from the backend
    return 11
  }

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var leaders: [String] {
    // TODO(compnerd) fetch this from the backend
    return [ "Alpha", "Beta", "Gamma" ]
  }

  func reload(completion: @escaping SuccessBlock) {
    guard cells.isEmpty else { return }

    self.cells.append(TeamNameCellInfo(name: Team.name))
  }

  func addTeamMember(completion: @escaping SuccessBlock) {
    // TODO: Push data to backend and refresh cells

    // cells.append(TeamMemberCellInfo(name: "Someone New"))

    onMain {
      completion(true)
    }
  }
}
