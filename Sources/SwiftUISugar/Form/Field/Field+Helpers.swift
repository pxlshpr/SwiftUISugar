import SwiftUI

extension Field {
    
    var isPlural: Bool {
        guard let value = value?.wrappedValue, let double = Double(value) else { return false }
        return double > 1
    }

    //MARK: - Strings
    
    func title(for option: SelectionOption) -> String {
        stylingProvider?.title(for: option, isPlural: false) ?? "Unsupported Option"
    }

    var subtitle: String? {
        guard let unit = selectedUnit?.wrappedValue else { return nil }
        return stylingProvider?.subtitle(for: unit, isPlural: isPlural)
    }

    var selectedUnitString: String {
        guard let selectedUnit = selectedUnit?.wrappedValue else {
            return ""
        }
        return unitString(for: selectedUnit)
    }

    func unitString(for unit: SelectionOption?) -> String {
        guard let unit = unit, let stylingProvider = stylingProvider else {
            return ""
        }
        if let value = value, let doubleValue = Double(value.wrappedValue) {
            return stylingProvider.title(for: unit, isPlural: doubleValue > 1)
        } else {
            return stylingProvider.title(for: unit, isPlural: false)
        }
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
