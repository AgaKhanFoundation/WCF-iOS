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
import UIKit
import SnapKit

class EventViewController: UIViewController {
  var event: Event?
  var tbrToolBar: UIToolbar = UIToolbar()
  var segSegments: UISegmentedControl =
      UISegmentedControl(items: [Strings.Event.myStats,
                                 Strings.Event.mySupporters])
  var viewControllers: [UIViewController] = []
  weak var currentViewController: UIViewController?

  convenience init(event: Event) {
    self.init(nibName: nil, bundle: nil)

    self.event = event
    self.viewControllers = [StatisticsViewController(event: event),
                            SponsorsSupportsViewController(event: event)]
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }

  private func configureNavigation() {
    title = event?.name
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureToolbar(&top)
  }

  private func configureToolbar(_ top: inout ConstraintRelatableTarget) {
    tbrToolBar.delegate = self
    tbrToolBar.barTintColor = Style.Colors.darkGreen
    view.addSubview(tbrToolBar)
    tbrToolBar.snp.makeConstraints { (make) in
      make.top.equalTo(top)
      make.leading.trailing.equalToSuperview()
    }
    top = tbrToolBar.snp.bottom

    segSegments.addTarget(self, action: #selector(segmentChanged(_:)),
                          for: .valueChanged)
    segSegments.selectedSegmentIndex = 0
    segmentChanged(self)
    segSegments.tintColor = Style.Colors.white
    tbrToolBar.addSubview(segSegments)
    segSegments.snp.makeConstraints { (make) in
      make.centerX.centerY.equalToSuperview()
    }

    // find the separator and hide it
    let navigationBar = navigationController?.navigationBar
    navigationBar?.subviews
      .flatMap { $0.subviews }
      .flatMap { $0 as? UIImageView }
      .filter { $0.bounds.size.width == navigationBar?.bounds.size.width }
      .filter { $0.bounds.size.height <= 2 }
      .first?.isHidden = true
  }

  func segmentChanged(_ sender: Any) {
    currentViewController?.willMove(toParentViewController: nil)
    currentViewController?.view.removeFromSuperview()
    currentViewController?.removeFromParentViewController()

    currentViewController =
        viewControllers[safe: segSegments.selectedSegmentIndex]

    guard let currentViewController = currentViewController else { return }

    addChildViewController(currentViewController)
    view.addSubview(currentViewController.view)
    currentViewController.view.snp.makeConstraints { (make) in
      make.top.equalTo(tbrToolBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
    currentViewController.view.layoutIfNeeded()
    currentViewController.didMove(toParentViewController: self)
  }
}

extension EventViewController: UIToolbarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
