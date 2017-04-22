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

fileprivate class EventCell: UITableViewCell, IdentifiedUITableViewCell {
  static let identifier: String = "EventCell"

  internal var picture: UIImageView = UIImageView()
  internal var name: UILabel = UILabel(.header)
  internal var time: UILabel = UILabel(.body)
  internal var team: UILabel = UILabel(.body)
  internal var raised: UILabel = UILabel(.body)
  internal var distance: UILabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([picture, name, time, team, raised, distance])

    picture.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.size.equalTo(Style.Size.s56)
    }

    name.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(picture.snp.right).offset(Style.Padding.p8)
    }

    time.textColor = Style.Colors.grey
    time.snp.makeConstraints { (make) in
      make.top.equalTo(name.snp.bottom)
      make.left.equalTo(name.snp.left)
    }

    team.snp.makeConstraints { (make) in
      make.top.equalTo(time.snp.bottom).offset(Style.Padding.p12)
      make.left.equalTo(time.snp.left)
    }

    raised.snp.makeConstraints { (make) in
      make.top.equalTo(team.snp.bottom)
      make.left.equalTo(team.snp.left)
    }

    distance.snp.makeConstraints { (make) in
      make.top.equalTo(raised.snp.top)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }
  }
}

extension EventCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let event = data as? Event else { return }

    if let url = event.image {
      // TODO(compnerd) asynchronously load and display the image
      _ = url
    }

    // TODO(compnerd) use a placeholder instead of the filled bordered area
    picture.layer.borderWidth = 1
    picture.layer.backgroundColor = Style.Colors.grey.cgColor

    name.text = event.name
    // TODO(compnerd) format this
    time.text = event.time
    // FIXME(compnerd) properly localise this
    team.text = "Team: \(event.team)"

    raised.text = DataFormatters.formatCurrency(value: event.raised)

    // TODO(compnerd) properly localise this
    distance.text = "\(event.distance) miles"
  }
}

fileprivate class PastEventsDataSource: NSObject, UITableViewDataSource {
  internal var dataSource: EventsDataSource?

  init(_ dataSource: EventsDataSource) {
    super.init()
    self.dataSource = dataSource
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return dataSource?.events.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell =
          tableView.dequeueReusableCell(withIdentifier: EventCell.identifier,
                                        for: indexPath)
              as? ConfigurableUITableViewCell
    else { return UITableViewCell() }

    if let event = dataSource?.events[safe: indexPath.row] {
      cell.configure(event)
    }
    return cell as? UITableViewCell ?? UITableViewCell()
  }
}

fileprivate class EventTableDelegate: NSObject, UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    // FIXME(compnerd) calculate this somehow?
    return 112.0
  }
}

class EventsViewController: UIViewController {
  private var eventsDataSource: EventsDataSource = EventsDataSource()
  private var eventTableDataSource: PastEventsDataSource?

  private var lblStatus: UILabel = UILabel(.title)
  private var tblEvents: UITableView = UITableView()

  convenience init() {
    self.init(nibName: nil, bundle: nil)
    self.eventTableDataSource = PastEventsDataSource(self.eventsDataSource)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }

  private func configureNavigation() {
    title = Strings.PastEvents.title
  }

  private func configureStatusView(_ top: inout ConstraintRelatableTarget) {
    // FIXME(compnerd) calculate this as the sum of the sponsorship
    let raised: Float = 1500.00

    // FIXME(compnerd) calculate this
    let distance: Float = 1000.00

    view.addSubview(lblStatus)
    // FIXME(compnerd) properly localise this
    lblStatus.text =
        "Through your participation in \(eventsDataSource.events.count) events, you raised \(DataFormatters.formatCurrency(value: raised)) and walked \(distance) miles!"
    lblStatus.lineBreakMode = .byWordWrapping
    lblStatus.numberOfLines = 0
    lblStatus.textAlignment = .justified
    lblStatus.textColor = Style.Colors.grey
    lblStatus.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblStatus.snp.bottom
  }

  private func configureEventsTable(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(tblEvents)
    tblEvents.allowsSelection = false
    tblEvents.dataSource = eventTableDataSource
    tblEvents.delegate = EventTableDelegate()
    tblEvents.register(EventCell.self,
                       forCellReuseIdentifier: EventCell.identifier)
    tblEvents.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(Style.Padding.p12)
    }
    top = tblEvents.snp.bottom
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureStatusView(&top)
    configureEventsTable(&top)
  }
}
