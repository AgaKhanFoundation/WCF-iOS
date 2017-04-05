
import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    for view in views {
      addSubview(view)
    }
  }
}

extension UIViewController {
  func alert(message: String, title: String = "Error",
             style: UIAlertActionStyle = .default) {
    let alert = UIAlertController(title: title, message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: style, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

