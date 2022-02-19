import Foundation

public protocol StringsProvider {
    func title(isPlural: Bool) -> String
    func subtitle(isPlural: Bool) -> String?
}

public protocol PickerOption {
    var optionId: String { get }
//    func title(isPlural: Bool) -> String
//    func subtitle(isPlural: Bool) -> String?
}

//public extension PickerOption {
//    func subtitle(isPlural: Bool) -> String? {
//        return nil
//    }
//}

//public extension PickerOption {
//    func title(for value: Double?) -> String {
//        guard let value = value else { return title(isPlural: false) }
//        return title(isPlural: value > 1)
//    }
//    func subtitle(for value: Double?) -> String? {
//        guard let value = value else { return subtitle(isPlural: false) }
//        return subtitle(isPlural: value > 1)
//    }
//}
