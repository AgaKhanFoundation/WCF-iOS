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

import SnapKit

struct TeamMemberCount: CellInfo {
  var cellIdentifier: String = TeamMemberCountCell.identifier

  var count: Int

  init(count: Int) {
    self.count = count
  }
}

class TeamMemberCountCell: UITableViewCell, IdentifiedUITableViewCell {
  static var identifier: String = "TeamMemberCountCell"

  let label: UILabel = UILabel(.header)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    contentView.addSubview(label)
    backgroundColor = .clear

    label.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(Style.Padding.p12)
    }
  }
}

extension TeamMemberCountCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? TeamMemberCount else { return }
    // TODO(compnerd) make this localisable
    label.text = "Members (\(info.count))"
  }
}

struct TeamMember: CellInfo {
  var cellIdentifier: String = TeamMemberCell.identifier

  let name: String
  let picture: URL?

  init(name: String, picture: URL? = nil) {
    self.name = name
    self.picture = picture
  }
}

class TeamMemberCell: UITableViewCell, IdentifiedUITableViewCell {
  static var identifier: String = "TeamMemberCell"

  let pictureView = UIImageView()
  let nameLabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    contentView.addSubviews([pictureView, nameLabel])
    backgroundColor = .clear

    pictureView.layer.borderColor = Style.Colors.grey.cgColor
    pictureView.layer.borderWidth = 1
    pictureView.layer.cornerRadius = Style.Size.s32 / 2
    pictureView.layer.masksToBounds = true
    pictureView.snp.makeConstraints { (make) in
      make.height.width.equalTo(Style.Size.s32)
      make.left.equalToSuperview().inset(Style.Padding.p12)
      make.centerY.equalToSuperview()
    }

    nameLabel.snp.makeConstraints { (make) in
      make.left.equalTo(pictureView.snp.right)
          .offset(Style.Padding.p12)
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.centerY.equalTo(pictureView.snp.centerY)
    }
  }
}

extension TeamMemberCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? TeamMember else { return }
    nameLabel.text = info.name
  }
}

class TeamMembersDataSource: NSObject {
  let team: Team

  var cells: [CellInfo]

  init(team: Team) {
    self.team = team
    self.cells = [TeamMemberCount(count: team.members.count)] + team.members
    super.init()
  }
}

extension TeamMembersDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return cells.count
  }

  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let info = cells[safe: indexPath.row],
      let cell =
          tableView.dequeueReusableCell(withIdentifier: info.cellIdentifier,
                                        for: indexPath)
              as? ConfigurableUITableViewCell
    else { return UITableViewCell() }

    cell.configure(info)
    //TODO: Sami fix this using CellInfo pattern
    if let cell = cell as? UITableViewCell {
      if indexPath.row == 0 {
        cell.separatorInset =
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
      }

      return cell
    } else {
      return UITableViewCell()
    }
  }
}

class TeamMembersViewController: UIViewController {
  let teamDataSource: TeamDataSource = TeamDataSource()
  let teamMembersDataSource: TeamMembersDataSource

  let tableView = UITableView()
  let inviteButton = UIButton(type: .system)

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.teamMembersDataSource =
        TeamMembersDataSource(team: teamDataSource.myTeam)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
    configureNavigation()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    view.addSubviews([tableView, inviteButton])

    tableView.allowsSelection = false
    tableView.dataSource = teamMembersDataSource
    tableView.register(TeamMemberCountCell.self,
                       forCellReuseIdentifier: TeamMemberCountCell.identifier)
    tableView.register(TeamMemberCell.self,
                       forCellReuseIdentifier: TeamMemberCell.identifier)
    tableView.snp.makeConstraints { (make) in
      make.leading.trailing.equalToSuperview()
          .inset(Style.Padding.p12)
      make.top.equalToSuperview().inset(Style.Padding.p12)
    }

    inviteButton.contentEdgeInsets =
        UIEdgeInsets(top: Style.Padding.p8, left: Style.Padding.p8,
                     bottom: Style.Padding.p8, right: Style.Padding.p8)
    inviteButton.layer.borderWidth = 1
    inviteButton.setTitle("Invite Members", for: .normal)
    inviteButton.addTarget(self, action: #selector(inviteFriends),
                           for: .touchUpInside)
    inviteButton.snp.makeConstraints { (make) in
      make.top.equalTo(tableView.snp.bottom).offset(Style.Padding.p12)
      make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
  }

  private func configureNavigation() {
    navigationItem.title = Strings.NavBarTitles.teamMembers
  }

  func inviteFriends() {
    Facebook.invite(url: "http://www.google.com")
  }
}
