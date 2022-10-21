#if canImport(UIKit)
import UIKit

public extension UIFont {
    func fontSize(for text: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: self]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size
    }
}
#endif
