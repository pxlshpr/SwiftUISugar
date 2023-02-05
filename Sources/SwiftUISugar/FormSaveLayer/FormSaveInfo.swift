import Foundation

public struct FormSaveInfo {
    public let title: String
    public let tapHandler: (() -> ())?
    public let badge: Int?
    public let systemImage: String?
    
    public init(title: String, badge: Int, tapHandler: (() -> ())? = nil) {
        self.title = title
        self.tapHandler = tapHandler
        self.badge = badge
        self.systemImage = nil
    }
    
    public init(title: String, systemImage: String, tapHandler: (() -> ())? = nil) {
        self.title = title
        self.tapHandler = tapHandler
        self.badge = nil
        self.systemImage = systemImage
    }

    public init(title: String, tapHandler: (() -> ())? = nil) {
        self.title = title
        self.tapHandler = tapHandler
        self.badge = nil
        self.systemImage = nil
    }
}

