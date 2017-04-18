
import UIKit
import SnapKit

protocol SelectionButtonDataSource {
  var items: [String] { get }
  var selection: Int? { get set }
}

internal protocol SelectionButtonPopoverViewControllerDelegate: SelectionButtonDataSource {
}

class SelectionButtonPopoverViewController: UIViewController {
  internal var delegate: SelectionButtonPopoverViewControllerDelegate?
  internal var sourceView: UIView?

  private let tableView: UITableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(tableView)
    tableView.bounces = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "PopoverCell")
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}

extension SelectionButtonPopoverViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    delegate?.selection = indexPath.row
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

extension SelectionButtonPopoverViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    guard (delegate != nil) else { return 0 }
    return delegate!.items.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PopoverCell",
                                             for: indexPath)
    if let selection = delegate?.selection {
      if indexPath.row == selection {
        cell.accessoryType = .checkmark
      }
    }

    if (indexPath.row >= delegate!.items.count - 1) {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
    }

    cell.textLabel?.text = delegate?.items[safe: indexPath.row]
    return cell
  }
}

extension SelectionButtonPopoverViewController: UIPopoverPresentationControllerDelegate {
  func prepareForPopoverPresentation(_ controller: UIPopoverPresentationController) {
    controller.permittedArrowDirections = .any
    controller.sourceView = sourceView
  }

  func adaptivePresentationStyle(for controller: UIPresentationController)
      -> UIModalPresentationStyle {
    return .none
  }
}

protocol SelectionButtonDelegate {
  func present(_ viewControllerToPresent: UIViewController,
               animated flag: Bool, completion: (() -> Swift.Void)?)
}

class SelectionButton: UIButton, SelectionButtonPopoverViewControllerDelegate {
  var dataSource: SelectionButtonDataSource?
  var delegate: SelectionButtonDelegate?

  internal var items: [String] {
    return (dataSource?.items)!
  }

  internal var selection: Int? {
    didSet {
      if let value = selection {
        setTitle(dataSource?.items[safe: value], for: .normal)
      }
      dataSource?.selection = selection
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addTarget(self, action: #selector(presentPopover), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc
  private func presentPopover() {
    let popover = SelectionButtonPopoverViewController()
    popover.delegate = self
    popover.sourceView = self
    popover.modalPresentationStyle = .popover
    // TODO(compnerd) calculate this properly
    popover.preferredContentSize = CGSize(width: 152, height: 176)
    // TODO(compnerd) this should match the background color for the UITableView
    popover.popoverPresentationController?.backgroundColor = .white
    popover.popoverPresentationController?.delegate = popover
    delegate?.present(popover, animated: true, completion: nil)
  }
}
