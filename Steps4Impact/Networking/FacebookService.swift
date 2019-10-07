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

import FacebookCore
import FacebookShare

class FacebookService {
  static let shared = FacebookService()
  var cache = Cache.shared

  var id: String { return AccessToken.current?.userID ?? "" } // swiftlint:disable:this identifier_name

  func getRealName(fbid: String) {
    let request = GraphRequest(
      graphPath: "/\(fbid)/",
      parameters: ["fields": "name"],
      tokenString: AccessToken.current?.tokenString,
      version: nil,
      httpMethod: .get)
    request.start { [weak self] (_, result, error) in
      guard
        let result = result as? [String: String],
        let name = result["name"]
      else {
        print("unable to execute GraphQL query \(String(describing: error))")
        return
      }
      self?.cache.update(fbid: fbid, name: name)
    }
  }

  func getProfileImageURL(fbid: String) {
    let request: GraphRequest = GraphRequest(
      graphPath: "/\(fbid)/picture",
      parameters: ["fields": "", "type": "large", "redirect": "false"],
      tokenString: AccessToken.current?.tokenString,
      version: nil,
      httpMethod: .get)
    request.start { [weak self] (_, result, error) in
      guard
        let result = result,
        let rawURL = JSON(result)?["data"]?["url"]?.stringValue,
        let url = URL(string: rawURL)
      else {
        print("unable to execute GraphQL query \(String(describing: error))")
        return
      }
      self?.cache.update(fbid: fbid, url: url)
    }
  }
}
