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
import FacebookCore

protocol EventCellDelegate: class {
  func join(event: Event)
}

fileprivate class EventCell: UITableViewCell {
  internal var imgImage: UIImageView = UIImageView()
  internal var lblEventName: UILabel = UILabel()
  internal var lblCause: UILabel = UILabel()
  internal var lblTime: UILabel = UILabel()
  internal var btnJoin: UIButton = UIButton(type: .system)

  internal var event: Event?
  internal weak var delegate: EventCellDelegate?

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([imgImage, lblEventName, lblCause, lblTime, btnJoin])

    imgImage.layer.backgroundColor = Style.Colors.grey.cgColor
    imgImage.snp.makeConstraints { (make) in
      make.top.left.bottom.equalToSuperview().inset(Style.Padding.p12)
      make.width.equalTo(imgImage.snp.height)
    }

    lblEventName.snp.makeConstraints { (make) in
      make.top.equalTo(imgImage.snp.top)
      make.left.equalTo(imgImage.snp.right).offset(Style.Padding.p12)
    }
    lblCause.snp.makeConstraints { (make) in
      make.top.equalTo(lblEventName.snp.bottom)
      make.left.equalTo(lblEventName.snp.left)
    }
    lblTime.snp.makeConstraints { (make) in
      make.top.equalTo(lblCause.snp.bottom)
      make.left.equalTo(lblEventName.snp.left)
    }

    btnJoin.addTarget(self, action: #selector(join), for: .touchUpInside)
    btnJoin.setTitle(Strings.Events.join, for: .normal)
    btnJoin.setTitleColor(Style.Colors.green, for: .normal)
    btnJoin.layer.borderColor = Style.Colors.green.cgColor
    btnJoin.layer.borderWidth = 1.0
    btnJoin.layer.cornerRadius = 4.0
    btnJoin.contentEdgeInsets =
        UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
    btnJoin.snp.makeConstraints { (make) in
      make.top.equalTo(lblTime.snp.bottom)
      make.right.bottom.equalToSuperview().inset(Style.Padding.p12)
    }
  }

  func join(_ sender: Any) {
    guard
      let event = event,
      let delegate = delegate
    else { return }

    delegate.join(event: event)
  }
}

extension EventCell: ConfigurableUITableViewCell {
  static let identifier: String = "EventCell"

  func configure(_ data: Any) {
    guard
      let (event, delegate) = data as? (Event, EventCellDelegate)
    else { return }

    if let url = event.image {
      // TODO(compnerd) asynchronously load and display the image
      _ = url
    }

    lblEventName.font = UIFont.preferredFont(forTextStyle: .body)
    lblEventName.text = event.name

    lblCause.font = UIFont.preferredFont(forTextStyle: .footnote)
    lblCause.text = event.cause?.name

    lblTime.font = UIFont.preferredFont(forTextStyle: .caption1)
    lblTime.text =
        DataFormatters.formatDateRange(value: (event.start, event.end))

    self.event = event
    self.delegate = delegate
  }
}

internal class EventsViewTableDataSource: NSObject {
  weak var delegate: EventCellDelegate?
  var events: [Event] = []
}

extension EventsViewTableDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return events.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let info = events[safe: indexPath.row],
      let cell =
          tableView.dequeueReusableCell(withIdentifier: EventCell.identifier,
                                        for: indexPath)
              as? ConfigurableUITableViewCell
    else { return UITableViewCell() }

    cell.configure((info, delegate))
    return cell as? UITableViewCell ?? UITableViewCell()
  }
}

class EventsViewController: UIViewController {
  internal var lblSectionHeader: UILabel = UILabel(.header)
  internal var lblSectionDetails: UILabel = UILabel()
  internal var tblTableView: UITableView = UITableView()
  internal var events: EventsViewTableDataSource = EventsViewTableDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }

  private func configureNavigation() {
    title = Strings.Events.title

    navigationController?.navigationBar.barTintColor = Style.Colors.darkGreen
    navigationController?.navigationBar.tintColor = Style.Colors.white
    navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: Style.Colors.white]
  }

  private func configureHeader(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(lblSectionHeader)
    lblSectionHeader.text = Strings.Events.openVirtualChallenges
    lblSectionHeader.textColor = Style.Colors.grey
    lblSectionHeader.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblSectionHeader.snp.bottom

    view.addSubview(lblSectionDetails)
    // TODO(compnerd) make this translatable
    lblSectionDetails.text = "Get started by joining a virtual challenge to raise funds for a cause that you are passionate about!"
    lblSectionDetails.font = UIFont.preferredFont(forTextStyle: .caption1)
    lblSectionDetails.numberOfLines = -1
    lblSectionDetails.textAlignment = .justified
    lblSectionDetails.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblSectionDetails.snp.bottom
  }

  private func configureTableView(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(tblTableView)

    tblTableView.snp.makeConstraints { (make) in
      make.top.equalTo(top)
      make.bottom.left.right.equalToSuperview().inset(Style.Padding.p12)
    }
    top = tblTableView.snp.bottom
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    events.delegate = self

    tblTableView.allowsSelection = false
    tblTableView.dataSource = events
    tblTableView.estimatedRowHeight = 2
    tblTableView.rowHeight = UITableViewAutomaticDimension
    tblTableView.register(EventCell.self)

    AKFCausesService.getEvents { [weak self] (result) in
      switch result {
      case .success(_, let response):
        guard let response = response?.arrayValue else { return }
        for event in response {
          if let event = Event(json: event) {
            self?.events.events.append(event)
          }
        }
        self?.tblTableView.reloadData()
        break
      case .failed(let error):
        print("unable to get events: \(String (describing: error?.localizedDescription))")
        return
      }
    }

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureHeader(&top)
    configureTableView(&top)
  }
}

extension EventsViewController: EventCellDelegate {
  func join(event: Event) {
    guard let eventID = event.id else { return }

    AKFCausesService.joinEvent(fbid: Facebook.id, eventID: eventID) { (result) in
      switch result {
      case .failed(let error):
        print("unable to join event: \(String (describing: error?.localizedDescription))")
        break
      case .success(_, _):
        let controller: EventViewController = EventViewController(event: event)
        self.navigationController?.pushViewController(controller, animated: true)
        break
      }
    }
  }
}
