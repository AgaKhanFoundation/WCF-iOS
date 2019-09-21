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

class AlertModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return AlertModalPresentationController(presentedViewController: presented, presenting: presenting)
  }

  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let coordinator = AlertModalAnimationCoordinator()
    coordinator.isPresenting = true
    return coordinator
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let coordinator = AlertModalAnimationCoordinator()
    coordinator.isPresenting = false
    return coordinator
  }
}

class AlertModalPresentationController: UIPresentationController {
  private let backgroundView = UIView()

  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    backgroundView.backgroundColor = Style.Colors.black
    backgroundView.alpha = 0
  }

  override func presentationTransitionWillBegin() {
    guard let containerView = containerView else { return }
    backgroundView.frame = containerView.frame
    containerView.insertSubview(backgroundView, at: 0)
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
      self?.backgroundView.alpha = 0.7
    }, completion: nil)
  }

  override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
      self?.backgroundView.backgroundColor = Style.Colors.Background
      self?.backgroundView.alpha = 0
    }, completion: nil)
  }
}

class AlertModalAnimationCoordinator: NSObject, UIViewControllerAnimatedTransitioning {
  var isPresenting: Bool = false

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let animatedView = transitionContext.view(forKey: isPresenting ? .to : .from) else { return }
    let containerView = transitionContext.containerView
    let bottomOfScreenPoint = CGPoint(x: containerView.center.x,
                                      y: containerView.frame.maxY + animatedView.frame.size.height)
    if isPresenting {
      animatedView.center = bottomOfScreenPoint
      containerView.addSubview(animatedView)
    }

    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
      animatedView.center = self.isPresenting ? containerView.center : bottomOfScreenPoint
    }, completion: { (completed) in
      transitionContext.completeTransition(completed)
      if !self.isPresenting {
        animatedView.removeFromSuperview()
      }
    })
  }
}
