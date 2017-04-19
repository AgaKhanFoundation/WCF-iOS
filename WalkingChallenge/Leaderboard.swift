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

struct LeaderBoardEntry {
  let imageURL: URL?
  let name: String
  let standing: Int
  let distance: Float
  let raised: Float
}

class LeaderBoardCell: UITableViewCell, IdentifiedUITableViewCell {
  static var identifier: String = "LeaderBoardCell"

  internal var standing: UILabel = UILabel(.header)
  internal var picture: UIImageView = UIImageView()
  internal var name: UILabel = UILabel(.body)
  internal var distance: UILabel = UILabel(.body)
  internal var raised: UILabel = UILabel(.body)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initialise()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initialise() {
    addSubviews([standing, picture, name, distance, raised])

    standing.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(Style.Padding.p12)
      // TODO(compnerd) figure out the right way to get this value
      make.width.height.equalTo(Style.Size.s32)
      make.centerY.equalToSuperview()
    }

    picture.layer.backgroundColor = Style.Colors.grey.cgColor
    // TODO(compnerd) figure out the right way to get this value
    picture.layer.cornerRadius = Style.Size.s32 / 2.0
    picture.layer.masksToBounds = true
    picture.snp.makeConstraints { (make) in
      make.left.equalTo(standing.snp.right)
          .offset(Style.Padding.p8)
      // TODO(compnerd) figure out the right way to get this value
      make.height.width.equalTo(Style.Size.s32)
      make.centerY.equalToSuperview()
    }

    name.snp.makeConstraints { (make) in
      make.left.equalTo(picture.snp.right)
          .offset(Style.Padding.p12)
      make.centerY.equalToSuperview()
    }

    distance.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.bottom.equalTo(name.snp.centerY)
      make.width.equalTo(raised.snp.width)
    }

    raised.textColor = Style.Colors.grey
    raised.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(Style.Padding.p12)
      make.top.equalTo(name.snp.centerY)
    }
  }
}

extension LeaderBoardCell: ConfigurableUITableViewCell {
  func configure(_ data: Any) {
    guard let info = data as? LeaderBoardEntry else { return }

    standing.text = "\(info.standing)."
    name.text = info.name

    // TODO(compnerd) localise this properly
    distance.text = "\(info.distance) miles"

    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    raised.text = currencyFormatter.string(from: NSNumber(value: info.raised))
  }
}

protocol LeaderBoardDataSource {
  var leaders: [LeaderBoardEntry] { get }
}

class LeaderBoard: UITableView {
  var data: LeaderBoardDataSource?

  convenience init() {
    self.init(frame: CGRect.zero)
    self.allowsSelection = false
    self.dataSource = self
    self.separatorStyle = .none
    self.register(LeaderBoardCell.self,
                  forCellReuseIdentifier: LeaderBoardCell.identifier)
  }
}

extension LeaderBoard: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    guard data != nil else { return 0 }
    return data!.leaders.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let entry = data?.leaders[safe: indexPath.row],
      let cell =
          tableView.dequeueReusableCell(withIdentifier: LeaderBoardCell.identifier,
                                        for: indexPath) as? ConfigurableUITableViewCell
    else { return UITableViewCell() }

    cell.configure(entry)
    // TODO(sami) fix this to use actual CellInfo pattern.
    return cell as? UITableViewCell ?? UITableViewCell()
  }
}
