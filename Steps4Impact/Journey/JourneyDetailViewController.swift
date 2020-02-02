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

class JourneyDetailViewController: ViewController {

  var milestone: Milestone?
  var imageMarqueeScrollView = UIScrollView()
  var imageMarqueePageControl = UIPageControl()
  private let titleLabel = UILabel(typography: .headerTitle)
  private let subtitleLabel = UILabel(typography: .title)
  private let bodyText = UITextView()

  override func configureView() {
    super.configureView()

    // Configure imageMarqueeScrollView
    imageMarqueeScrollView.delegate = self
    imageMarqueeScrollView.showsHorizontalScrollIndicator = false
    imageMarqueeScrollView.showsVerticalScrollIndicator = false
    imageMarqueeScrollView.isPagingEnabled = true
    imageMarqueeScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)

    view.addSubview(imageMarqueeScrollView) {
      $0.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height)
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(view.frame.width)
    }

    // Configure imageMarqueePageControl
    imageMarqueePageControl.currentPageIndicatorTintColor = Style.Colors.FoundationGreen
    imageMarqueePageControl.pageIndicatorTintColor = Style.Colors.Seperator

    view.addSubview(imageMarqueePageControl) {
      $0.top.equalTo(imageMarqueeScrollView.snp.bottom).offset(Style.Padding.p8)
      $0.width.equalTo(Style.Size.s128)
      $0.height.equalTo(Style.Size.s16)
      $0.centerX.equalToSuperview()
    }

    view.addSubview(titleLabel) {
      $0.top.equalTo(imageMarqueePageControl.snp.bottom).offset(Style.Padding.p16)
      $0.leading.equalToSuperview().offset(Style.Padding.p12)
      $0.trailing.equalToSuperview().inset(Style.Padding.p12)
    }

    view.addSubview(subtitleLabel) {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p8)
      $0.leading.equalToSuperview().offset(Style.Padding.p12)
      $0.trailing.equalToSuperview().inset(Style.Padding.p12)
    }

    view.addSubview(bodyText) {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(Style.Padding.p12)
      $0.leading.equalToSuperview().offset(Style.Padding.p12)
      $0.trailing.bottom.equalToSuperview().inset(Style.Padding.p12)
    }

    // Configure Views
    if let milestone = milestone {
      titleLabel.text = milestone.name
      subtitleLabel.text = milestone.subtitle
      bodyText.text = milestone.content

      let mediaURLs = milestone.getMediaURLs()
      print("mediaURLs: \(mediaURLs)")
      imageMarqueePageControl.numberOfPages = mediaURLs.count
      imageMarqueePageControl.currentPage = 0
      imageMarqueePageControl.isHidden = mediaURLs.count < 2

      if mediaURLs.count == 0 {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.fadeInImage(imageURL: URL(string: ""), placeHolderImage: Assets.journeyDetailMock.image)
        let xPosition = self.view.frame.width
        imageView.frame = CGRect(x: xPosition, y: 0, width: self.imageMarqueeScrollView.frame.width, height: self.imageMarqueeScrollView.frame.height)
        imageMarqueeScrollView.addSubview(imageView)
      } else {
        imageMarqueeScrollView.contentSize.width = imageMarqueeScrollView.frame.width * CGFloat(mediaURLs.count)
        for i in 0..<mediaURLs.count {                                                                      // swiftlint:disable:this variable_name
          let imageView = WebImageView()
          imageView.contentMode = .scaleAspectFit
          imageView.fadeInImage(imageURL: URL(string: mediaURLs[i]), placeHolderImage: Assets.journeyDetailMock.image)
          let xPosition = self.view.frame.width * CGFloat(i)
          imageView.frame = CGRect(x: xPosition, y: 0, width: self.imageMarqueeScrollView.frame.width, height: self.imageMarqueeScrollView.frame.height)
          imageMarqueeScrollView.addSubview(imageView)
        }
      }
    } else {
      /// Set default values.
    }
  }
}

extension JourneyDetailViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageWidth = view.frame.width
    let currentPage = Int(scrollView.contentOffset.x/pageWidth)
    imageMarqueePageControl.currentPage = currentPage
  }
}

