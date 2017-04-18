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
import SnapKit
import Contacts

class ContactDataSource: TableDataSource {
  var cells = [CellInfo]()
  var filter: String? { didSet { configureCells() }}
  private var friends = [Friend]()
  private var selectedFriends = Set<String>()

  func reload(completion: @escaping GenericBlock) {
    fetchFriends(completion: completion)
  }

  func changeSelection(at indexPath: IndexPath, select: Bool) {
    if let fbid = (cells[safe: indexPath.row] as? ContactCellInfo)?.fbid {
      if select {
        selectedFriends.insert(fbid)
      } else {
        selectedFriends.remove(fbid)
      }
      configureCells()
    }
  }

  var anyFriendsSelected: Bool {
    return !selectedFriends.isEmpty
  }

  var selectedFriendsIDs: [String] {
    return Array(selectedFriends)
  }

  private func fetchFriends(completion: @escaping GenericBlock) {
    Facebook.getTaggableFriends(limit: .none) { [weak self] (friend: Friend) in
      self?.friends.append(friend)
      self?.configureCells()

      completion()
    }
  }

  private func configureCells() {
    let sortOrder = CNContactsUserDefaults.shared().sortOrder

    var sortedFilteredFriends = friends

    switch sortOrder {
    case .givenName:
      sortedFilteredFriends.sort { $0.firstName < $1.firstName }
    case .familyName:
      sortedFilteredFriends.sort { $0.lastName < $1.lastName }
    default: break
    }

    if let filter = filter {
      sortedFilteredFriends = sortedFilteredFriends
        .filter {$0.displayName.lowercased().contains(filter.lowercased())}
    }

    cells.removeAll()
    cells = sortedFilteredFriends.map {
      var cell = ContactCellInfo(from: $0)
      cell.isSelected = selectedFriends.contains($0.fbid)
      return cell
    }
  }
}
