
import UIKit

protocol IdentifiedUITableViewCell {
  static var identifier: String { get }
}

protocol ConfigurableUITableViewCell {
  func configure(_: Any)
}

protocol CellInfo {
  var cellIdentifier: String { get }
}

protocol TableDataSource {
  var cells: [CellInfo] { get set }
}

class ConfigurableTableViewCell: UITableViewCell {
  func configure(cellInfo: CellInfo) {
    fatalError("Must be implemented by the subclass")
  }
}
