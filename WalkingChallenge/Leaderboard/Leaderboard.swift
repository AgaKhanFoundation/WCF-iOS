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

class Leaderboard: UIViewController {
  var teams: [Team] = [] // dependency injection, for fetching teams
  var filters = ["Miles", "Money Raised", "Alphabetical (A-Z)", "Alphabetical (Z-A)"]
  var selectedFilter = "Miles" // initial filter is miles
  var currentTeam: Team? // the team that the user is in
  var tblView: UITableView!
  var toolBar: UIToolbar!
  var textField: UITextField!
  var picker: UIPickerView!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLeaderboard()
    setupTableView()
    fetchData()
  }
  func setupLeaderboard() {
    self.view.backgroundColor = .white
    title = "Leaderboard"
  }
  func setupTableView() {
    let width = view.bounds.width
    let height = view.bounds.height
    tblView = UITableView(frame: CGRect(x: 0, y: 20, width: width, height: height), style: .plain)
    tblView.backgroundColor = .white
    tblView.delegate = self
    tblView.dataSource = self
    tblView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
    tblView.register(TeamRankCell.self, forCellReuseIdentifier: "TeamRankCell")
    tblView.register(PickerCell.self, forCellReuseIdentifier: "LeaderboardPickerCell")
    view.addSubview(tblView)
  }
  func fetchData() {
    // fetch data
    // sort Data using miles
    sortByMiles()
    DispatchQueue.main.async {
      self.tblView.reloadData()
    }
  }
  func setupToolBar() {
    toolBar = UIToolbar()
    toolBar.sizeToFit()
    let leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "leftArrow"), style: .plain, target: self, action: #selector(movePickerToLeft))
    let rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rightArrow"), style: .plain, target: self, action: #selector(movePickerToRight))
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let doneButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
    toolBar.setItems([leftButtonItem, rightButtonItem, flexSpace, doneButtonItem], animated: false)
  }
  @objc func movePickerToLeft() {
    let row = picker.selectedRow(inComponent: 0)
    if row > 0 {
      picker.selectRow(row - 1, inComponent: 0, animated: true)
      self.pickerView(picker, didSelectRow: row - 1, inComponent: 0)
    }
  }
  @objc func movePickerToRight() {
    let row = picker.selectedRow(inComponent: 0)
    if row < filters.count - 1 {
      picker.selectRow(row + 1, inComponent: 0, animated: true)
      self.pickerView(picker, didSelectRow: row + 1, inComponent: 0)
    }
  }
  @objc func dismissPicker() {
    picker.selectRow(picker.selectedRow(inComponent: 0), inComponent: 0, animated: true)
    self.pickerView(picker, didSelectRow: picker.selectedRow(inComponent: 0), inComponent: 0)
    textField.endEditing(true)
    DispatchQueue.main.async {
      self.tblView.reloadData()
    }
  }
  func sortByMiles() {
    teams = teams.sorted(by: { (first, second) -> Bool in
      return first.calculatetotalDistance() > second.calculatetotalDistance()
    })
  }
  func sortByAmount() {
    // TODO: Once we get sponsorship info
  }
  func sortByName(backwards: Bool) {
    if backwards {
      teams = teams.sorted(by: { (first, second) -> Bool in
        guard let firstName = first.name, let secondName = second.name else { return false }
        return firstName > secondName
      })
    } else {
      teams = teams.sorted(by: { (first, second) -> Bool in
        guard let firstName = first.name, let secondName = second.name else { return false }
        return firstName < secondName
      })
    }
  }
}
extension Leaderboard: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return filters.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return filters[row]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch row {
    case 0:
      // sort by miles
      sortByMiles()
    case 1:
      // sort by amount raised
      sortByAmount()
    case 2:
      // sort by alphabetical a-z
      sortByName(backwards: false)

    default:
      // sort by alphabetical z-a
      sortByName(backwards: true)

    }
    DispatchQueue.main.async { [unowned self] in
      self.selectedFilter = self.filters[row]
    }
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 100
    } else if indexPath.row == 1 {
      return 50
    } else {
      return 75
    }
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return teams.count + 2
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TeamRankCell", for: indexPath) as? TeamRankCell
      cell?.teamRank.text = "Your Team Rank"
      /* Once a team has an amount raised and miles
        cell.amountRaised.text = "$" + currentTeam.amountRaised.string
        cell.totalMiles.text = currentTeam.distance.string + " mi"
        if let placeInLeaderboard = teams.firstIndex(where: { $0 == currentTeam}) {
          cell.ranking.text = "\(placeInLeaderboard + 1)."
        } else {
          cell.ranking.text = "0."
        }
      */
      cell?.amountRaised.text = "$0.00"
      cell?.totalMiles.text = "0.00 mi"
      cell?.teamName.text = currentTeam?.name ?? "My Team"
      cell?.ranking.text = "0."

      return cell ?? UITableViewCell(style: .default, reuseIdentifier: "TeamRankCell")
    } else if indexPath.row == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardPickerCell", for: indexPath) as? PickerCell
      cell?.leaderboard.text = "Leaderboard"
      cell?.dropDownTextField.dropDownMenu.delegate = self
      cell?.dropDownTextField.dropDownMenu.dataSource = self
      cell?.dropDownTextField.text = selectedFilter
      picker = cell?.dropDownTextField.dropDownMenu
      setupToolBar()
      textField = cell?.dropDownTextField
      cell?.dropDownTextField.inputAccessoryView = toolBar
      return cell ?? UITableViewCell(style: .default, reuseIdentifier: "LeaderboardPickerCell")
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell
      /* Once a team has an amount raised and miles
        cell.amountRaised.text = "$" + teams[indexPath.row - 2].calculateAmountRaised().string
        cell.totalMiles.text = teams[indexPath.row - 2].calculateTotalDistance().string + " mi"
        cell.teamName.text = "\(teams[indexPath.row - 2].name)"
        cell.ranking.text = "\(indexPath.row - 1)."
        return cell
      */
      cell?.amountRaised.text = "$0.00"
      cell?.totalMiles.text = "0.00 mi"
      cell?.ranking.text = "0."
      return cell ?? UITableViewCell(style: .default, reuseIdentifier: "LeaderboardCell")
    }
  }
}

extension Double {
  var string: String {
    return String(format: "%.2f", self)
  }
}

extension Team {
  func calculatetotalDistance() -> Int {
    var sum = 0
    for team in members {
      for record in team.records {
        sum += record.distance
      }
    }
    return sum
  }
}
