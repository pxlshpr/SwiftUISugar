#if canImport(UIKit)
import SwiftUI

public struct FormStyledScrollView<Content: View>: View {
    
    var content: () -> Content
    let showsIndicators: Bool
    let customVerticalSpacing: CGFloat?

    public init(showsIndicators: Bool = false, customVerticalSpacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.showsIndicators = showsIndicators
        self.customVerticalSpacing = customVerticalSpacing
    }
    
    public var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            LazyVStack(spacing: customVerticalSpacing ?? K.FormStyledScrollView.verticalSpacing) {
                content()
                    .frame(maxWidth: .infinity)
            }
        }
        .background(
            FormBackground()
                .edgesIgnoringSafeArea(.all) /// requireds to cover the area that would be covered by the keyboard during its dismissal animation
        )
    }
}

public struct FormStyledVStack<Content: View>: View {
    
    var content: () -> Content
    let customVerticalSpacing: CGFloat?

    public init(customVerticalSpacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.customVerticalSpacing = customVerticalSpacing
    }
    
    public var body: some View {
        VStack(spacing: customVerticalSpacing ?? K.FormStyledScrollView.verticalSpacing) {
            content()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
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
    return colorScheme == .dark ? Color(hex: "1C1C1E") : Color(.systemGroupedBackground)
}

public func formCellBackgroundColor(colorScheme: ColorScheme) -> Color {
    return colorScheme == .light ? Color(.secondarySystemGroupedBackground) : Color(hex: "2C2C2E")
}

#endif
