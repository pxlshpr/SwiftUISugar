#if canImport(UIKit)
import SwiftUI

public struct FormStyledScrollView<Content: View>: View {
    
//    @Environment(\.colorScheme) var colorScheme
    
//    let customBackgroundColor: Color?
    var content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
//        self.customBackgroundColor = backgroundColor
        self.content = content
    }
    
//    var backgroundColor: Color {
//        guard let customBackgroundColor else {
////            return colorScheme == .dark ? Color(hex: "1C1C1E") : Color(hex: "F2F1F6")
//            return colorScheme == .dark ? Color(hex: "1C1C1E") : Color(.systemGroupedBackground)
//        }
//        return customBackgroundColor
//    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            content()
                .frame(maxWidth: .infinity)
        }
        .background(
            FormBackground()
//            backgroundColor
                .edgesIgnoringSafeArea(.all) /// requireds to cover the area that would be covered by the keyboard during its dismissal animation
        )
    }
}

public struct FormBackground: View {
    @Environment(\.colorScheme) var colorScheme
    public init() { }
    public var body: some View {
        formBackgroundColor(colorScheme: colorScheme)
    }
}

public struct FormBackgroundShapeStyle: ShapeStyle {
    @Environment(\.colorScheme) var colorScheme
    public init() { }
    public var body: some View {
        formBackgroundColor(colorScheme: colorScheme)
    }
}

public struct FormCellBackground: View {
    @Environment(\.colorScheme) var colorScheme
    public init() { }
    public var body: some View {
        formCellBackgroundColor(colorScheme: colorScheme)
    }
}

public struct FormCellBackgroundShapeStyle: ShapeStyle {
    @Environment(\.colorScheme) var colorScheme
    public init() { }
    public var body: some View {
        formCellBackgroundColor(colorScheme: colorScheme)
    }
}


public func formBackgroundColor(colorScheme: ColorScheme) -> Color {
    return colorScheme == .dark ? Color(hex: "1C1C1E") : Color(.systemGroupedBackground)
}

public func formCellBackgroundColor(colorScheme: ColorScheme) -> Color {
    return colorScheme == .light ? Color(.secondarySystemGroupedBackground) : Color(hex: "2C2C2E")
}

#endif
