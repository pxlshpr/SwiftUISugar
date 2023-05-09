import SwiftSugar
import UIKit
import ColorKit

public extension CGColor {
    
    var hex: String {
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        return hexString.lowercased()
    }
}

public extension Array where Element == UIColor {
    
    var candidateArtworkSubset: [UIColor] {
        var candidates: [UIColor] = []
        
        print("▪️")
        for color in self {
            let hex = color.cgColor.hexString
            let brightness = color.brightness
            guard brightness > 10,
//                  brightness < 250
//                  brightness < 125
//                  brightness < 200
                brightness < 150
            else {
                print("▪️ Too bright or dark - \(hex) (\(color.brightness))")
                continue
            }
            
            guard color.isDifferentFrom(others: candidates) else {
                print("▪️ Too similar - \(hex) (\(color.brightness))")
                continue
            }
            
            print("▪️ Adding - \(hex) (\(color.brightness))")
            candidates.append(color)
        }

        print("▪️")
        candidates.forEach {
            print("▪️ \($0.hex) \($0.brightness)")
        }
        
//        candidates.sort { ($0.brightness ?? 0) < ($1.brightness ?? 0) }
//
//        print("▪️")
//        print("▪️ After sorting")
//        candidates.forEach {
//            print("▪️ \($0.hex) \($0.brightness ?? 0)")
//        }
        
        return candidates
    }
}

public extension UIColor {
    func isDifferentFrom(others: [UIColor], threshold: CGFloat = 25.0) -> Bool {
        for other in others {
            let difference = difference(from: other, using: .CIE76)
            guard difference.associatedValue > threshold else {
                print("     \(self.hex) - \(other.hex) = \(difference)")
                return false
            }
        }
        return true
    }
}

public extension UIColor.ColorDifferenceResult {
    var associatedValue: CGFloat {
        switch self {
        case .indentical(let value),
             .similar(let value),
             .close(let value),
             .near(let value),
             .different(let value),
             .far(let value):
             return value
        }
    }
}
