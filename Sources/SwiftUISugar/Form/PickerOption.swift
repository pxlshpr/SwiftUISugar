import Foundation

public protocol StringsProvider {
    func title(for option: PickerOption, isPlural: Bool) -> String
    func subtitle(for option: PickerOption, isPlural: Bool) -> String?
    func systemImageName(for option: PickerOption) -> String?
    func shouldPlaceDividerBefore(_ option: PickerOption, within options: [PickerOption]) -> Bool
}

/// Default implementations
extension StringsProvider {
    func shouldPlaceDividerBefore(_ option: PickerOption, within options: [PickerOption]) -> Bool {
        return false
    }
    func systemImageName(for option: PickerOption) -> String? {
        return nil
    }
}

public protocol PickerOption {
    var optionId: String { get }
}
