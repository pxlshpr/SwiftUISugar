import Foundation

public protocol StylingProvider {
    func title(for option: SelectionOption, isPlural: Bool) -> String
    func subtitle(for option: SelectionOption, isPlural: Bool) -> String?
    func systemImageName(for option: SelectionOption) -> String?
    func shouldPlaceDividerBefore(_ option: SelectionOption, within options: [SelectionOption]) -> Bool
}

/// Default implementations
extension StylingProvider {
    public func shouldPlaceDividerBefore(_ option: SelectionOption, within options: [SelectionOption]) -> Bool {
        return false
    }
    public func systemImageName(for option: SelectionOption) -> String? {
        return nil
    }
}

public protocol SelectionOption {
    var optionId: String { get }
}
