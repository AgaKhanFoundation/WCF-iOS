import Foundation

extension APIClient {
  static func getTeamsRequest(completion: @escaping APIClientResultCompletion) {
    let request = Request(endpoint: .teams)
    APIClient.shared.request(request, completion: completion)
  }
  
  static func getTeamRequest(teamID: Int64, completion: @escaping APIClientResultCompletion) {
    let request = Request(endpoint: .team(teamID))
    APIClient.shared.request(request, completion: completion)
  }
  
  static func createTeamRequest(teamName: String, completion: @escaping APIClientResultCompletion) {
    let params: JSON = ["name": teamName]
    let request = Request(endpoint: .teams, method: .post, params: params)
    APIClient.shared.request(request, completion: completion)
  }
  
  static func editTeamRequest(teamID: Int64, teamName: String, completion: @escaping APIClientResultCompletion) {
    let params: JSON = ["name": teamName]
    let request = Request(endpoint: .team(teamID), method: .patch, params: params)
    APIClient.shared.request(request, completion: completion)
  }
  
  static func deleteTeamRequest(teamID: Int64, completion: @escaping APIClientResultCompletion) {
    let request = Request(endpoint: .team(teamID), method: .delete)
    APIClient.shared.request(request, completion: completion)
  }
}
