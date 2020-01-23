/**
 * Copyright © 2019 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import Foundation

enum AKFCausesEndPoint {
  case healthcheck
  case participant(fbId: String)
  case participants
  case team(teamId: Int)
  case teams
  case event(eventId: Int)
  case events
  case record(recordId: Int)
  case records
  case leaderboard(eventId: Int)
  case source(sourceId: Int)
  case sources
  case commitment
  case commitments(id: Int) // swiftlint:disable:this identifier_name
  case achievement
  case notifications(fbId: String, eventId: Int)
  case notification(notificationId: Int)
}

extension AKFCausesEndPoint {
  public var rawValue: String {
    switch self {
    case .healthcheck:
      return "/"
    case .participant(let fbid):
      return "/participants/\(fbid)"
    case .participants:
      return "/participants"
    case .team(let teamId):
      return "/teams/\(teamId)"
    case .teams:
      return "/teams"
    case .event(let eventId):
      return "/events/\(eventId)"
    case .events:
      return "/events"
    case .record(let recordId):
      return "/records/\(recordId)"
    case .records:
      return "/records"
    case .leaderboard(let eventId):
      return "/teams/stats/\(eventId)"
    case .source(let sourceId):
      return "/sources/\(sourceId)"
    case .sources:
      return "/sources"
    case .commitment:
      return "/commitments"
    case .commitments(let cid):
      return "/commitments/\(cid)"
    case .achievement:
      return "/achievement"
    case .notifications(let fbId, let eventId):
      return "notifications/participant/\(fbId)/event/\(eventId)"
    case .notification(let notificationId):
      return "notifications/participant/\(notificationId)"
    }
  }
}

class AKFCausesService: Service {
  public static var shared: AKFCausesService =
      AKFCausesService(server: AppConfig.server)

  init(server: URLComponents) {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = ["Authorization": "Basic \(AppConfig.serverPassword)"]
    super.init(server: server, session: URLSession(configuration: config))
  }

  private func request(_ method: HTTPMethod = .get,
                       endpoint: AKFCausesEndPoint,
                       query: JSON? = nil,
                       parameters: JSON? = nil,
                       completion: ServiceRequestCompletion?) {
    guard let url = buildURL(endpoint.rawValue, query) else {
      self.callback(completion, result: .failed(nil))
      return
    }
    request(method, url: url, parameters: parameters, completion: completion)
  }

  static func createParticipant(fbid: String,
                                completion: ServiceRequestCompletion? = nil) {
    shared.request(.post, endpoint: .participants,
                   parameters: JSON(["fbid": fbid]), completion: completion)
  }

  static func getParticipant(fbid: String,
                             completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .participant(fbId: fbid), completion: completion)
  }

  static func deleteParticipant(fbid: String,
                                completion: ServiceRequestCompletion? = nil) {
    shared.request(.delete, endpoint: .participant(fbId: fbid), completion: completion)
  }

  static func createTeam(name: String, imageName: String = "", lead fbid: String, hidden: Bool = false,
                         completion: ServiceRequestCompletion? = nil) {
    shared.request(.post, endpoint: .teams,
                   parameters: JSON([
                     "name": name,
                     "image": imageName,
                     "creator_id": fbid,
                     "hidden": hidden
                   ]),
                   completion: completion)
  }

  static func deleteTeam(team: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(.delete, endpoint: .team(teamId: team), completion: completion)
  }

  static func getTeams(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .teams, completion: completion)
  }

  static func getTeam(team: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .team(teamId: team), completion: completion)
  }

  static func getAchievement(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .achievement, completion: completion)
  }

  static func joinTeam(fbid: String, team: Int,
                       completion: ServiceRequestCompletion? = nil) {
    shared.request(.patch, endpoint: .participant(fbId: fbid),
                   parameters: JSON(["team_id": team]), completion: completion)
  }

  static func leaveTeam(fbid: String, completion: ServiceRequestCompletion? = nil) {
    shared.request(.patch, endpoint: .participant(fbId: fbid),
                   parameters: JSON(["team_id": "null"]), completion: completion)
  }
  static func editTeamName(teamId: Int, name: String, completion: ServiceRequestCompletion? = nil) {
    shared.request(.patch, endpoint: .team(teamId: teamId),
                   parameters: JSON(["name": name]), completion: completion)
  }
  static func performAPIHealthCheck(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .healthcheck, completion: completion)
  }

  static func getEvent(event: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .event(eventId: event), completion: completion)
  }

  static func getEvents(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .events, completion: completion)
  }

  static func getRecord(record: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .record(recordId: record), completion: completion)
  }

  static func getLeaderboard(eventId: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .leaderboard(eventId: eventId), completion: completion)
  }

  static func createRecord(for participantID: Int,
                           dated: Date = Date.init(timeIntervalSinceNow: 0),
                           steps: Int, sourceID: Int,
                           completion: ServiceRequestCompletion? = nil) {
    shared.request(.post, endpoint: .records, parameters: JSON([
      "date": Date.formatter.string(from: dated),
      "distance": steps,
      "participant_id": participantID,
      "source_id": sourceID
    ]), completion: completion)
  }

  static func getSource(source: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .source(sourceId: source), completion: completion)
  }

  static func getSources(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .sources, completion: completion)
  }

  static func joinEvent(fbid: String, eventID: Int, steps: Int,
                        commpletion: ServiceRequestCompletion? = nil) {
    shared.request(.post, endpoint: .commitment,
                   parameters: JSON(["fbid": fbid, "event_id": eventID, "commitment": steps]),
                   completion: commpletion)
  }

  static func setCommitment(_ commitment: Int, toSteps steps: Int,
                            completion: ServiceRequestCompletion? = nil) {
    shared.request(.patch, endpoint: .commitments(id: commitment),
                   parameters: JSON(["commitment": steps]),
                   completion: completion)
  }

  static func getNotifications(fbId: String, eventId: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .notifications(fbId: fbId, eventId: eventId), completion: completion)
  }

  static func updateNotification(notificationId: Int, readFlag: Bool, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .notification(notificationId: notificationId),
                   parameters: JSON(["read_flag": readFlag]), completion: completion)
  }
}

extension AKFCausesService {
  static func getSourceByName(source: String, completion: ServiceRequestCompletion? = nil) {
    getSources { result in
      switch result {
      case .failed(let error):
        shared.callback(completion, result: .failed(error))

      case .success(let status, let response):
        let source: JSON? =
            response?.arrayValue?.filter { Source(json: $0)?.name == source }.first
        shared.callback(completion, result: .success(statusCode: status, response: source))
      }
    }
  }
}
