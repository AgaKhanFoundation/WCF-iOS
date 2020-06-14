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

protocol JourneyDetailDelegate: class {
  func didGetShareText(_ shareText: String)
}

struct JourneyDetailContext: CellContext {
  var identifier: String = JourneyDetailCell.identifier
  var milestone: Milestone?
}

class JourneyDetailCell: ConfigurableTableViewCell {
  static var identifier = "JourneyDetailCell"
  weak var delegate: JourneyDetailDelegate?
  
  private let titleLabel = UILabel(typography: .headerTitle)
  private let subtitleLabel = UILabel(typography: .title)
  private let bodyText: UITextView = {
    let textView = UITextView()
    textView.isUserInteractionEnabled = true
    textView.isEditable = false
    textView.isScrollEnabled = false
    textView.contentInset = .zero
    return textView
  }()
  
  override func commonInit() {
    super.commonInit()
    
    contentView.addSubview(titleLabel) {
      $0.top.equalToSuperview().offset(Style.Padding.p20)
      $0.leading.equalToSuperview().offset(Style.Padding.p24)
      $0.trailing.equalToSuperview().inset(Style.Padding.p24)
    }
    
    contentView.addSubview(subtitleLabel) {
      $0.top.equalTo(titleLabel.snp.bottom).offset(Style.Padding.p8)
      $0.leading.equalToSuperview().offset(Style.Padding.p24)
      $0.trailing.equalToSuperview().inset(Style.Padding.p24)
    }
    
    contentView.addSubview(bodyText) {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(Style.Padding.p16)
      $0.leading.equalToSuperview().offset(Style.Padding.p24)
      $0.trailing.bottom.equalToSuperview().inset(Style.Padding.p24)
      $0.bottom.equalToSuperview()
    }
    
    titleLabel.textColor = Style.Colors.FoundationGrey
    subtitleLabel.textColor = Style.Colors.FoundationGrey
  }
  
  func configure(context: CellContext) {
    guard let detailContext = context as? JourneyDetailContext,
      let milestone = detailContext.milestone else { return }
    
    titleLabel.text = milestone.name
    subtitleLabel.text = milestone.subtitle
    bodyText.attributedText = getContentAttributedText(from: milestone)
  }
}

extension JourneyDetailCell {
  func getContentAttributedText(from milestone: Milestone) -> NSMutableAttributedString {
    let htmlstring = milestone.content
    let stringtext = htmlstring.html2String
    let result = NSMutableAttributedString()
    let split = stringtext.components(separatedBy: "https")
    
    if let urlString = split[safe: 1] {
      let stringURL = "https\(urlString)"
      let attributedString = NSMutableAttributedString(string: stringURL)
      if let url = URL(string: stringURL) {
        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, stringURL.count))
      }
      
      // Set how links should appear: blue and underlined
      self.bodyText.linkTextAttributes = [
        .foregroundColor: UIColor.blue,
        .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
      delegate?.didGetShareText("\(milestone.subtitle): \(stringURL)")
      let partone = NSMutableAttributedString(string: split[safe: 0] ?? "")
      let parttwo = NSMutableAttributedString(attributedString: attributedString)
      result.append(partone)
      result.append(parttwo)
    } else {
      delegate?.didGetShareText(milestone.subtitle)
      result.append(NSMutableAttributedString(string: stringtext))
    }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = Style.Size.s8
    result.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, result.length))
    if let font = Style.Typography.smallRegular.font {
      result.addAttribute(.font, value: font, range: NSMakeRange(0, result.length))
    }
    return result
  }
}

extension Data {
  var html2AttributedString: NSAttributedString? {
    do {
      return try NSAttributedString(
        data: self,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.utf8.rawValue],
        documentAttributes: nil)
    } catch {
      print("error:", error)
      return  nil
    }
  }
  var html2String: String {
    return html2AttributedString?.string ?? ""
  }
}

extension String {
  var html2AttributedString: NSAttributedString? {
    return Data(utf8).html2AttributedString
  }
  var html2String: String {
    return html2AttributedString?.string ?? ""
  }
}
