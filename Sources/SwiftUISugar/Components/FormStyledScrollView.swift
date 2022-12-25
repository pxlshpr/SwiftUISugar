#if canImport(UIKit)
import SwiftUI

public struct FormStyledScrollView<Content: View>: View {
    
    let backgroundColor: Color
    var content: () -> Content
    
    public init(backgroundColor: Color = Color(.systemGroupedBackground), @ViewBuilder content: @escaping () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content
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
