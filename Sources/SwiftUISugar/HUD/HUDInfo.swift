import Foundation
import SwiftUI

public struct HUDInfo: Identifiable, Equatable {

    public let id: UUID
    public let message: String
    public let title: String?
    public let systemImage: String?

    public let displayEdge: Edge
    public let ignoresSafeArea: Bool

    public let type: HUDType
    public let displayDuration: TimeInterval
    public let dismissOnTap: Bool
    public var tapHandler: (()->Void)?
    
    public init(
        id: UUID = UUID(),
        title: String? = nil,
        message: String,
        systemImage: String? = nil,
        
        displayEdge: Edge? = nil,
        ignoresSafeArea: Bool = false,
        displayDuration: TimeInterval? = nil,

        type: HUDType = .info,
        dismissOnTap: Bool = true,
        tapHandler: (()->Void)? = nil)
    {
        self.id = id
        self.title = title
        self.message = message
        self.systemImage = systemImage

        self.displayEdge = displayEdge ?? .top
        self.ignoresSafeArea = ignoresSafeArea
        self.displayDuration = displayDuration ?? 3

        self.type = type
        self.dismissOnTap = dismissOnTap
        self.tapHandler = tapHandler
    }
    
    public static func == (lhs: HUDInfo, rhs: HUDInfo) -> Bool {
        lhs.id == rhs.id
    }
}

public enum HUDType {
    case info
    case success
    case warning
    case error
}
