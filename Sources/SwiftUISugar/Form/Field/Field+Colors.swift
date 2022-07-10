import SwiftUI

extension Field {
    
    
    var labelColor: Color {
        guard let value = value else {
            return Color(.label)
        }
        guard !isFocused else {
            return Color.accentColor
        }
        return value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel)
    }
    
    var placeholderColor: Color {
        guard let value = value else {
            return Color(.secondaryLabel)
        }
        return value.wrappedValue.count > 0 ? Color(.secondarySystemGroupedBackground) : Color(.secondaryLabel)
    }
    
}
