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

struct Section {
  let name: String
}

enum Contributor {
case sponsor(Sponsor?)
case supporter(Supporter?)
}

class SectionHeaderCell: UITableViewCell {
  internal var lblSectionHeader: UILabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    lblSectionHeader.backgroundColor = Style.Colors.darkGreen
    lblSectionHeader.font = UIFont.preferredFont(forTextStyle: .headline)
    lblSectionHeader.textAlignment = .center
    lblSectionHeader.textColor = Style.Colors.white
    addSubview(lblSectionHeader)
    lblSectionHeader.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
  }
}

extension SectionHeaderCell: ConfigurableUITableViewCell {
  static let identifier: String = "SectionHeaderCell"

  func configure(_ data: Any) {
    guard let section = data as? Section else { return }
    lblSectionHeader.text = section.name
  }
}

class ContributorCell: UITableViewCell {
  internal var lblContributor: UILabel = UILabel()
  internal var imgContributor: UIImageView = UIImageView()
  internal var lblTagLine: UILabel = UILabel()
  internal var lblDonated: UILabel = UILabel()
  internal var lblPledged: UILabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    imgContributor.layer.backgroundColor = Style.Colors.grey.cgColor
    addSubview(imgContributor)
    imgContributor.snp.makeConstraints { (make) in
      make.top.left.equalToSuperview().inset(Style.Padding.p12)
      make.height.width.equalTo(Style.Size.s56)
    }

    addSubview(lblContributor)
    lblContributor.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p12)
      make.left.equalTo(imgContributor.snp.right).offset(Style.Padding.p8)
    }

    addSubview(lblTagLine)
    lblTagLine.snp.makeConstraints { (make) in
      make.top.equalTo(lblContributor.snp.bottom).offset(Style.Padding.p12)
      make.left.equalTo(lblContributor.snp.left)
    }
  }
}

extension ContributorCell: ConfigurableUITableViewCell {
  static let identifier: String = "ContributorCell"

  func configure(_ data: Any) {
    guard let contributor = data as? Contributor else { return }
    switch contributor {
    case .sponsor(let sponsor):
      lblContributor.text = "\(sponsor?.name ?? "")"
      break
    case .supporter(let supporter):
      lblContributor.text = "\(supporter?.name ?? "")"
      break
    }
  }
}

class SponsorsSupportersViewController: UIViewController {
  static let sections: [Section] =
      [Section(name: "Sponsors"), Section(name: "Supporters")]
  internal var sponsors: [Sponsor] = []
  internal var supporters: [Supporter] = []

  internal var event: Event?

  internal var lblStatus: UILabel = UILabel()
  internal var tblContributors: UITableView = UITableView()

  convenience init(event: Event) {
    self.init(nibName: nil, bundle: nil)
    self.event = event
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureHeader(_ top: inout ConstraintRelatableTarget) {
    lblStatus.font = UIFont.preferredFont(forTextStyle: .subheadline)
    lblStatus.lineBreakMode = .byWordWrapping
    lblStatus.numberOfLines = -1
    lblStatus.textAlignment = .justified
    lblStatus.textColor = Style.Colors.grey
    // TODO(compnerd) make this translatable
    lblStatus.text = "Great job! You have raised _ from corporate sponsors and _ from your _ supporters!"
    view.addSubview(lblStatus)
    lblStatus.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.left.right.equalToSuperview().inset(Style.Padding.p12)
    }
    top = lblStatus.snp.bottom
  }

  private func configureContent(_ top: inout ConstraintRelatableTarget) {
    tblContributors.allowsSelection = false
    tblContributors.dataSource = self
    tblContributors.delegate = self
    tblContributors.register(SectionHeaderCell.self)
    tblContributors.register(ContributorCell.self)
    view.addSubview(tblContributors)
    tblContributors.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.bottom.equalTo(bottomLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
    }
    top = tblContributors.snp.bottom
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureHeader(&top)
    configureContent(&top)
  }
}

extension SponsorsSupportersViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  func tableView(_ tableView: UITableView,
                 titleForHeaderInSection section: Int) -> String? {
    return ""
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell: ContributorCell =
          tableView.dequeueReusableCell(withIdentifier: ContributorCell.identifier,
                                        for: indexPath) as? ContributorCell
    else { return UITableViewCell() }

    var data: Contributor
    if indexPath.section == 0 {
      data = .sponsor(sponsors[safe: indexPath.row])
    } else {
      data = .supporter(supporters[safe: indexPath.row])
    }

    cell.configure(data)
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return SponsorsSupportersViewController.sections.count
  }
}

extension SponsorsSupportersViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    guard
      let cell =
          tableView.dequeueReusableCell(withIdentifier: SectionHeaderCell.identifier)
              as? SectionHeaderCell,
      let section: Section =
          SponsorsSupportersViewController.sections[safe: section]
    else { return nil }

    cell.configure(section)
    return cell
  }

  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    return 32
  }

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}
