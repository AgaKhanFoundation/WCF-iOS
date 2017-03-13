import UIKit

//TODO: Update this based on style guide from UX/UI person
struct Style {
    
    struct Colors {
        static let basic = #colorLiteral(red: 0.1529411765, green: 0.1215686275, blue: 0.1215686275, alpha: 1) // #271F1F
        static let white = #colorLiteral(red: 0.9882352941, green: 1, blue: 0.9607843137, alpha: 1) // #FCFFF5
        static let accent = #colorLiteral(red: 0.344225198, green: 0.6224462986, blue: 0.1597332358, alpha: 1) // #699D3D //TODO: Replace with AKDN branding
    }
    
    enum Typography {
        //TODO: Add more styles as a style guide is made
        case header
        case title
        case body
        case button
        
        //TODO: Custom fonts can be replaced here
        var font: UIFont? {
            switch self {
            case .header: return UIFont.preferredFont(forTextStyle: .headline)
            case .title: return UIFont.preferredFont(forTextStyle: .subheadline)
            case .body: return UIFont.preferredFont(forTextStyle: .body)
            case .button: return UIFont.preferredFont(forTextStyle: .callout)
            }
        }
    }
}

extension UILabel {
    convenience init(_ typography: Style.Typography) {
        self.init()
        font = typography.font
        textColor = Style.Colors.basic
        numberOfLines = 0
    }
}

extension UITextField {
    convenience init(_ typography: Style.Typography) {
        self.init()
        font = typography.font
        textColor = Style.Colors.basic
    }
}
