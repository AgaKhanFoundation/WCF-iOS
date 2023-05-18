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
import RxSwift

class Cache {
  static let shared = Cache()

  typealias FirebaseID = String
  typealias SocialDisplayName = String
  typealias SocialProfileImageURL = URL
  typealias PersonalProgress = Int
  typealias PersonalCommitment = Int
  
  func fetchSocialInfo(fbid: FirebaseID) {
    AKFCausesService.getParticipantSocial(fbid: fbid) { [weak self] (result) in
      guard
        let `self` = self,
        let response = result.response?.dictionaryValue,
        let displayName = response["displayName"]?.stringValue,
        let photoURLRaw = response["photoURL"]?.stringValue,
        let photoURL = URL(string: photoURLRaw)
      else { return }
      
      self.update(fbid: fbid, name: displayName)
      self.update(fbid: fbid, url: photoURL)
    }
  }
  
  let socialDisplayNamesRelay = BehaviorRelay<[FirebaseID: SocialDisplayName]>(value: [:])
  private var socialDisplayNames = [FirebaseID: SocialDisplayName]()
  func update(fbid: FirebaseID, name: SocialDisplayName) {
    socialDisplayNames[fbid] = name
    socialDisplayNamesRelay.accept(socialDisplayNames)
  }

  let socialProfileImageURLsRelay = BehaviorRelay<[FirebaseID: SocialProfileImageURL]>(value: [:])
  private var socialProfileImageURLs = [FirebaseID: SocialProfileImageURL]()
  func update(fbid: FirebaseID, url: SocialProfileImageURL) {
    socialProfileImageURLs[fbid] = url
    socialProfileImageURLsRelay.accept(socialProfileImageURLs)
  }

  let personalProgressRelay = BehaviorRelay<[FirebaseID: PersonalProgress]>(value: [:])
  private var personalProgresses = [FirebaseID: PersonalProgress]()
  func update(fbid: FirebaseID, progress: PersonalProgress) {
    personalProgresses[fbid] = progress
    personalProgressRelay.accept(personalProgresses)
  }

  let personalCommitmentRelay = BehaviorRelay<[FirebaseID: PersonalCommitment]>(value: [:])
  private var personalCommitments = [FirebaseID: PersonalCommitment]()
  func update(fbid: FirebaseID, commitment: PersonalCommitment) {
    personalCommitments[fbid] = commitment
    personalCommitmentRelay.accept(personalCommitments)
  }

  let participantRelay = BehaviorRelay<Participant?>(value: nil)
  let currentEventRelay = BehaviorRelay<Event?>(value: nil)
}
