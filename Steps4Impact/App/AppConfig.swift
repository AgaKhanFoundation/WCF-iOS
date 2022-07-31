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

struct AppConfig {
  static var server: URLComponents {
//    if UserInfo.isStaging {
//      return URLComponents(string: "https://staging.steps4impact.org")! // swiftlint:disable:this force_unwrapping
//    } else {
//      #if DEBUG
//        return URLComponents(string: "https://steps4impact-dev.azurewebsites.net")! // swiftlint:disable:this force_unwrapping
//      #else
//        return URLComponents(string: "https://production.steps4impact.org")! // swiftlint:disable:this force_unwrapping
//      #endif
//    }
    return URLComponents(string: "https://step4impact.k8s.infinidigm.com")!
  }

  static var serverPassword: String {
//    if UserInfo.isStaging {
//      return AppSecrets.stagingPassword
//    } else {
//      #if DEBUG
//        return AppSecrets.devPassword
//      #else
//        return AppSecrets.prodPassword
//      #endif
//    }
    return "dGVzdDp0ZXN0"
  }

  static let appCenterSecret = "9ca54e4e-20df-425a-bfe6-b72d0daad2da" // TODO: Move this to CI env

  static let fitbitConsumerKey = "22B4MM"
  static let fitbitConsumerSecret = "c2daab8d7565ffc888cc269ad1a9dff9"
  static let fitbitCallbackUri = "https://fitbit_oauth2_complete"
  static let fitbitAuthorizeUrl = "https://www.fitbit.com/oauth2/authorize"
  static let fitbitTokenUrl = "https://api.fitbit.com/oauth2/token"
  static let fitbitScope = "activity profile settings"

  static var build: String {
    guard
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    else { return "" }

    var string = "\(Strings.Application.name): \(version) - \(build)"

    #if DEBUG
      string += "\nDebug"
    #endif

    if UserInfo.isStaging {
      string += "\nStaging"
    }

    return string
  }
}
