import SwiftUI

extension Field {
    
    var isPlural: Bool {
        guard let value = value?.wrappedValue, let double = Double(value) else { return false }
        return double > 1
    }

    //MARK: - Strings
    
    func title(for option: SelectionOption) -> String {
        contentProvider?.title(for: option, isPlural: false)
        ?? option.title(isPlural: false)
        ?? "Unsupported Option"
    }

    var subtitle: String? {
        guard let unit = selectedUnit?.wrappedValue else { return nil }
        return contentProvider?.subtitle(for: unit, isPlural: isPlural)
        ?? unit.subtitle(isPlural: isPlural)
    }

    var selectedUnitString: String {
        guard let selectedUnit = selectedUnit?.wrappedValue else { return "" }
        return unitString(for: selectedUnit)
    }

    func unitString(for option: SelectionOption?) -> String {
        guard let option = option else { return "" }
        var isPlural = false
        if let value = value, let doubleValue = Double(value.wrappedValue) {
            isPlural = doubleValue > 1
        }
        return contentProvider?.title(for: option, isPlural: isPlural) ?? option.title(isPlural: isPlural) ?? ""
    }
    
    //MARK: - Colors
    
    var foregroundColor: Color {
        colorScheme == .light ? .accentColor : .white
    }

    var pillBackgroundColor: Color {
        colorScheme == .light ? Color(hex: "E7E1FF") : .accentColor
    }

    var unitTextColor: Color {
        guard let units = units?.wrappedValue else {
            return Color(.secondaryLabel)
        }
        return units.count > 1 ? Color.accentColor : Color(.secondaryLabel)
    }

}
