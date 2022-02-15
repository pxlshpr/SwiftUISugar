import Foundation

public protocol PickerOption {
    var optionId: String { get }
    func title(isPlural: Bool) -> String
}

public extension PickerOption {
    func title(for value: Double) -> String {
        title(isPlural: value > 1)
    }
}
