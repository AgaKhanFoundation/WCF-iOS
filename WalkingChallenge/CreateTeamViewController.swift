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

protocol CreateTeamDelegate: class {
  func moveForward()
  func cancel()

  func createTeam(name: String)
  func addTeamMembers(members: [String])
}

class FormViewController: UIViewController {
  internal let btnDismiss: UIButton = UIButton(type: .system)
  internal let prgProgress: ProgressStepsView = ProgressStepsView(withSteps: 3)
  internal let btnNext: UIButton = UIButton(type: .system)

  internal var event: Event?
  internal weak var delegate: CreateTeamDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    initialise()
  }

  internal func initialise() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureDismiss(&top)
    configureProgress(&top)
    configureNext(&top)
    configureForm(&top)
  }

  internal func configureDismiss(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnDismiss)
    btnDismiss.addTarget(self, action: #selector(cancel(_:)),
                         for: .touchUpInside)
    btnDismiss.setTitleColor(Style.Colors.grey, for: .normal)
    btnDismiss.setImage(UIImage.init(imageLiteralResourceName: "clear"),
                        for: .normal)
    btnDismiss.snp.makeConstraints { (make) in
      make.top.equalToSuperview().inset(Style.Padding.p24)
      make.right.equalToSuperview().inset(Style.Padding.p12)
    }
    top = btnDismiss.snp.bottom
  }

  internal func configureProgress(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(prgProgress)
    prgProgress.axis = .horizontal
    prgProgress.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p64)
      make.height.equalTo(prgProgress.diameter)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p48)
    }
    top = prgProgress.snp.bottom
  }

  internal func configureForm(_ top: inout ConstraintRelatableTarget) {
    fatalError()
  }

  internal func configureNext(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnNext)
    btnNext.addTarget(self, action: #selector(moveForward(_:)),
                      for: .touchUpInside)
    btnNext.setTitle(Strings.CreateTeam.next, for: .normal)
    btnNext.setTitleColor(Style.Colors.green, for: .normal)
    btnNext.setTitleColor(Style.Colors.grey, for: .disabled)
    btnNext.contentEdgeInsets =
        UIEdgeInsets(top: 4.0, left: 12.0, bottom: 4.0, right: 12.0)
    btnNext.isEnabled = false
    btnNext.layer.borderColor = Style.Colors.grey.cgColor
    btnNext.layer.borderWidth = 1.0
    btnNext.layer.cornerRadius = 4.0
    btnNext.snp.makeConstraints { (make) in
      make.bottom.right.equalToSuperview().inset(Style.Padding.p24)
    }
  }

  func cancel(_ sender: UIButton) {
    delegate?.cancel()
  }

  func moveForward(_ sender: UIButton) {
    delegate?.moveForward()
  }
}

class NameTeamViewController: FormViewController {
  let lblTitle: UILabel = UILabel()
  let txtName: UITextField = UITextField()
  let uvwBorder: UIView = UIView()

  convenience init(delegate: CreateTeamDelegate?) {
    self.init(nibName: nil, bundle: nil)
    self.delegate = delegate
  }

  override func configureForm(_ top: inout ConstraintRelatableTarget) {
    prgProgress.progress = 1

    lblTitle.text = Strings.CreateTeam.nameYourTeam
    lblTitle.textColor = Style.Colors.grey
    lblTitle.font = UIFont.boldSystemFont(ofSize: 18.0)

    view.addSubview(lblTitle)
    lblTitle.snp.makeConstraints { (make) in
      make.bottom.equalTo(view.snp.centerY).offset(-Style.Padding.p8)
      make.centerX.equalToSuperview()
    }

    view.addSubview(txtName)
    txtName.borderStyle = .none
    txtName.backgroundColor = .clear
    // TODO(compnerd) make this localizable
    txtName.placeholder = "Ex: World Walkers"
    txtName.delegate = self
    txtName.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.centerY).offset(Style.Padding.p8)
      make.left.right.equalToSuperview().inset(Style.Padding.p24)
    }
    top = txtName.snp.bottom
  }

  override func viewDidLayoutSubviews() {
    uvwBorder.backgroundColor = Style.Colors.grey
    uvwBorder.frame = CGRect(x: 0.0, y: txtName.frame.height - 1.0,
                             width: txtName.frame.width, height: 1.0)
    txtName.addSubview(uvwBorder)
  }

  override func moveForward(_ sender: UIButton) {
    if let name = txtName.text {
      delegate?.createTeam(name: name)
    }
    super.moveForward(sender)
  }
}

extension NameTeamViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    uvwBorder.backgroundColor = Style.Colors.green
  }

  func textFieldDidEndEditing(_ textField: UITextField,
                              reason: UITextFieldDidEndEditingReason) {
    uvwBorder.backgroundColor = Style.Colors.grey
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let value: NSString = (textField.text ?? "") as NSString
    if !value.replacingCharacters(in: range, with: string).isEmpty {
      btnNext.isEnabled = true
      btnNext.layer.borderColor = Style.Colors.green.cgColor
    } else {
      btnNext.isEnabled = false
      btnNext.layer.borderColor = Style.Colors.grey.cgColor
    }
    return true
  }
}

class FriendDataSource: NSObject {
  var friends: [Friend] = []
  var filteredFriends: [Friend]?
  var selected: Set<String> = []
  var filter: String? {
    didSet {
      guard let filter = filter else {
        filteredFriends = nil
        return
      }

      filteredFriends = self.friends.filter {
        $0.displayName.lowercased().contains(filter.lowercased())
      }
    }
  }

  subscript(indexPath: IndexPath) -> Friend? {
    if filteredFriends != nil {
      return filteredFriends?[safe: indexPath.row]
    }
    return friends[safe: indexPath.row]
  }
}

class FriendCell: UITableViewCell {
}

extension FriendCell: ConfigurableUITableViewCell {
  static let identifier: String = "FriendCell"

  func configure(_ data: Any) {
    guard let friend = data as? Friend else { return }
    textLabel?.text = friend.displayName
    imageView?.loadImage(from: friend.pictureRawURL)
  }
}

extension FriendDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return filteredFriends != nil ? (filteredFriends?.count)! : friends.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
        let cell =
            tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier,
                                          for: indexPath)
              as? FriendCell
    else { return UITableViewCell() }

    if let friend = self[indexPath] {
      cell.configure(friend)
      if selected.contains(friend.fbid) {
        cell.accessoryType = .checkmark
        cell.isSelected = true
      } else {
        cell.accessoryType = .none
        cell.isSelected = false
      }
    }

    return cell
  }

  func updateSelection(for friend: Friend, selected: Bool) {
    if selected {
      self.selected.insert(friend.fbid)
    } else {
      self.selected.remove(friend.fbid)
    }
  }
}

class AddFriendsViewController: FormViewController {
  let lblAddFriends: UILabel = UILabel()
  let lblAppFriends: UILabel = UILabel()
  let lblMissing: UILabel = UILabel()
  let lblSpots: UILabel = UILabel()
  let tblFriends: UITableView = UITableView()

  var friends: FriendDataSource = FriendDataSource()

  private func fetchData() {
    Facebook.getUserFriends(limit: .none) { (friend) in
      self.friends.friends.append(friend)
      self.tblFriends.reloadData()
    }
  }

  private func configureFriendList(_ top: inout ConstraintRelatableTarget) {
    let sbrSearch: UISearchBar =
        UISearchBar(frame: CGRect(x: 0, y: 0, width: tblFriends.frame.width,
                                  height: 44))
    sbrSearch.delegate = self

    tblFriends.allowsMultipleSelection = true
    tblFriends.dataSource = friends
    tblFriends.delegate = self
    tblFriends.tableHeaderView = sbrSearch
    tblFriends.register(FriendCell.self)
    view.addSubview(tblFriends)
    tblFriends.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p12)
      make.bottom.equalTo(btnNext.snp.top).offset(-Style.Padding.p12)
    }
    top = tblFriends.snp.bottom
  }

  internal func renderSpots() {
    let count = (event?.teamLimit ?? 0) - friends.selected.count - 1
    // TODO(compnerd) make this localizable
    if count == 0 {
      lblSpots.text = "Your team is full."
      lblSpots.textColor = .red
    } else {
      lblSpots.text = "You have \(count) spots left on your team."
      if count <= 3 {
        lblSpots.textColor = Style.Colors.yellow
      } else {
        lblSpots.textColor = Style.Colors.lightGreen
      }
    }
  }

  override func configureForm(_ top: inout ConstraintRelatableTarget) {
    fetchData()

    prgProgress.progress = 2
    btnNext.isEnabled = true
    btnNext.layer.borderColor = Style.Colors.green.cgColor

    lblAddFriends.text = Strings.CreateTeam.addTeamMembers
    lblAddFriends.textColor = Style.Colors.grey
    lblAddFriends.font = UIFont.boldSystemFont(ofSize: 18.0)

    view.addSubview(lblAddFriends)
    lblAddFriends.snp.makeConstraints { (make) in
      make.top.equalTo(prgProgress.snp.bottom).offset(Style.Padding.p24)
      make.centerX.equalToSuperview()
    }
    top = lblAddFriends.snp.bottom

    lblAppFriends.text = Strings.CreateTeam.yourAppFriends
    lblAppFriends.textColor = Style.Colors.grey
    lblAppFriends.font = UIFont.boldSystemFont(ofSize: 14.0)

    view.addSubview(lblAppFriends)
    lblAppFriends.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
    top = lblAppFriends.snp.bottom

    lblMissing.text = Strings.CreateTeam.missingFriends
    lblMissing.textColor = Style.Colors.grey
    lblMissing.font = UIFont.boldSystemFont(ofSize: 12.0)

    view.addSubview(lblMissing)
    lblMissing.snp.makeConstraints { (make) in
      make.top.equalTo(top)
      make.centerX.equalToSuperview()
    }
    top = lblMissing.snp.bottom

    renderSpots()
    lblSpots.font = UIFont.boldSystemFont(ofSize: 14.0)

    view.addSubview(lblSpots)
    lblSpots.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p12)
      make.centerX.equalToSuperview()
    }
    top = lblSpots.snp.bottom

    configureFriendList(&top)
  }

  override func moveForward(_ sender: UIButton) {
    delegate?.addTeamMembers(members: Array(friends.selected))
    super.moveForward(sender)
  }
}

extension AddFriendsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    guard friends.selected.count < (event?.teamLimit ?? 0) - 1 else {
      tableView.deselectRow(at: indexPath, animated: false)
      return
    }

    if let friend = friends[indexPath] {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
      friends.updateSelection(for: friend, selected: true)
      renderSpots()
    }
  }

  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath) {
    if let friend = friends[indexPath] {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
      friends.updateSelection(for: friend, selected: false)
      renderSpots()
    }
  }
}

extension AddFriendsViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    friends.filter = searchText.isEmpty ? nil : searchText
    tblFriends.reloadData()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    friends.filter = nil
    tblFriends.reloadData()
  }
}

class CreateTeamViewController: UIViewController {
  internal var controllers: [UIViewController] = []
  internal var index: Int = -1
  internal var event: Event?
  internal var team: Team?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    let step0 = NameTeamViewController()
    step0.delegate = self
    step0.event = event

    let step1 = AddFriendsViewController()
    step1.delegate = self
    step1.event = event

    // TODO(compnerd) figure out the final screen
    let step2 = UIViewController()

    controllers = [step0, step1, step2]
    moveForward()
  }
}

extension CreateTeamViewController: CreateTeamDelegate {
  func moveForward() {
    // FIXME(compnerd) should we just dismiss in the else?
    guard let newController = controllers[safe: index + 1] else { return }

    if let prevController = controllers[safe: index] {
      prevController.willMove(toParentViewController: nil)
      prevController.view.removeFromSuperview()
    }

    newController.willMove(toParentViewController: self)
    view.addSubview(newController.view)
    addChildViewController(newController)
    newController.didMove(toParentViewController: self)

    index += 1
  }

  func cancel() {
    if let team = team?.id {
      AKFCausesService.deleteTeam(team: team) { (result) in
        switch result {
        case .failed(let error):
          print("unable to delete team: \(String(describing: error?.localizedDescription))")
          break
        case .success(_, _):
          break
        }
      }
    }
    dismiss(animated: true, completion: nil)
  }

  func createTeam(name: String) {
    guard !name.isEmpty else { return }

    AKFCausesService.createTeam(name: name) { (result) in
      switch result {
      case .failed(let error):
        print("unable to create team: \(String(describing: error?.localizedDescription))")
        break
      case .success(_, let response):
        guard let response = response else { return }
        self.team = Team(json: response)
        break
      }
    }
  }

  func addTeamMembers(members: [String]) {
    guard let team = team?.id else { return }

    for member in [Facebook.id] + members {
      AKFCausesService.joinTeam(fbid: member, team: team) { (result) in
        switch result {
        case .failed(let error):
          print("unable to add \(member) to \(String(describing: self.team?.name)): \(String(describing: error?.localizedDescription))")
          break
        case .success(_, _):
          break
        }
      }
    }
  }
}
