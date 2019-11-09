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
import OAuthSwift

class OAuthFitbit {
  public static let fitbitAPIBaseUrl = "https://api.fitbit.com/1"

  public static let shared = OAuthFitbit()
  let oauthswift: OAuth2Swift

  private init() {
    oauthswift = OAuth2Swift(
      consumerKey:
      AppConfig.fitbitConsumerKey,
      consumerSecret:
      AppConfig.fitbitConsumerSecret,
      authorizeUrl:
      AppConfig.fitbitAuthorizeUrl,
      accessTokenUrl:
      AppConfig.fitbitTokenUrl,
      responseType:
      "code" //  Authorization Code Grant Flow
    )

    if let authObj = UserInfo.fitbitAuthObj {
      oauthswift.client = OAuthSwiftClient(credential: authObj)
      // Token might be exprired. Need to refresh it but we
      // are not doing it here. Any subsequent API call will throw error,
      // where we will refresh the token - Needs to be done
    }
  }

  public static var profileAPI: URL? {
    guard let url = URL(string: fitbitAPIBaseUrl) else { return nil }
    return url.appendingPathComponent("user/-/profile.json")
  }

  public static func stepsAPI(forInterval interval: DateInterval) -> URL? {
    guard let url = URL(string: fitbitAPIBaseUrl) else { return nil }

    let formatter = Date.formatter
    formatter.formatOptions = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
    let start = Date.formatter.string(from: interval.start)
    let end = Date.formatter.string(from: interval.end)
    return url.appendingPathComponent("user/-/activities/steps/date/\(start)/\(end).json")
  }

  func authorize(using handlerViewController: OAuthWebViewController) {
    guard let callbackUrl = URL(string: AppConfig.fitbitCallbackUri) else { return }

    oauthswift.accessTokenBasicAuthentification = true
    oauthswift.authorizeURLHandler = handlerViewController
    _ = oauthswift.authorize(
    withCallbackURL: callbackUrl, scope: AppConfig.fitbitScope, state: "state") { result in
        switch result {
        case .success(let (credential, _, _)):
          UserInfo.pedometerSource = .fitbit
          UserInfo.fitbitAuthObj = credential
        case .failure(let error):
            print(error.description)
        }
    }
  }

  func fetchProfile() {
    guard let url = OAuthFitbit.profileAPI else { return }

    _ = oauthswift.client.get(
      url.absoluteString,
      parameters: [:]) { result in
        switch result {
        case .success(let response):
          let jsonDict = try? response.jsonObject()
          print(jsonDict as Any)
        case .failure(let error):
          // FIXME:
          // In case of authorization revoked or token expired, handle it here
          print(error.description)
        }
      }
  }

  func fetchSteps(forInterval interval: DateInterval, completion: OAuthSwiftHTTPRequest.CompletionHandler?) {
    guard let url = OAuthFitbit.stepsAPI(forInterval: interval) else { return }

    _ = oauthswift.client.get(
      url.absoluteString,
      parameters: [:]) { result in
        switch result {
        case .success(let response):
          completion?(.success(response))
        case .failure(let error):
          // FIXME:
          // In case of authorization revoked or token expired, handle it here
          //print(error.description)
          completion?(.failure(error))
        }
      }
  }
}
