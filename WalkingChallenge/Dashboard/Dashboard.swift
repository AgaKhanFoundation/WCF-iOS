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
import Foundation

class Dashboard: UIViewController {
  private let lblTitle: UILabel = UILabel(typography: .headerTitle)
  private let tblCards: UITableView = UITableView(frame: .zero)
  private var arrCards: [Card] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)
    self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    layout()
  }

  private func layout() {
    view.backgroundColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)

    lblTitle.text = Strings.Dashboard.title
    lblTitle.textColor = .black
    lblTitle.backgroundColor = .clear

    view.addSubview(lblTitle)
    lblTitle.snp.makeConstraints {
      $0.top.equalTo(topLayoutGuide.snp.bottom)
      $0.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    tblCards.allowsSelection = false
    tblCards.backgroundColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)
    tblCards.dataSource = self
    tblCards.delegate = self
    tblCards.separatorStyle = .none

    tblCards.register(ProfileCardView.self)
    tblCards.register(ActivityCardView.self)
    tblCards.register(FundraisingCardView.self)
    tblCards.register(ChallengeCardView.self)

    view.addSubview(tblCards)
    tblCards.snp.makeConstraints {
      $0.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p16)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.left.right.equalToSuperview().inset(Style.Padding.p24)
    }

    arrCards.append(ProfileCard())
    arrCards.append(ActivityCard())
    arrCards.append(FundraisingCard())
    arrCards.append(ChallengeCard())

    tblCards.reloadData()
  }
}

extension Dashboard: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return arrCards.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let card = arrCards[safe: indexPath.section] else {
      return UITableViewCell()
    }

    let cell: UITableViewCell =
        tableView.dequeueReusableCell(withIdentifier: card.renderer,
                                      for: indexPath)
    guard let view = cell as? CardView else { return UITableViewCell() }
    view.render(card)
    return cell
  }
}

extension Dashboard: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    return Style.Padding.p16
  }

  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    return UIView(frame: .zero)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    cell.contentView.layer.masksToBounds = true
    cell.layer.shadowPath =
        UIBezierPath(roundedRect: cell.bounds,
                     cornerRadius: cell.contentView.layer.cornerRadius).cgPath
  }
}
