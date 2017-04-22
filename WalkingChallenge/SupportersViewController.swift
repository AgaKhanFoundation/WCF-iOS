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

class SponsorCell: UITableViewCell, IdentifiedUITableViewCell {
  static let identifier: String = "SponsorCell"

  internal var picture: UIImageView = UIImageView()
  internal var name: UILabel = UILabel(.body)
  internal var tagline: UILabel = UILabel(.caption)
  internal var donated: UILabel = UILabel(.body)
  internal var pledged: UILabel = UILabel(.caption)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([picture, name, tagline, donated, pledged])

    picture.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.height.width.equalTo(Style.Size.s56)
    }

    // TODO(compnerd) use a placeholder instead of the filled bordered area
    picture.layer.borderWidth = 1
    picture.layer.backgroundColor = Style.Colors.grey.cgColor

    name.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(picture.snp.right).offset(Style.Padding.p8)
    }

    tagline.snp.makeConstraints { (make) in
      make.top.equalTo(name.snp.bottom)
      make.left.equalTo(name.snp.left)
    }

    donated.snp.makeConstraints { (make) in
      make.top.equalTo(tagline.snp.bottom).offset(Style.Padding.p12)
      make.left.equalTo(tagline.snp.left)
    }

    pledged.snp.makeConstraints { (make) in
      make.top.equalTo(donated.snp.bottom)
      make.left.equalTo(donated.snp.left)
    }
  }
}

extension SponsorCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? Sponsor else { return }

    name.text = info.name
    tagline.text = info.tagline
    // FIXME(compnerd) calculate this value
    donated.text = DataFormatters.formatCurrency(value: 0)
    // TODO(compnerd) localise this properly
    pledged.text =
        "Pledged \(DataFormatters.formatCurrency(value: info.rate))/mile"
  }
}

fileprivate class SponsorsDataSource: NSObject, UITableViewDataSource {
  internal var dataSource: SponsorshipDataSource?

  init(_ dataSource: SponsorshipDataSource) {
    super.init()
    self.dataSource = dataSource
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return dataSource?.sponsors.count ?? 0
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell =
          tableView.dequeueReusableCell(withIdentifier: SponsorCell.identifier,
                                        for: indexPath)
              as? ConfigurableUITableViewCell
      else { return UITableViewCell() }

    if let sponsor = dataSource?.sponsors[safe: indexPath.row] {
      cell.configure(sponsor)
    }
    return cell as? UITableViewCell ?? UITableViewCell()
  }
}

fileprivate class SponsorsDelegate: NSObject, UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    // FIXME(compnerd) calculate this somehow?
    return 100.0
  }
}

class SupporterCell: UITableViewCell, IdentifiedUITableViewCell {
  static let identifier: String = "SupporterCell"

  internal var name: UILabel = UILabel(.body)
  internal var donated: UILabel = UILabel(.body)
  internal var pledged: UILabel = UILabel(.caption)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([name, donated, pledged])

    name.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    donated.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.bottom.equalTo(name.snp.centerY)
      make.right.equalToSuperview()
      make.left.equalTo(pledged.snp.left)
    }

    pledged.textColor = Style.Colors.grey
    pledged.snp.makeConstraints { (make) in
      make.top.equalTo(name.snp.centerY)
      make.bottom.equalToSuperview()
      make.right.equalToSuperview()
    }
  }
}

extension SupporterCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? Supporter else { return }

    name.text = info.name
    // FIXME(compnerd) calculate this value
    donated.text = DataFormatters.formatCurrency(value: 0)
    pledged.text =
        "Pledged \(DataFormatters.formatCurrency(value: info.pledged))"
  }
}

fileprivate class SupportersDataSource: NSObject, UITableViewDataSource {
  internal var dataSource: SponsorshipDataSource?

  init(_ dataSource: SponsorshipDataSource) {
    super.init()
    self.dataSource = dataSource
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return dataSource?.supporters.count ?? 0
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell =
          tableView.dequeueReusableCell(withIdentifier: SupporterCell.identifier,
                                        for: indexPath)
              as? ConfigurableUITableViewCell
    else { return UITableViewCell() }

    if let supporter = dataSource?.supporters[safe: indexPath.row] {
      cell.configure(supporter)
    }
    return cell as? UITableViewCell ?? UITableViewCell()
  }
}

class SupportersViewController: UIViewController {
  private var dataSource: SponsorshipDataSource = SponsorshipDataSource()
  private var sponsorsDataSource: SponsorsDataSource?
  private var supportersDataSource: SupportersDataSource?

  private var lblStatus: UILabel = UILabel(.title)
  private var lblCorporateSponsors: UILabel = UILabel(.section)
  private var lblCorporateSponsorsSummary: UILabel = UILabel(.caption)
  private var tblSponsorsTable: UITableView = UITableView()
  private var lblCurrentSupporters: UILabel = UILabel(.section)
  private var lblCurrentSupportersSummary: UILabel = UILabel(.caption)
  private var tblSupportersTable: UITableView = UITableView()

  convenience init() {
    self.init(nibName: nil, bundle: nil)
    self.sponsorsDataSource = SponsorsDataSource(self.dataSource)
    self.supportersDataSource = SupportersDataSource(self.dataSource)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureView()
  }

  private func configureNavigation() {
    title = Strings.SupportersAndSponsors.title
  }

  private func configureStatus(_ top: inout ConstraintRelatableTarget) {
    // FIXME(compnerd) calculate this as the sum of the sponsorship
    let sponsored: Float = 22.50
    // FIXME(compnerd) calculate this as the sum of the support
    let donated: Float = 401.00

    view.addSubview(lblStatus)
    lblStatus.text =
        "Great job! You have raised \(DataFormatters.formatCurrency(value: sponsored)) from corporate sponsors" +
        "and \(DataFormatters.formatCurrency(value: donated)) from your \(dataSource.supporters.count) supporters!"
    lblStatus.lineBreakMode = .byWordWrapping
    lblStatus.numberOfLines = 0
    lblStatus.textAlignment = .justified
    lblStatus.textColor = Style.Colors.grey
    lblStatus.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.width.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblStatus.snp.bottom
  }

  private func configureSponsors(_ top: inout ConstraintRelatableTarget) {
    // FIXME(compnerd) calculate this as the sum of the sponsorship
    let sponsored: Float = 22.50

    view.addSubview(lblCorporateSponsors)
    lblCorporateSponsors.text =
        "Corporate Sponsors (\(dataSource.sponsors.count))"
    lblCorporateSponsors.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblCorporateSponsors.snp.bottom

    view.addSubview(lblCorporateSponsorsSummary)
    lblCorporateSponsorsSummary.text =
        "Thanks to the following corporate supporters, you've raised an " +
        "additional \(DataFormatters.formatCurrency(value: sponsored))!"
    lblCorporateSponsorsSummary.lineBreakMode = .byWordWrapping
    lblCorporateSponsorsSummary.numberOfLines = 0
    lblCorporateSponsorsSummary.textAlignment = .justified
    lblCorporateSponsorsSummary.textColor = Style.Colors.grey
    lblCorporateSponsorsSummary.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.width.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblCorporateSponsorsSummary.snp.bottom

    view.addSubview(tblSponsorsTable)
    tblSponsorsTable.dataSource = sponsorsDataSource
    tblSponsorsTable.delegate = SponsorsDelegate()
    tblSponsorsTable.allowsSelection = false
    tblSponsorsTable.register(SponsorCell.self,
                              forCellReuseIdentifier: SponsorCell.identifier)
    tblSponsorsTable.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = tblSponsorsTable.snp.bottom
  }

  private func configureSupporters(_ top: inout ConstraintRelatableTarget) {
    // FIXME(compnerd) calculate this
    let completed = 75

    view.addSubview(lblCurrentSupporters)
    lblCurrentSupporters.text = "Current Supporters (\(dataSource.supporters.count))"
    lblCurrentSupporters.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.width.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblCurrentSupporters.snp.bottom

    view.addSubview(lblCurrentSupportersSummary)
    lblCurrentSupportersSummary.text =
        "You have completed \(completed)% of your walking goal and heve raised \(completed)% of the funds pledged by your supporters! Keep it up!"
    lblCurrentSupportersSummary.lineBreakMode = .byWordWrapping
    lblCurrentSupportersSummary.numberOfLines = 0
    lblCurrentSupportersSummary.textAlignment = .justified
    lblCurrentSupportersSummary.textColor = Style.Colors.grey
    lblCurrentSupportersSummary.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.width.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblCurrentSupportersSummary.snp.bottom

    view.addSubview(tblSupportersTable)
    tblSupportersTable.dataSource = supportersDataSource
    tblSupportersTable.allowsSelection = false
    tblSupportersTable.register(SupporterCell.self,
                                forCellReuseIdentifier: SupporterCell.identifier)
    tblSupportersTable.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p8)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(Style.Padding.p12)
    }
    top = tblSupportersTable.snp.bottom
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureStatus(&top)
    configureSponsors(&top)
    configureSupporters(&top)

    tblSponsorsTable.snp.makeConstraints { (make) in
      make.height.equalTo(tblSupportersTable.snp.height).multipliedBy(2)
    }
  }
}
