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
@testable import Steps4Impact

class AKFCausesServiceMock: AKFCausesServicing {
  
  var createParticipantCompletionResult: ServiceRequestResult?
  var createParticipantCallCount: Int = 0
  func createParticipant(fbid: String, completion: ServiceRequestCompletion?) {
    createParticipantCallCount += 1
    if let result = createParticipantCompletionResult {
      completion?(result)
    }
  }
  
  var getParticipantCompletionResult: ServiceRequestResult?
  var getParticipantCallCount: Int = 0
  func getParticipant(fbid: String, completion: ServiceRequestCompletion?) {
    getParticipantCallCount += 1
    if let result = getParticipantCompletionResult {
      completion?(result)
    }
  }
  
  var deleteParticipantCompletionResult: ServiceRequestResult?
  var deleteParticipantCallCount: Int = 0
  func deleteParticipant(fbid: String, completion: ServiceRequestCompletion?) {
    deleteParticipantCallCount += 1
    if let result = deleteParticipantCompletionResult {
      completion?(result)
    }
  }
  
  var createTeamCompletionResult: ServiceRequestResult?
  var createTeamCallCount: Int = 0
  func createTeam(name: String, lead fbid: String, completion: ServiceRequestCompletion?) {
    createTeamCallCount += 1
    if let result = createTeamCompletionResult {
      completion?(result)
    }
  }
  
  var deleteTeamCompletionResult: ServiceRequestResult?
  var deleteTeamCallCount: Int = 0
  func deleteTeam(team: Int, completion: ServiceRequestCompletion?) {
    deleteTeamCallCount += 1
    if let result = deleteTeamCompletionResult {
      completion?(result)
    }
  }
  
  var getTeamsCompletionResult: ServiceRequestResult?
  var getTeamsCallCount: Int = 0
  func getTeams(completion: ServiceRequestCompletion?) {
    getTeamsCallCount += 1
    if let result = getTeamsCompletionResult {
      completion?(result)
    }
  }
  
  var getTeamCompletionResult: ServiceRequestResult?
  var getTeamCallCount: Int = 0
  func getTeam(team: Int, completion: ServiceRequestCompletion?) {
    getTeamCallCount += 1
    if let result = getTeamCompletionResult {
      completion?(result)
    }
  }
  
  var joinTeamCompletionResult: ServiceRequestResult?
  var joinTeamCallCount: Int = 0
  func joinTeam(fbid: String, team: Int, completion: ServiceRequestCompletion?) {
    joinTeamCallCount += 1
    if let result = joinTeamCompletionResult {
      completion?(result)
    }
  }
  
  var leaveTeamCompletionResult: ServiceRequestResult?
  var leaveTeamCallCount: Int = 0
  func leaveTeam(fbid: String, completion: ServiceRequestCompletion?) {
    leaveTeamCallCount += 1
    if let result = leaveTeamCompletionResult {
      completion?(result)
    }
  }
  
  var performAPIHealthCheckCompletionResult: ServiceRequestResult?
  var performAPIHealthCheckCallCount: Int = 0
  func performAPIHealthCheck(completion: ServiceRequestCompletion?) {
    performAPIHealthCheckCallCount += 1
    if let result = performAPIHealthCheckCompletionResult {
      completion?(result)
    }
  }
  
  var getEventCompletionResult: ServiceRequestResult?
  var getEventCallCount: Int = 0
  func getEvent(event: Int, completion: ServiceRequestCompletion?) {
    getEventCallCount += 1
    if let result = getEventCompletionResult {
      completion?(result)
    }
  }
  
  var getEventsCompletionResult: ServiceRequestResult?
  var getEventsCallCount: Int = 0
  func getEvents(completion: ServiceRequestCompletion?) {
    getEventsCallCount += 1
    if let result = getEventsCompletionResult {
      completion?(result)
    }
  }
  
  var getRecordCompletionResult: ServiceRequestResult?
  var getRecordCallCount: Int = 0
  func getRecord(record: Int, completion: ServiceRequestCompletion?) {
    getRecordCallCount += 1
    if let result = getRecordCompletionResult {
      completion?(result)
    }
  }
  
  var createRecordCompletionResult: ServiceRequestResult?
  var createRecordCallCount: Int = 0
  func createRecord(record: Record, completion: ServiceRequestCompletion?) {
    createRecordCallCount += 1
    if let result = createRecordCompletionResult {
      completion?(result)
    }
  }
  
  var getSourceCompletionResult: ServiceRequestResult?
  var getSourceCallCount: Int = 0
  func getSource(source: Int, completion: ServiceRequestCompletion?) {
    getSourceCallCount += 1
    if let result = getSourceCompletionResult {
      completion?(result)
    }
  }
  
  var getSourcesCompletionResult: ServiceRequestResult?
  var getSourcesCallCount: Int = 0
  func getSources(completion: ServiceRequestCompletion?) {
    getSourcesCallCount += 1
    if let result = getSourcesCompletionResult {
      completion?(result)
    }
  }
  
  var joinEventCompletionResult: ServiceRequestResult?
  var joinEventCallCount: Int = 0
  func joinEvent(fbid: String, eventID: Int, miles: Int, completion: ServiceRequestCompletion?) {
    joinEventCallCount += 1
    if let result = joinEventCompletionResult {
      completion?(result)
    }
  }
  
  var getSourceByNameCompletionResult: ServiceRequestResult?
  var getSourceByNameCallCount: Int = 0
  func getSourceByName(source: String, completion: ServiceRequestCompletion?) {
    getSourceByNameCallCount += 1
    if let result = getSourceByNameCompletionResult {
      completion?(result)
    }
  }
}
