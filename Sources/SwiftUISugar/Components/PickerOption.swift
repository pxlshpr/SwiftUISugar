import Foundation

public protocol PickerOption {
    func asEquatable() -> EquatablePickerOption
    func isEqualTo(_ other: PickerOption) -> Bool
    var unitId: String { get }
    var nameSingular: String { get }
    var namePlural: String { get }
}

public extension PickerOption {
    func name(for value: Double) -> String {
        value > 1 ? namePlural : nameSingular
    }
}

///Protocol Equatable Conformance hack from: https://khawerkhaliq.com/blog/swift-protocols-equatable-part-two/

extension PickerOption where Self: Equatable {
    public func asEquatable() -> EquatablePickerOption {
        return EquatablePickerOption(self)
    }
    
    public func isEqualTo(_ other: PickerOption) -> Bool {
        guard let otherFruit = other as? Self else { return false }
        return self == otherFruit
    }
}

public struct EquatablePickerOption: PickerOption {
    init(_ unit: PickerOption) {
        self.unit = unit
    }
    
    public var unitId: String {
        return unit.unitId
    }
    
    public var nameSingular: String {
        return unit.nameSingular
    }

    public var namePlural: String {
        return unit.namePlural
    }

    private let unit: PickerOption
}

extension EquatablePickerOption: Equatable {
    public static func ==(lhs: EquatablePickerOption, rhs: EquatablePickerOption) -> Bool {
        return lhs.unit.isEqualTo(rhs.unit)
    }
}
