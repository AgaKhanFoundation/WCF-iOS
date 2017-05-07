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

extension APIClient {
  static func getAPIHealthCheck(completion: @escaping APIClientResultCompletion) {
    let request = Request(endpoint: .healthCheck)
    APIClient.shared.request(request, completion: completion)
  }

  static func createParticipant(fbid: String,
                                completion: @escaping APIClientResultCompletion) {
    let params: JSON = ["fbid" : fbid]
    let request = Request(endpoint: .participants, method: .post, params: params)
    APIClient.shared.request(request, completion: completion)
  }

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
