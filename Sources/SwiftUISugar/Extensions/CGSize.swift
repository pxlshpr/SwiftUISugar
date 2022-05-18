import UIKit

public extension CGSize {
    var widthToHeightRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }
}
