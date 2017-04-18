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

class Team: TableDataSource {
  var cells = [CellInfo]()

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var name: String {
    // TODO(compnerd) fetch this from the backend
    return "Walk4Change"
  }

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var size: Int {
    // TODO(compnerd) fetch this from the backend
    return 7
  }

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var limit: Int {
    // TODO(compnerd) fetch this from the backend
    return 11
  }

  // TODO(compnerd) cache this value to avoid unnecessary requests
  static var leaders: [String] {
    // TODO(compnerd) fetch this from the backend
    return [ "Alpha", "Beta", "Gamma" ]
  }

  func reload(completion: @escaping SuccessBlock) {
    guard cells.isEmpty else { return }
  }

  func addTeamMember(completion: @escaping SuccessBlock) {
    // TODO: Push data to backend and refresh cells

    // cells.append(TeamMemberCellInfo(name: "Someone New"))

    onMain {
      completion(true)
    }
  }
}
