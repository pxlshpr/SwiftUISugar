#if canImport(UIKit)
import UIKit

public extension UIImage {
    func fixOrientationIfNeeded() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Unable to fix orientation of image")
            return self
        }
        UIGraphicsEndImageContext()

        return normalizedImage
    }
    
    var isLandscape: Bool {
        size.width > size.height
    }
}
#endif
