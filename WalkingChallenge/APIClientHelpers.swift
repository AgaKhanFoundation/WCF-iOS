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

// MARK: - Request

extension Dictionary {
  func queryParams() -> String {
    var queryParams = [String]()

    for (key, value) in self {
      queryParams.append("\(key)=\(value)")
    }

    return queryParams.joined(separator: "&")
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case delete = "DELETE"
  case patch = "PATCH"
  case post = "POST"
  case put = "PUT"
}

enum Endpoint {
  var rawValue: String {
    switch self {
    case .healthCheck: return ""
    case .participants: return "participants"
    case .teams: return "teams"
    case .team(let id): return "teams/\(id)"
    }
  }

  case healthCheck
  case participants
  case teams
  case team(Int64)
}

struct Request {
  let endpoint: Endpoint
  let method: HTTPMethod
  let params: JSON?
  let query: JSON?

  init(endpoint: Endpoint,
       method: HTTPMethod = .get,
       params: JSON? = nil,
       query: JSON? = nil) {
    self.endpoint = endpoint
    self.method = method
    self.params = params
    self.query = query
  }

  var queryString: String? {
    guard let query = query else { return nil }
    return query.queryParams()
  }

  var paramData: Data? {
    guard let params = params else { return nil }
    return try? JSONSerialization.data(withJSONObject: params, options: [])
  }
}

// MARK: - Response

struct Response {
  let response: JSON
  let request: Request
  let code: Int
}

// MARK: - Errors

enum APIClientError: Error {
  case request
  case response
  case api(Error?)
  case parsing
  case networking(Error?)
}

// MARK: - Result

enum Result {
  case success(Response)
  case error(APIClientError)

  var response: Response? {
    switch self {
    case .success(let response):
      return response
    default:
      return nil
    }
  }

  var isSuccess: Bool {
    switch self {
    case .success(let response):
      return response.code == 200
    default:
      return false
    }
  }
}
