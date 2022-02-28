import Foundation

public protocol SelectionOption {
    var optionId: String { get }
    var isGroup: Bool { get }
    var subOptions: [SelectionOption]? { get }
    
    func title(isPlural: Bool) -> String?
    func subtitle(isPlural: Bool) -> String?
    var systemImage: String? { get }
}

extension SelectionOption {
    public var isGroup: Bool { false }
    public var subOptions: [SelectionOption]? { nil }
    public func title(isPlural: Bool) -> String? { nil }
    public func subtitle(isPlural: Bool) -> String? { nil }
    public var systemImage: String? { nil }
}
