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
  case source(sourceId: Int)
  case sources
  case commitment(fbid: String)
  case commitments
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
    case .source(let sourceId):
      return "/sources/\(sourceId)"
    case .sources:
      return "/sources"
    case .commitment(let fbid):
      return "/commitments/participant/\(fbid)"
    case .commitments:
      return "/commitments"
    }
  }
}

protocol AKFCausesServiceConsumer: Consumer {
  var akfCausesService: AKFCausesServicing? { get set }
}

protocol AKFCausesServicing {
  func createParticipant(fbid: String, completion: ServiceRequestCompletion?)
  func getParticipant(fbid: String, completion: ServiceRequestCompletion?)
  func deleteParticipant(fbid: String, completion: ServiceRequestCompletion?)
  func createTeam(name: String, lead fbid: String, completion: ServiceRequestCompletion?)
  func deleteTeam(team: Int, completion: ServiceRequestCompletion?)
  func getTeams(completion: ServiceRequestCompletion?)
  func getTeam(team: Int, completion: ServiceRequestCompletion?)
  func joinTeam(fbid: String, team: Int, completion: ServiceRequestCompletion?)
  func leaveTeam(fbid: String, completion: ServiceRequestCompletion?)
  func performAPIHealthCheck(completion: ServiceRequestCompletion?)
  func getEvent(event: Int, completion: ServiceRequestCompletion?)
  func getEvents(completion: ServiceRequestCompletion?)
  func getRecord(record: Int, completion: ServiceRequestCompletion?)
  func createRecord(record: Record, completion: ServiceRequestCompletion?)
  func getSource(source: Int, completion: ServiceRequestCompletion?)
  func getSources(completion: ServiceRequestCompletion?)
  func joinEvent(fbid: String, eventID: Int, miles: Int, commpletion: ServiceRequestCompletion?)
  func getSourceByName(source: String, completion: ServiceRequestCompletion?)
}

class AKFCausesService: Service, AKFCausesServicing {
  public static var shared: AKFCausesService =
      AKFCausesService(server: AppConfig.server)

  init(server: URLComponents) {
    super.init(server: server, session: URLSession(configuration: .default))
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

  func createParticipant(fbid: String,
                                completion: ServiceRequestCompletion? = nil) {
    request(.post, endpoint: .participants,
                   parameters: JSON(["fbid": fbid]), completion: completion)
  }

  func getParticipant(fbid: String,
                             completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .participant(fbId: fbid), completion: completion)
  }

  func deleteParticipant(fbid: String,
                                completion: ServiceRequestCompletion? = nil) {
    request(.delete, endpoint: .participant(fbId: fbid), completion: completion)
  }

  func createTeam(name: String, lead fbid: String,
                         completion: ServiceRequestCompletion? = nil) {
    request(.post, endpoint: .teams,
                   parameters: JSON(["name": name, "creator_id": fbid]),
                   completion: completion)
  }

  func deleteTeam(team: Int, completion: ServiceRequestCompletion? = nil) {
    request(.delete, endpoint: .team(teamId: team), completion: completion)
  }

  func getTeams(completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .teams, completion: completion)
  }

  func getTeam(team: Int, completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .team(teamId: team), completion: completion)
  }

  func joinTeam(fbid: String, team: Int,
                       completion: ServiceRequestCompletion? = nil) {
    request(.patch, endpoint: .participant(fbId: fbid),
                   parameters: JSON(["team_id": team]), completion: completion)
  }

  func leaveTeam(fbid: String, completion: ServiceRequestCompletion? = nil) {
    request(.patch, endpoint: .participant(fbId: fbid),
                   parameters: JSON(["team_id": nil]), completion: completion)
  }

  func performAPIHealthCheck(completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .healthcheck, completion: completion)
  }

  func getEvent(event: Int, completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .event(eventId: event), completion: completion)
  }

  func getEvents(completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .events, completion: completion)
  }

  func getRecord(record: Int, completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .record(recordId: record), completion: completion)
  }

  func createRecord(record: Record,
                           completion: ServiceRequestCompletion? = nil) {
    guard let source = record.source?.id else {
      callback(completion, result: .failed(nil))
      return
    }

    let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
    request(.post, endpoint: .records,
                   parameters: JSON(["date": formatter.string(from: record.date),
                                     "distance": record.distance,
                                     "participant_id": record.fbid,
                                     "source_id": source]),
                   completion: completion)
  }

  func getSource(source: Int, completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .source(sourceId: source), completion: completion)
  }

  func getSources(completion: ServiceRequestCompletion? = nil) {
    request(endpoint: .sources, completion: completion)
  }

  func joinEvent(fbid: String, eventID: Int, miles: Int,
                        commpletion: ServiceRequestCompletion? = nil) {
    request(.post, endpoint: .commitments,
                   parameters: JSON(["fbid": fbid, "event_id": eventID, "commitment": miles]),
                   completion: commpletion)
  }
}

extension AKFCausesService {
  func getSourceByName(source: String, completion: ServiceRequestCompletion? = nil) {
    getSources { [weak self] result in
      switch result {
      case .failed(let error):
        self?.callback(completion, result: .failed(error))

      case .success(let status, let response):
        let source: JSON? =
            response?.arrayValue?.filter { Source(json: $0)?.name == source }.first
        self?.callback(completion, result: .success(statusCode: status, response: source))
      }
    }
  }
}
