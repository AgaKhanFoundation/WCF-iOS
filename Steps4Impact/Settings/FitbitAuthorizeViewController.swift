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

import Foundation
import OAuthSwift
import WebKit

class FitbitAuthorizeViewController: OAuthWebViewController {
  var targetURL: URL?
  let navBar = UINavigationBar()
  let wkWebView: WKWebView = WKWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Style.Colors.white
    setupNavigationBar()
    setupWebView()
  }

  override func handle(_ url: URL) {
    targetURL = url
    super.handle(url)
    loadAddressURL()
  }

  private func setupNavigationBar() {
    view.addSubview(navBar)

    let navItem = UINavigationItem(title: "")
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
    navItem.rightBarButtonItem = doneItem
    navBar.setItems([navItem], animated: false)

    let guide = view.safeAreaLayoutGuide
    navBar.snp.makeConstraints {
      $0.leading.trailing.equalTo(guide)
      $0.top.equalTo(guide.snp.top)
      $0.height.equalTo(44)
    }
  }

  private func setupWebView() {
    view.addSubview(wkWebView)

    let guide = view.safeAreaLayoutGuide
    wkWebView.navigationDelegate = self
    wkWebView.snp.makeConstraints {
      $0.leading.trailing.equalTo(guide)
      $0.top.equalTo(navBar.snp.bottom)
      $0.bottom.equalTo(guide.snp.bottom)
    }
  }

  @objc func done() {
    dismissWebViewController()
  }

  func loadAddressURL() {
    guard let url = targetURL else { return }

    let urlRequest = URLRequest(url: url)
    wkWebView.load(urlRequest)
  }
}

extension FitbitAuthorizeViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if let url = navigationAction.request.url,
      let fitbitUri = URL(string: AppConfig.fitbitCallbackUri),
      url.host == fitbitUri.host {
      OAuthSwift.handle(url: url)
      decisionHandler(.cancel)

      dismissWebViewController()
      return
    }

    decisionHandler(.allow)
  }
}
