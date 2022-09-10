import UIKit

public extension UIViewController {
    func dismissParent() {
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    func dismiss() {
        presentingViewController?.dismiss(animated: true)
    }
}

public extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
}

public func dismissKeyboard() {
    keyWindow?.endEditing(true)
}
