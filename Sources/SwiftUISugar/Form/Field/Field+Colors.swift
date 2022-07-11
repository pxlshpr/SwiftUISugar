import SwiftUI

extension Field {
    
    //MARK: - Foreground Colors
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
    
    //TODO: Make these configurable, preferably in one place with each project that uses it
    var foregroundColor: Color {
        if isFocused {
            return .white
        }
//        guard selectorStyle != .prominent else {
//            return colorScheme == .light ? .accentColor : .white
//        }
//        return .accentColor
//        return colorScheme == .light ? .accentColor : Color(hex: "9F85FE")
        if isLight {
            if isFocused {
                return Color.white
//                return Color(hex: ColorHexPurpleExtraLight)
            } else {
                return Color(hex: ColorHexPurpleDark)
            }
        } else {
            return Color(hex: ColorHexPurpleLight)
        }
    }
    
//    var unitTextColor: Color {
//        guard let units = units?.wrappedValue else {
//            return Color(.secondaryLabel)
//        }
//        return units.count > 1 ? .accentColor : Color(.secondaryLabel)
//    }
//
    var singleOptionForegroundColor: Color {
        foregroundColor
//        switch selectorStyle {
//        case .plain:
//            return haveValue ? Color(.secondaryLabel) : Color(.tertiaryLabel)
//        case .prominent:
//            return foregroundColor
//        }
    }
    
    //MARK: - Background Colors
    
    var singleOptionBackground: some View {
        backgroundView
    }
    
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(pillBackgroundColor)
//            .overlay(RoundedRectangle(cornerRadius: 6))
    }

    var pillBackgroundColor: Color {
//        colorScheme == .light ? Color(hex: ColorHexPurpleExtraLight) : Color(hex: ColorHexPurpleExtraDark)
        if isFocused {
            return .accentColor
        }
        if isLight {
            if isFocused {
                return Color(hex: ColorHexPurpleLight)
            } else {
                return Color(hex: ColorHexPurpleExtraLight)
            }
        } else {
            return Color(hex: ColorHexPurpleExtraDark)
        }
    }
    
    var isLight: Bool {
        colorScheme == .light
    }
    
    var rowBackgroundColor: some View {
        Group {
            if isFocused {
                if isLight {
                    Color(hex: ColorHexPurpleExtraLight)
                } else {
//                    Color(hex: ColorHexPurpleDarkMuted)
                    Color(hex: ColorHexPurpleExtraDark)
                }
//                Color.accentColor
//                    .opacity(0.2)
//                    .grayscale(0.2)
//                    .brightness(0.3)
            } else {
                Color(.secondarySystemGroupedBackground)
            }
        }
    }
}

let ColorHexPurpleDark = "6236FF"
let ColorHexPurpleDarkMuted = "3E3953"
let ColorHexPurpleExtraDark = "2A263A"
let ColorHexPurpleLight = "9F85FE"
let ColorHexPurpleLightMuted = "E3DDFC"
let ColorHexPurpleExtraLight = "E7E1FF"
