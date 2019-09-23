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
import UIKit

let cache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
  convenience init(asset: Assets) {
    self.init(image: asset.image)
  }

  public func loadImage(from urlString: String) {
    if let cached = cache.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = cached
      return
    }

    guard let url = URL(string: urlString) else {
      print("URL cannot be created from - \(urlString)")
      return
    }

    URLSession.shared.dataTask(
      with: url,
      completionHandler: { (data, _, error) -> Void in
        guard error == nil else {
          print("error downloading image: \(String(describing: error?.localizedDescription))")
          return
        }

        guard let data = data else {
          print("data cannot be nil")
          return
        }

        guard let image = UIImage(data: data) else {
          print("error creating UIImage")
          return
        }

        onMain {
          cache.setObject(image, forKey: urlString as AnyObject)
          self.image = image
        }
    }).resume()
  }
}
