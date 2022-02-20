import Foundation

public protocol StylingProvider {
    func title(for option: PickerOption, isPlural: Bool) -> String
    func subtitle(for option: PickerOption, isPlural: Bool) -> String?
    func systemImageName(for option: PickerOption) -> String?
    func shouldPlaceDividerBefore(_ option: PickerOption, within options: [PickerOption]) -> Bool
}

/// Default implementations
extension StylingProvider {
    public func shouldPlaceDividerBefore(_ option: PickerOption, within options: [PickerOption]) -> Bool {
        return false
    }
    public func systemImageName(for option: PickerOption) -> String? {
        return nil
    }
}

public protocol PickerOption {
    var optionId: String { get }
}
