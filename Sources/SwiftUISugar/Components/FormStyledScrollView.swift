#if canImport(UIKit)
import SwiftUI

public struct FormStyledScrollView<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let customBackgroundColor: Color?
    var content: () -> Content
    
    public init(backgroundColor: Color? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.customBackgroundColor = backgroundColor
        self.content = content
    }
    
    var backgroundColor: Color {
        guard let customBackgroundColor else {
//            return colorScheme == .dark ? Color(hex: "1C1C1E") : Color(hex: "F2F1F6")
            return colorScheme == .dark ? Color(hex: "1C1C1E") : Color(.systemGroupedBackground)
        }
        return customBackgroundColor
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            content()
                .frame(maxWidth: .infinity)
        }
        .background(
            backgroundColor
                .edgesIgnoringSafeArea(.all) /// requireds to cover the area that would be covered by the keyboard during its dismissal animation
        )
    }
}
#endif
