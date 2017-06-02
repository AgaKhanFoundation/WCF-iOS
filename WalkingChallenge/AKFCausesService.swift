/**
 * Copyright © 2017 Aga Khan Foundation
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
  internal typealias FacebookID = String
  internal typealias TeamID = Int
  internal typealias EventID = Int
  internal typealias SourceID = Int

  case healthcheck
  case participant(FacebookID)
  case participants
  case team(TeamID)
  case teams
  case event(EventID)
  case events
  case source(SourceID)
  case sources
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
    case .team(let id):
      return "/teams/\(id)"
    case .teams:
      return "/teams"
    case .event(let id):
      return "/events/\(id)"
    case .events:
      return "/events"
    case .source(let id):
      return "/sources/\(id)"
    case .sources:
      return "/sources"
    }
  }
}

class AKFCausesService: Service {
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

  static func createParticipant(fbid: String,
                                completion: ServiceRequestCompletion? = nil) {
    shared.request(.post, endpoint: .participants,
                   parameters: JSON(["fbid": fbid]), completion: completion)
  }

  static func getParticipant(fbid: String,
                             completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .participant(fbid), completion: completion)
  }

  static func getTeam(team: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .team(team), completion: completion)
  }

  static func performAPIHealthCheck(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .healthcheck, completion: completion)
  }

  static func getEvent(event: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .event(event), completion: completion)
  }

  static func getEvents(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .events, completion: completion)
  }

  static func getSource(source: Int, completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .source(source), completion: completion)
  }

  static func getSources(completion: ServiceRequestCompletion? = nil) {
    shared.request(endpoint: .sources, completion: completion)
  }

  static func joinEvent(fbid: String, eventID: Int,
                        commpletion: ServiceRequestCompletion? = nil) {
    shared.request(.patch, endpoint: .participant(fbid),
                   parameters: JSON(["event_id": eventID]),
                   completion: commpletion)
  }
}

extension AKFCausesService {
  static func getSourceByName(source: String, completion: ServiceRequestCompletion? = nil) {
    getSources { result in
      switch result {
      case .failed(let error):
        shared.callback(completion, result: .failed(error))
        break
      case .success(let status, let response):
        let source: JSON? =
            response?.arrayValue?.filter { Source(json: $0)?.name == source }.first
        shared.callback(completion, result: .success(status, source))
        break
      }
    }
  }
}
