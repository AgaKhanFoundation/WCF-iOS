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
import UIKit

class Onboarding : UIPageViewController {                                       // swiftlint:disable:this colon
  private var pages: [UIViewController] = [
  ]
  private var control: UIPageControl = UIPageControl(frame: .zero)
  private var btnContinue: UIButton = UIButton(type: .roundedRect)
  private var btnSkip: UIButton = UIButton(type: .system)

  init() {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal,
               options: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setViewControllers([pages.first!], direction: .forward, animated: true,
                       completion: nil)

    layout()
  }

  private func layout() {
    self.view.backgroundColor = .white

    self.view.addSubviews([control, btnContinue, btnSkip])

    control.currentPage = 1
    control.currentPageIndicatorTintColor = Style.Colors.green
    control.numberOfPages = pages.count
    control.pageIndicatorTintColor = Style.Colors.grey
    control.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
    }

    btnContinue.layer.borderColor = Style.Colors.green.cgColor
    btnContinue.layer.borderWidth = 1
    btnContinue.layer.cornerRadius = 4
    btnContinue.setTitle(Strings.Onboarding.continue, for: .normal)
    btnContinue.setTitleColor(Style.Colors.green, for: .normal)
    btnContinue.snp.makeConstraints { (make) in
      make.top.equalTo(control.snp.bottom).offset(Style.Size.s24)
      make.height.equalTo(Style.Size.s40)
      make.left.equalToSuperview().offset(Style.Size.s32)
      make.right.equalToSuperview().inset(Style.Size.s32)
    }
    btnContinue.addTarget(self, action: #selector(`continue`),
                          for: .touchUpInside)

    let attributes: [NSAttributedString.Key:Any] = [                            // swiftlint:disable:this colon
      .underlineStyle:NSUnderlineStyle.single.rawValue,                         // swiftlint:disable:this colon
      .foregroundColor:Style.Colors.black,                                      // swiftlint:disable:this colon
      .font:Style.Typography.smallRegular.font!                                 // swiftlint:disable:this colon
    ]
    btnSkip.setAttributedTitle(NSAttributedString(string: Strings.Welcome.skip,
                                                  attributes: attributes),
                               for: .normal)
    btnSkip.snp.makeConstraints { (make) in
      make.top.equalTo(btnContinue.snp.bottom).offset(Style.Size.s16)
      make.bottom.equalToSuperview().inset(Style.Size.s48)
      make.centerX.equalToSuperview()
    }
    btnSkip.addTarget(self, action: #selector(skip), for: .touchUpInside)
  }

  @objc
  func `continue`(sender: UIButton!) {
    guard let viewController = self.viewControllers?.first,
      let index = self.pages.firstIndex(of: viewController),
    index < self.pages.count else {
        return
    }

    // complete
    if index == self.pages.count - 1 {
      AppController.shared.transition(to: .navigation)
      return
    }

    // continue
    setViewControllers([self.pages[index + 1]], direction: .forward,
                       animated: true, completion: nil)
    control.currentPage = index + 1

    if index + 1 == pages.count - 1 {
      self.btnSkip.isHidden = true
      self.btnContinue.setTitle(Strings.Onboarding.begin, for: .normal)
      self.btnContinue.setTitleColor(Style.Colors.white, for: .normal)
      self.btnContinue.backgroundColor = Style.Colors.green
    }
  }

  @objc
  func skip(sender: UIButton!) {
    AppController.shared.transition(to: .navigation)
  }
}

extension Onboarding : UIPageViewControllerDataSource {                         // swiftlint:disable:this colon
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController)
      -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController),
        index >= 1, index <= pages.count else {
      return nil
    }
    return pages[index - 1]
  }

  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController)
      -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController),
        index < pages.count - 1 else {
      return nil
    }
    return pages[index + 1]
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pages.count
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let viewController = viewControllers?.first,
        let index = pages.firstIndex(of: viewController) else {
      return 0
    }
    return index
  }
}
