import Foundation
import UIKit

/// Source: https://www.fivestars.blog/articles/swiftui-windows/
public class PassThroughWindow: UIWindow {
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else {
            return nil
        }
        return rootViewController?.view == hitView ? nil : hitView
    }
}
