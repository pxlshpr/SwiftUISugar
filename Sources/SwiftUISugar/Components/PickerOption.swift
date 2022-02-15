import Foundation

public protocol PickerOption {
    func title(isPlural: Bool) -> String
}

public extension PickerOption {
    func title(for value: Double) -> String {
        title(isPlural: value > 1)
    }
}
