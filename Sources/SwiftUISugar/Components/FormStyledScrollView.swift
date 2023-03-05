#if canImport(UIKit)
import SwiftUI

public struct FormStyledScrollView<Content: View>: View {
    
    var content: () -> Content
    let showsIndicators: Bool
    let isLazy: Bool
    let customVerticalSpacing: CGFloat?

    public init(showsIndicators: Bool = false, isLazy: Bool = true, customVerticalSpacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.isLazy = isLazy
        self.showsIndicators = showsIndicators
        self.customVerticalSpacing = customVerticalSpacing
    }
    
    public var body: some View {
        var spacing: CGFloat {
            customVerticalSpacing ?? K.FormStyledScrollView.verticalSpacing
        }
        
        var vStack: some View {
            VStack(spacing: spacing) {
                content()
                    .frame(maxWidth: .infinity)
            }
        }
        
        var lazyVStack: some View {
            LazyVStack(spacing: spacing) {
                content()
                    .frame(maxWidth: .infinity)
            }
        }
        return ScrollView(showsIndicators: showsIndicators) {
            if isLazy {
                lazyVStack
            } else {
                vStack
            }
        }
        .background(
            FormBackground()
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

public struct FormCellBackground: View {
    @Environment(\.colorScheme) var colorScheme
    public init() { }
    public var body: some View {
        formCellBackgroundColor(colorScheme: colorScheme)
    }
}

public func formBackgroundColor(colorScheme: ColorScheme) -> Color {
    colorScheme == .dark ? Color(hex: "1C1C1E") : Color(.systemGroupedBackground)
}

public func formCellBackgroundColor(colorScheme: ColorScheme) -> Color {
    colorScheme == .light ? Color(.secondarySystemGroupedBackground) : Color(hex: "2C2C2E")
}

public struct ListBackground: View {
    @Environment(\.colorScheme) var colorScheme
    public init() { }
    public var body: some View {
        listBackgroundColor(colorScheme: colorScheme)
    }
}

public struct ListCellBackground: View {
    @Environment(\.colorScheme) var colorScheme
    public init() { }
    public var body: some View {
        listCellBackgroundColor(colorScheme: colorScheme)
    }
}

public func listBackgroundColor(colorScheme: ColorScheme) -> Color {
    colorScheme == .light ? Color(.systemGroupedBackground) : Color(hex: "191919")
}

public func listCellBackgroundColor(colorScheme: ColorScheme) -> Color {
    colorScheme == .light ? Color(.secondarySystemGroupedBackground) : Color(hex: "232323")
}

#endif
