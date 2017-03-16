
import UIKit

protocol CellInfo {
  var cellIdentifier: String { get }
}

protocol TableDataSource {
  var cells: [CellInfo] { get set }
}

// TODO: Ask compnerd about this - silly type theory
class ConfigurableTableViewCell: UITableViewCell {
  func configure(cellInfo: CellInfo) { fatalError("Must be implemented by the subclass") }
}

