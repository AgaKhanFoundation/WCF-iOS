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

import UIKit
import SnapKit

protocol SelectionButtonDataSource: AnyObject {
  var items: [String] { get }
  var selection: Int? { get set }
}

class SelectionButtonPopoverViewController: UIViewController {
  weak var delegate: SelectionButtonDataSource?
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
    return delegate?.items.count ?? 0
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

    if let count = delegate?.items.count, indexPath.row >= count - 1 {
      cell.separatorInset =
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
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

protocol SelectionButtonDelegate: AnyObject {
  func present(_ viewControllerToPresent: UIViewController,
               animated flag: Bool, completion: (() -> Swift.Void)?)
}

class SelectionButton: UIButton, SelectionButtonDataSource {
  var dataSource: SelectionButtonDataSource?
  weak var delegate: SelectionButtonDelegate?

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
