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

import Dispatch
import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case delete = "DELETE"
  case patch = "PATCH"
  case post = "POST"
  case put = "PUT"
}

enum ServiceRequestResult {
  internal typealias HTTPStatusCode = Int
  internal typealias Response = JSON?

  case success(statusCode: HTTPStatusCode, response: Response)
  case failed(_ error: Error?)
  
  var response: Response {
    switch self {
    case .success(statusCode: _, response: let response):
      return response
    case .failed(_):
      return nil
    }
  }
}

class Service {
  typealias ServiceRequestCompletion = (ServiceRequestResult) -> Void

  private let server: URLComponents
  private let session: URLSession

  internal init(server: URLComponents, session: URLSession) {
    self.server = server
    self.session = session
  }

  internal func request(_ method: HTTPMethod, url: URL, parameters: JSON? = nil,
                        completion: ServiceRequestCompletion?) {
    var request: URLRequest = URLRequest(url: url)
    request.httpBody = parameters?.serialise()
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = session.dataTask(with: request) {
      (data: Data?, response: URLResponse?, error: Error?) in
        print("<- [\(method.rawValue.uppercased())] \(request)")

        guard error == nil else {
          self.callback(completion, result: .failed(error))
          return
        }
        guard let http = response as? HTTPURLResponse else {
          self.callback(completion, result: .failed(nil))
          return
        }
        guard let data = data else {
          self.callback(completion, result: .failed(nil))
          return
        }

        print("-> [\(http.statusCode)] \(String(data: data, encoding: .utf8)!)")

        switch JSON.deserialise(data) {
        case .some(let response):
          self.callback(completion, result: .success(statusCode: http.statusCode, response: response))
        default:
          self.callback(completion, result: .failed(nil))
        }
    }

    task.resume()
  }

  internal func callback(_ completion: ServiceRequestCompletion?,
                         result: ServiceRequestResult) {
    guard let completion = completion else { return }
    DispatchQueue.main.async {
      completion(result)
    }
  }

  internal func buildURL(_ endpoint: String, _ query: JSON? = nil) -> URL? {
    var url: URLComponents = server

    url.path.append(endpoint)
    if let dictionary = query?.dictionaryValue {
      var parameters: [String] = []
      for (key, value) in dictionary {
        parameters.append("\(key)=\(value)")
      }
      url.query = parameters.joined(separator: "&")
    }
    return url.url
  }
}
