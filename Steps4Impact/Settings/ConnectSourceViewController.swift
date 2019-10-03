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
import HealthKit

class ConnectSourceViewController: TableViewController {
  static let steps = HKSampleType.quantityType(forIdentifier: .stepCount)!

  override func commonInit() {
    super.commonInit()

    title = Strings.ConnectSource.title
    navigationItem.largeTitleDisplayMode = .never
    dataSource = ConnectSourceDataSource()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reload()
  }

  override func tableView(_ tableView: UITableView,
                          willDisplay cell: UITableViewCell,
                          forRowAt indexPath: IndexPath) {
    super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    if let cell = cell as? ConnectSourceCell {
      cell.delegate = self
    }
  }

  override func handle(context: Context) {
    guard let source = context as? ConnectSourceDataSource.Source else { return }

    switch source {
    case .fitbit:
      // TODO(compnerd) support this
      let alert = AlertViewController()
      alert.title = "Unavailable"
      alert.body = "Fitbit will be able available soon."
      alert.add(.okay())
      AppController.shared.present(alert: alert, in: self, completion: nil)
    case .healthkit:
      // Just to ask for permission
      if HKHealthStore.isHealthDataAvailable() {
        switch HKHealthStore().authorizationStatus(for: ConnectSourceViewController.steps) {
        case .notDetermined:
          requestHealthKitAccess()
        case .sharingDenied:
          UserInfo.pedometerSource = nil
          requestHealthKitUpdate()
        case .sharingAuthorized:
          UserInfo.pedometerSource = .healthKit
        @unknown default:
          UserInfo.pedometerSource = nil
        }
      }
    }
  }

  private func requestHealthKitAccess() {
    HKHealthStore().requestAuthorization(toShare: [ConnectSourceViewController.steps],
                                         read: [ConnectSourceViewController.steps]) { [weak self] (_, _) in
      UserInfo.pedometerSource = .healthKit
      onMain {
        self?.reload()
      }
    }
  }

  private func requestHealthKitUpdate() {
    let directions: UIStackView = UIStackView()

    directions.axis = .vertical
    directions.distribution = .equalSpacing
    directions.alignment = .fill
    directions.spacing = Style.Padding.p4

    directions.addArrangedSubviews(
      DirectionCell(image: nil, text: "Open iPhone Settings"),
      DirectionCell(image: nil, text: "Tap Privacy"),
      DirectionCell(image: nil, text: "Tap Health"),
      DirectionCell(image: UIImage(named: "AppIcon40x40"), text: "Tap steps4impact"),
      DirectionCell(image: nil, text: "Allow steps4impact to read data")
    )

    let alert: AlertViewController = AlertViewController()
    alert.title = "Allow access to HealthKit"
    alert.body = "steps4impact uses HealthKit to track your daily steps."
    alert.contentView.addSubview(directions) { (make) in
      make.edges.equalToSuperview()
    }
    alert.add(AlertAction(title: "Open Settings", style: .primary, shouldDismiss: true) {
      let url: URL = URL(string: UIApplication.openSettingsURLString)!
      UIApplication.shared.open(url)
    })
    alert.add(AlertAction(title: "Cancel", style: .primary, shouldDismiss: true))

    AppController.shared.present(alert: alert, in: self) { [weak self] in
      self?.reload()
    }
  }
}

extension ConnectSourceViewController: ConnectSourceCellDelegate {
  func connectSource(context: Context?) {
    guard let context = context else { return }
    handle(context: context)
  }
}

class DirectionCell: UIView {
  let image: UIImageView =
      UIImageView(frame: .init(x: 0, y: 0, width: 40, height: 40))
  let text: UILabel = UILabel(frame: .zero)

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  public convenience init(image: UIImage?, text: String?) {
    self.init(frame: .zero)
    self.image.image = image
    self.text.text = text
  }

  private func setupView() {
    self.addSubview(image) { (make) in
      make.height.equalToSuperview().inset(Style.Padding.p8)
      make.width.equalTo(image.snp.height)
      make.top.left.equalToSuperview().inset(Style.Padding.p8)
    }
    self.addSubview(text) { (make) in
      make.left.equalTo(image.snp.right).offset(Style.Padding.p8)
      make.right.top.bottom.equalToSuperview().inset(Style.Padding.p8)
    }
  }
}
