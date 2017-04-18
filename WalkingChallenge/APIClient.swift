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

import UIKit

class APIClient {

  static var shared = APIClient()

  private var baseURLString = "" // TODO: Add baseurl in AppConfig
  private let session: URLSession

  init() {
    let config = URLSessionConfiguration.default
    // TODO: Add authorization headers
    session = URLSession(configuration: config)
  }

  typealias APIClientResultCompletion = (Result) -> Void

  func request(_ request: Request, completion: @escaping APIClientResultCompletion) {
    print("-> \(request.endpoint.rawValue)")

    var urlComponents = URLComponents(string: baseURLString)
    urlComponents?.path.append("/\(request.endpoint.rawValue)")
    urlComponents?.query = request.queryString

    guard let url = urlComponents?.url else {
      print("request: \(request) could not be created")
      handle(completion, result: .error(.request))
      return
    }

    var urlRequest = URLRequest(url: url)

    // TODO: Add user token if needed here
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpBody = request.paramData

    let task = session.dataTask(with: urlRequest) { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
      print("<- \(request.endpoint.rawValue)")

      guard let httpResponse = urlResponse as? HTTPURLResponse else {
        print("Error: Response")
        self?.handle(completion, result: .error(.response))
        return
      }

      guard error == nil else {
        print("Error: \(error.debugDescription)")
        self?.handle(completion, result: .error(.networking(error)))
        return
      }

      guard
        let data = data,
        let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON
      else {
        print("Error: JSON Parsing")
        self?.handle(completion, result: .error(.parsing))
        return
      }

      let response = Response(response: json, request: request, code: httpResponse.statusCode)

      self?.handle(completion, result: .success(response))
    }

    task.resume()
  }

  private func handle(_ completion: @escaping APIClientResultCompletion, result: Result) {
    onMain {
      completion(result)
    }
  }
}
