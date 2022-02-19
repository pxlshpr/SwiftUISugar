import Foundation

public protocol StringsProvider {
    func title(for option: PickerOption, isPlural: Bool) -> String
    func subtitle(for option: PickerOption, isPlural: Bool) -> String?
}

public protocol PickerOption {
    var optionId: String { get }
}
