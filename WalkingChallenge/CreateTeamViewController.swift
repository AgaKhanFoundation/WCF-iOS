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

@objc protocol CreateTeamDelegate: class {
  func moveForward()
  func moveBackward()
  func cancel()
}

class NameTeamViewController: UIViewController {
  let btnDismiss: UIButton = UIButton(type: .system)
  let prgProgress: ProgressStepsView = ProgressStepsView(withSteps: 4)
  let lblTitle: UILabel = UILabel()
  let txtName: UITextField = UITextField()
  let uvwBorder: UIView = UIView()
  let btnNext: UIButton = UIButton(type: .system)

  weak var delegate: CreateTeamDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureDismiss(&top)
    configureProgress(&top)
    configureForm(&top)
    configureNext(&top)
  }

  private func configureDismiss(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnDismiss)
    btnDismiss.addTarget(delegate, action: #selector(CreateTeamDelegate.cancel),
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

  private func configureProgress(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(prgProgress)
    prgProgress.axis = .horizontal
    prgProgress.progress = 1
    prgProgress.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p64)
      make.height.equalTo(prgProgress.diameter)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p48)
    }
    top = prgProgress.snp.bottom
  }

  private func configureForm(_ top: inout ConstraintRelatableTarget) {
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

  private func configureNext(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnNext)
    btnNext.addTarget(delegate,
                      action: #selector(CreateTeamDelegate.moveForward),
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

class AddFriendsViewController: UIViewController {
  let btnDismiss: UIButton = UIButton(type: .system)
  let prgProgress: ProgressStepsView = ProgressStepsView(withSteps: 4)
  let btnNext: UIButton = UIButton(type: .system)

  weak var delegate: CreateTeamDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    var top: ConstraintRelatableTarget = topLayoutGuide.snp.bottom
    configureDismiss(&top)
    configureProgress(&top)
    configureForm(&top)
    configureNext(&top)
  }

  private func configureDismiss(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnDismiss)
    btnDismiss.addTarget(delegate, action: #selector(CreateTeamDelegate.cancel),
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

  private func configureProgress(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(prgProgress)
    prgProgress.axis = .horizontal
    prgProgress.progress = 2
    prgProgress.snp.makeConstraints { (make) in
      make.top.equalTo(top).offset(Style.Padding.p64)
      make.height.equalTo(prgProgress.diameter)
      make.leading.trailing.equalToSuperview().inset(Style.Padding.p48)
    }
    top = prgProgress.snp.bottom
  }

  private func configureForm(_ top: inout ConstraintRelatableTarget) {
  }

  private func configureNext(_ top: inout ConstraintRelatableTarget) {
    view.addSubview(btnNext)
    btnNext.addTarget(delegate,
                      action: #selector(CreateTeamDelegate.moveForward),
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
      make.bottom.right.equalToSuperview().inset(Style.Padding.p12)
    }
  }
}

class CreateTeamViewController: UIPageViewController {
  internal var controllers: [UIViewController] = []
  internal var index: Int = -1

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  private func configureView() {
    view.backgroundColor = Style.Colors.white

    let step0 = NameTeamViewController()
    step0.delegate = self

    let step1 = AddFriendsViewController()
    step1.delegate = self

    controllers = [step0, step1]
    moveForward()
  }
}

extension CreateTeamViewController: CreateTeamDelegate {
  func moveBackward() {
  }

  func moveForward() {
    if let prevController = controllers[safe: index] {
      prevController.willMove(toParentViewController: nil)
      prevController.view.removeFromSuperview()
    }

    if let newController = controllers[safe: index + 1] {
      newController.willMove(toParentViewController: self)
      view.addSubview(newController.view)
      addChildViewController(newController)
      newController.didMove(toParentViewController: self)

      index += 1
    }
  }

  func cancel() {
    dismiss(animated: true, completion: nil)
  }
}
