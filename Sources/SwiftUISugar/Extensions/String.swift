import SwiftUI

public extension String {
    var widthForLabelFont: CGFloat {
        let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        let size = font.fontSize(for: self)
        return size.width
    }
}
