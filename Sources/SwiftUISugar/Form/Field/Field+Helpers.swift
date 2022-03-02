import SwiftUI

extension Field {
    
    var isPlural: Bool {
        guard let value = value?.wrappedValue, let double = Double(value) else { return false }
        return double > 1
    }

    //MARK: - Strings
    
//    func title(for option: SelectionOption) -> String {
//        contentProvider?.title(for: option, isPlural: false)
//        ?? option.title(isPlural: false)
//        ?? "Unsupported Option"
//    }

    var subtitle: String? {
        guard let unit = selectedUnit?.wrappedValue else { return nil }
        return contentProvider?.subtitle(for: unit, isPlural: isPlural)
        ?? unit.subtitle(isPlural: isPlural)
    }

    var title: String {
        guard let selectedUnit = selectedUnit?.wrappedValue else { return "" }
        return title(for: selectedUnit)
    }

    func title(for option: SelectionOption?, forMenu: Bool = false) -> String {
        guard let option = option else { return "Unsupported" }
        var isPlural = false
        if let value = value, let doubleValue = Double(value.wrappedValue) {
            isPlural = doubleValue > 1
        }
        if forMenu {
            return contentProvider?.menuTitle(for: option, isPlural: isPlural)
            ?? option.menuTitle(isPlural: isPlural)
            ?? contentProvider?.title(for: option, isPlural: isPlural)
            ?? option.title(isPlural: isPlural) ?? "Unsupported"
        } else {
            return contentProvider?.title(for: option, isPlural: isPlural) ?? option.title(isPlural: isPlural) ?? "Unsupported"
        }
    }
    
    //MARK: - Colors
    
    var foregroundColor: Color {
        guard selectorStyle != .prominent else {
            return colorScheme == .light ? .accentColor : .white
        }
        return .accentColor
    }

    var pillBackgroundColor: Color {
        colorScheme == .light ? Color(hex: "E7E1FF") : .accentColor
    }

    var unitTextColor: Color {
        guard let units = units?.wrappedValue else {
            return Color(.secondaryLabel)
        }
        return units.count > 1 ? .accentColor : Color(.secondaryLabel)
    }

}
