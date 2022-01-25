import SwiftUI

public struct CustomCorner: Shape {
    public var corners: UIRectCorner
    public var radius: CGFloat
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
