import SwiftUI

/// Used for animated numbers, see https://stefanblos.com/posts/animating-number-changes/
extension Int: VectorArithmetic {
    mutating public func scale(by rhs: Double) {
        self = Int(Double(self) * rhs)
    }

    public var magnitudeSquared: Double {
        Double(self * self)
    }
}

