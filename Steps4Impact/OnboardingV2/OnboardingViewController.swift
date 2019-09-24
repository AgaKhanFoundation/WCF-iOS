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

import SnapKit
import UIKit

class OnboardingViewController: ViewController {
  enum State {
    case welcome(Welcome)
    case onboarding(Onboarding)

    var totalPages: Int {
      switch self {
      case .welcome: return Welcome.allCases.count
      case .onboarding: return Onboarding.allCases.count
      }
    }

    var currentIndex: Int {
      switch self {
      case .welcome(let value): return value.rawValue
      case .onboarding(let value): return value.rawValue
      }
    }
  }

  enum Welcome: Int, CaseIterable {
    case initial = 0
  }

  enum Onboarding: Int, CaseIterable {
    case create = 0
    case complete
    case track
  }

  var state: State = .welcome(.initial)

  private let continueButton = Button(style: .primary)
  private let skipButton = Button(style: .secondary)
  private let pageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal,
    options: nil)

  // PageController Related
  private lazy var pageControl: UIPageControl? = pageViewController.pageControl
  private var viewControllers: [UIViewController] = []
  private let welcomePage = OnboardingPageViewController(context: OnboardingPageViewController.PageContext(
    title: Strings.Welcome.title,
    asset: Assets.onboardingLoginPeople,
    tagLine: Strings.Welcome.thanks))
  private let createPage = OnboardingPageViewController(context: OnboardingPageViewController.PageContext(
    title: Strings.Onboarding.createTeam,
    asset: Assets.onboardingCreateTeam))
  private let completePage = OnboardingPageViewController(context: OnboardingPageViewController.PageContext(
    title: Strings.Onboarding.journey,
    asset: Assets.onboardingJourney))
  private let trackPage = OnboardingPageViewController(context: OnboardingPageViewController.PageContext(
    title: Strings.Onboarding.dashboard,
    asset: Assets.onboardingDashboard))

  override func configureView() {
    super.configureView()

    continueButton.title = Strings.Onboarding.continue
    continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    skipButton.title = Strings.Welcome.skip
    skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    pageViewController.dataSource = self
    pageViewController.delegate = self
    pageControl?.hidesForSinglePage = true
    pageControl?.currentPageIndicatorTintColor = Style.Colors.FoundationGreen
    pageControl?.pageIndicatorTintColor = Style.Colors.grey
    updateForState()

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Style.Padding.p8
    stackView.distribution = .fillEqually
    stackView.addArrangedSubviews(continueButton, skipButton)
    view.addSubview(stackView) {
      $0.leading.trailing.equalToSuperview().inset(Style.Padding.p32)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Style.Padding.p16)
    }

    pageViewController.willMove(toParent: self)
    view.addSubview(pageViewController.view) {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(stackView.snp.top)
    }
    pageViewController.didMove(toParent: self)
  }

  private func currentViewController(for state: State) -> UIViewController {
    switch state {
    case .welcome(let welcome):
      switch welcome {
      case .initial: return welcomePage
      }
    case .onboarding(let onboarding):
      switch onboarding {
      case .complete: return completePage
      case .create: return createPage
      case .track: return trackPage
      }
    }
  }

  private func state(for viewController: UIViewController?) -> State? {
    guard let viewController = viewController else { return nil }
    switch viewController {
    case welcomePage: return .welcome(.initial)
    case completePage: return .onboarding(.complete)
    case createPage: return .onboarding(.create)
    case trackPage: return .onboarding(.track)
    default: return nil
    }
  }

  private func updateForState(programmatically: Bool = true) {
    switch state {
    case .welcome:
      viewControllers = [welcomePage]
      if programmatically {
        pageViewController.setViewControllers([currentViewController(for: state)],
        direction: .forward,
        animated: false,
        completion: nil)
      }
    case .onboarding:
      viewControllers = [createPage, completePage, trackPage]
      if programmatically {
        pageViewController.setViewControllers([currentViewController(for: state)],
        direction: .forward,
        animated: true,
        completion: nil)
      }
    }

    if case .onboarding(.track) = state {
      skipButton.isHidden = true
      continueButton.title = Strings.Onboarding.begin
    } else {
      skipButton.isHidden = false
      continueButton.title = Strings.Onboarding.continue
    }
  }

  @objc
  private func skipTapped() {
    UserInfo.onboardingComplete = true
    AppController.shared.transition(to: .navigation)
  }

  @objc
  func continueTapped() {
    switch state {
    case .welcome:
      self.state = .onboarding(.create)
    case .onboarding(let onboarding):
      switch onboarding {
      case Onboarding.allCases.last:
        UserInfo.onboardingComplete = true
        AppController.shared.transition(to: .navigation)
      default:
        if let nextState = Onboarding(rawValue: onboarding.rawValue + 1) {
          self.state = .onboarding(nextState)
        }
      }
    }
    updateForState()
  }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return state.totalPages
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return state.currentIndex
  }

  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
    return viewControllers[safe: index - 1]
  }

  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
    return viewControllers[safe: index + 1]
  }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    guard finished, completed, let state = state(for: pageViewController.viewControllers?.first) else { return }
    self.state = state
    updateForState(programmatically: false)
  }
}
