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

struct JourneyImageMarqueeContext: CellContext {
  var identifier: String = JourneyImageMarqueeCell.identifier
  var milestone: Milestone?
}

class JourneyImageMarqueeCell: ConfigurableTableViewCell {
  static var identifier = "JourneyImageMarqueeCell"
  lazy var imageMarqueeScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isPagingEnabled = true
    return scrollView
  }()
  lazy var imageMarqueePageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPageIndicatorTintColor = Style.Colors.FoundationGreen
    pageControl.pageIndicatorTintColor = Style.Colors.Seperator
    return pageControl
  }()
  
  override func commonInit() {
    super.commonInit()
    
    contentView.addSubview(imageMarqueeScrollView) {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.left.equalTo(contentView.snp.left)
      $0.right.equalTo(contentView.snp.right)
      $0.height.width.equalTo(contentView.frame.width)
    }
    
    contentView.addSubview(imageMarqueePageControl) {
      $0.top.equalTo(imageMarqueeScrollView.snp.bottom).offset(Style.Padding.p8)
      $0.width.equalTo(Style.Size.s128)
      $0.height.equalTo(Style.Size.s16)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  func configure(context: CellContext) {
    guard let marqueeContext = context as? JourneyImageMarqueeContext,
      let milestone = marqueeContext.milestone else { return }
    
    let mediaURLs = milestone.getMediaURLs()
    imageMarqueePageControl.numberOfPages = mediaURLs.count
    imageMarqueePageControl.currentPage = 0
    imageMarqueePageControl.isHidden = mediaURLs.count < 2
    
    imageMarqueeScrollView.subviews.forEach({ $0.removeFromSuperview() })
    if mediaURLs.count == 0 {
      let imageView = WebImageView()
      imageView.contentMode = .scaleAspectFit
      imageView.fadeInImage(imageURL: URL(string: ""), placeHolderImage: Assets.journeyDetailMock.image)
      let xPosition = contentView.frame.width
      imageView.frame = CGRect(
        x: xPosition, y: 0,
        width: self.imageMarqueeScrollView.frame.width,
        height: self.imageMarqueeScrollView.frame.height)
      imageMarqueeScrollView.addSubview(imageView)
    } else {
      imageMarqueeScrollView.contentSize.width = imageMarqueeScrollView.frame.width * CGFloat(mediaURLs.count)
      for i in 0..<mediaURLs.count { // swiftlint:disable:this variable_name
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.fadeInImage(imageURL: URL(string: mediaURLs[i]), placeHolderImage: Assets.journeyDetailMock.image)
        let xPosition = imageMarqueeScrollView.frame.width * CGFloat(i)
        imageView.frame = CGRect(
          x: xPosition, y: 0,
          width: self.imageMarqueeScrollView.frame.width,
          height: self.imageMarqueeScrollView.frame.height)
        imageMarqueeScrollView.addSubview(imageView)
      }
    }
  }
}

extension JourneyImageMarqueeCell: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageWidth = imageMarqueeScrollView.frame.width
    let currentPage = Int(scrollView.contentOffset.x / pageWidth)
    imageMarqueePageControl.currentPage = currentPage
  }
}
