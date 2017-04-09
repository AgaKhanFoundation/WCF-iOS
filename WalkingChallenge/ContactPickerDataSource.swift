
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
      sortedFilteredFriends.sort { $0.first_name < $1.first_name }
    case .familyName:
      sortedFilteredFriends.sort { $0.last_name < $1.last_name }
    default: break
    }
    
    if let filter = filter {
      sortedFilteredFriends = sortedFilteredFriends
        .filter {$0.display_name.lowercased().contains(filter.lowercased())}
    }
    
    cells.removeAll()
    cells = sortedFilteredFriends.map {
      var cell = ContactCellInfo(from: $0)
      cell.isSelected = selectedFriends.contains($0.fbid)
      return cell
    }
  }
}
