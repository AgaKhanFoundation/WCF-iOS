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
import RxCocoa

class Cache {
  static let shared = Cache()

  typealias FacebookID = String
  typealias FacebookName = String
  typealias FacebookProfileImageURL = URL
  typealias PersonalProgress = Int
  typealias PersonalCommitment = Int

  let facebookNamesRelay = BehaviorRelay<[FacebookID: FacebookName]>(value: [:])
  private var facebookNames = [FacebookID: FacebookName]()
  func update(fbid: FacebookID, name: FacebookName) {
    facebookNames[fbid] = name
    facebookNamesRelay.accept(facebookNames)
  }

  let facebookProfileImageURLsRelay = BehaviorRelay<[FacebookID: FacebookProfileImageURL]>(value: [:])
  private var facebookProfileImageURLs = [FacebookID: FacebookProfileImageURL]()
  func update(fbid: FacebookID, url: FacebookProfileImageURL) {
    facebookProfileImageURLs[fbid] = url
    facebookProfileImageURLsRelay.accept(facebookProfileImageURLs)
  }

  let personalProgressRelay = BehaviorRelay<[FacebookID: PersonalProgress]>(value: [:])
  private var personalProgresses = [FacebookID: PersonalProgress]()
  func update(fbid: FacebookID, progress: PersonalProgress) {
    personalProgresses[fbid] = progress
    personalProgressRelay.accept(personalProgresses)
  }

  let personalCommitmentRelay = BehaviorRelay<[FacebookID: PersonalCommitment]>(value: [:])
  private var personalCommitments = [FacebookID: PersonalCommitment]()
  func update(fbid: FacebookID, commitment: PersonalCommitment) {
    personalCommitments[fbid] = commitment
    personalCommitmentRelay.accept(personalCommitments)
  }

  let participantRelay = BehaviorRelay<Participant?>(value: nil)
  let currentEventRelay = BehaviorRelay<Event?>(value: nil)
}
