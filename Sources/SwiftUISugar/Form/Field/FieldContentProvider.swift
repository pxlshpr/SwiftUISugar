import Foundation

public protocol FieldContentProvider {
    func title(for option: SelectionOption, isPlural: Bool) -> String?
    func subtitle(for option: SelectionOption, isPlural: Bool) -> String?
    func systemImage(for option: SelectionOption) -> String?
}

/// Default implementations
extension FieldContentProvider {
    func title(for option: SelectionOption, isPlural: Bool) -> String? {
        return nil
    }
    func subtitle(for option: SelectionOption, isPlural: Bool) -> String? {
        return nil
    }
    public func systemImage(for option: SelectionOption) -> String? {
        return nil
    }
}

