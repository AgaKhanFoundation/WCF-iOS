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

struct UserInfo {
  private static let defaults = UserDefaults.standard

  // Add new keys to store to UserDefaults here
  private static let pedometerKey = "UserInfo.Keys.Pedometer"
  private static let profileStatsRangeKey = "UserInfo.Keys.ProfileStatsRange"
  private static let teamLeaderStatsRangeKey =
      "UserInfo.Keys.TeamLeaderboardStatsRange"
  private static let OnboardingCompleteKey: String =
      "UserInfo.Keys.OnboardingComplete"
  private static let AKFIDKey: String =
      "UserInfo.Keys.AKFID"
  private static let AKFProfileCreatedKey: String =
      "UserInfo.Keys.AKFProfileCreated"
  private static let staging: String = "UserInfo.Keys.staging"
  private static let fitbitAuthObjKey: String = "UserInfo.Keys.fitbitAuthObj"

  enum Pedometer: String {
    case healthKit = "UserInfo.Pedometer.HealthKit"
    case fitbit = "UserInfo.Pedometer.Fitbit"
  }

  static var pedometerSource: Pedometer? {
    get {
      guard
        let pedometerRaw = defaults.string(forKey: pedometerKey)
      else { return nil }
      return Pedometer(rawValue: pedometerRaw)
    }
    set {
      if let newValue = newValue {
        defaults.set(newValue.rawValue, forKey: pedometerKey)
      } else {
        defaults.removeObject(forKey: pedometerKey)
      }
    }
  }

  static var profileStatsRange: Int {
    get { return defaults.integer(forKey: profileStatsRangeKey) } // 0 returned by default if none set
    set { defaults.set(newValue, forKey: profileStatsRangeKey) }
  }

  static var teamLeaderStatsRange: Int {
    get { return defaults.integer(forKey: teamLeaderStatsRangeKey) }
    set { defaults.set(newValue, forKey: teamLeaderStatsRangeKey) }
  }

  public static var onboardingComplete: Bool {
    get { return defaults.bool(forKey: OnboardingCompleteKey) }
    set { defaults.set(newValue, forKey: OnboardingCompleteKey) }
  }

  public static var AKFID: String? {
    get { return defaults.string(forKey: AKFIDKey) }
    set { defaults.set(newValue, forKey: AKFIDKey) }
  }
  
  public static var AKFProfileCreated: Bool {
    get { return defaults.bool(forKey: AKFProfileCreatedKey) }
    set { defaults.set(newValue, forKey: AKFProfileCreatedKey) }
  }
  
  public static var fitbitAuthObj: OAuthSwiftCredential? {
    get { return defaults.retrieve(OAuthSwiftCredential.self, fromKey: fitbitAuthObjKey) }
    set { defaults.save(newValue, forKey: fitbitAuthObjKey) }
  }

  public static var isStaging: Bool {
    get { return defaults.bool(forKey: staging) }
    set { defaults.set(newValue, forKey: staging) }
  }
}
