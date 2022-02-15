import Foundation

public protocol PickerOption {
    var unitId: String { get }
    var nameSingular: String { get }
    var namePlural: String { get }
}

public extension PickerOption {
    func name(for value: Double) -> String {
        value > 1 ? namePlural : nameSingular
    }
}
