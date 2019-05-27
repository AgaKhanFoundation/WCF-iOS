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
import Foundation

class Challenge: UIViewController {
  private let lblTitle: UILabel = UILabel(typography: .headerTitle)
  private let btnSettings: UIButton = UIButton(type: .system)
  private let tblCards: UITableView = UITableView(frame: .zero)
  private var arrCards: [JourneyCardMiles] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)
    self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    layout()
  }

  private func layout() {
    view.backgroundColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)

    lblTitle.attributedText = self.getTitle(Strings.Challenge.title, subTitle: "\n\(Strings.Challenge.subTitle)")
    lblTitle.textColor = .black

    view.addSubview(lblTitle)
    lblTitle.snp.makeConstraints {
      $0.top.equalTo(topLayoutGuide.snp.bottom)
      $0.left.right.equalToSuperview().inset(Style.Padding.p16)
    }

    btnSettings.setImage(UIImage(named: "GearIcon"), for: .normal)

    view.addSubview(btnSettings)
    btnSettings.snp.makeConstraints {
      $0.top.equalTo(topLayoutGuide.snp.bottom)
      $0.right.right.equalToSuperview().inset(Style.Padding.p16)
    }

    tblCards.allowsSelection = false
    tblCards.backgroundColor = #colorLiteral(red: 0.9647058823, green: 0.9725490196, blue: 0.9803921568, alpha: 1.0000000000)
    tblCards.dataSource = self
    tblCards.delegate = self
    tblCards.separatorStyle = .none
    tblCards.estimatedRowHeight = 44
    tblCards.rowHeight = UITableView.automaticDimension

    tblCards.register(JourneyMilesCardView.self)
    tblCards.register(MilestoneDetailCardView.self)

    view.addSubview(tblCards)
    tblCards.snp.makeConstraints {
      $0.top.equalTo(lblTitle.snp.bottom).offset(Style.Padding.p16)
      $0.bottom.equalToSuperview().inset(Style.Padding.p16)
      $0.left.right.equalToSuperview().inset(Style.Padding.p16)
    }

    arrCards.append(JourneyCardMiles())

    tblCards.reloadData()
  }

  private func getTitle(_ title: String, subTitle: String) -> NSMutableAttributedString {

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 4

    let titleFont = [NSAttributedString.Key.font: Style.Typography.headerTitle.font!, .paragraphStyle: paragraphStyle]
    let subFont = [NSAttributedString.Key.font: Style.Typography.smallRegular.font!, .paragraphStyle: paragraphStyle]
    let titleAttr = NSMutableAttributedString(string: title, attributes: titleFont)
    let subTitleAttr = NSMutableAttributedString(string: "\(subTitle)", attributes: subFont)

    let combination = NSMutableAttributedString()
    combination.append(titleAttr)
    combination.append(subTitleAttr)
    return combination
  }
}

extension Challenge: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return arrCards.count
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if arrCards[section].expand == true {
      return arrCards[section].miles.count + 1
    }
    return 1
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let card = arrCards[safe: indexPath.section] else {
      return UITableViewCell()
    }

    if indexPath.row == 0 {
      let cell: UITableViewCell =
        tableView.dequeueReusableCell(withIdentifier: card.renderer,
                                      for: indexPath)
      guard let view = cell as? JourneyMilesCardView else { return UITableViewCell() }
      view.render(card)

      view.showMileStone = {
        self.arrCards[indexPath.section].expandMile(true)
        tableView.reloadSections([0], with: .none)
      }

      return cell
    } else {
      let miles = card.miles[indexPath.row - 1]

      let cell: UITableViewCell =
        tableView.dequeueReusableCell(withIdentifier: miles.renderer,
                                      for: indexPath)
      guard let view = cell as? MilestoneDetailCardView else { return UITableViewCell() }
      view.render(miles)

      view.hideFirstLayer(indexPath.row == 1)
      view.showLastRoundedCorner(indexPath.row == card.miles.count)

      return cell
    }
  }
}

extension Challenge: UITableViewDelegate {
//  func tableView(_ tableView: UITableView,
//                 heightForHeaderInSection section: Int) -> CGFloat {
//    return 0
//  }
//
//  func tableView(_ tableView: UITableView,
//                 viewForHeaderInSection section: Int) -> UIView? {
//    return UIView(frame: .zero)
//  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
//    cell.contentView.layer.masksToBounds = true
//    cell.layer.shadowPath =
//      UIBezierPath(roundedRect: cell.bounds,
//                   cornerRadius: cell.contentView.layer.cornerRadius).cgPath
  }
}
