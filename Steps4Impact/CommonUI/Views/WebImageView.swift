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
import SDWebImage

class WebImageView: UIImageView {
  func fadeInImage(imageURL: URL?, placeHolderImage: UIImage? = nil, completionHandler: @escaping ((Bool) -> Void) = {_ in }) {
    if placeHolderImage == nil {
      alpha = 0.0
    }
    // swiftlint:disable:next line_length
    let completion: SDExternalCompletionBlock = { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
      if let _ = image {
        completionHandler(true)
      }
      if cacheType == .none {
        self?.alpha = 0.0
        UIView.animate(withDuration: 0.1, animations: {
          self?.alpha = 1.0
        })
      }
    }

    sd_imageIndicator = SDWebImageProgressIndicator.`default`

    if let placeHolderImage = placeHolderImage {
      sd_setImage(with: imageURL, placeholderImage: placeHolderImage, options: [], completed: completion)
    } else {
      sd_setImage(with: imageURL, completed: completion)
    }
  }

  func stopLoading() {
    sd_imageIndicator = nil
    sd_cancelCurrentImageLoad()
  }
}
