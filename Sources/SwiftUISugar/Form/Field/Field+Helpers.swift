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
        var isPlural = true
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
    //TODO: Make these configurable, preferably in one place with each project that uses it
    var foregroundColor: Color {
//        guard selectorStyle != .prominent else {
//            return colorScheme == .light ? .accentColor : .white
//        }
//        return .accentColor
//        return colorScheme == .light ? .accentColor : Color(hex: "9F85FE")
        colorScheme == .light ? Color(hex: "6236FF") : Color(hex: "9F85FE")
    }

    var pillBackgroundColor: Color {
//        colorScheme == .light ? Color(hex: "E7E1FF") : .accentColor
        colorScheme == .light ? Color(hex: "E7E1FF") : Color(hex: "2A263A")
    }

    var unitTextColor: Color {
        guard let units = units?.wrappedValue else {
            return Color(.secondaryLabel)
        }
        return units.count > 1 ? .accentColor : Color(.secondaryLabel)
    }

}
