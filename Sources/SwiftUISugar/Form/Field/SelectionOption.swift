import Foundation

public protocol SelectionOption {
    var optionId: String { get }
    var isGroup: Bool { get }
    var subOptions: [SelectionOption]? { get }
}

extension SelectionOption {
    public var isGroup: Bool {
        return false
    }
    
    public var subOptions: [SelectionOption]? {
        nil
    }
}

public struct SelectionDivider: SelectionOption {
    public var optionId: String { return "divider" }
    public init() {
        
    }
}
