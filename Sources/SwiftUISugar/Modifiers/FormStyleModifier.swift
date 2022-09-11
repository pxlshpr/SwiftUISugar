import SwiftUI

public struct FormStyleModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

public extension View {
    func formElementStyle() -> some View {
        self.modifier(FormStyleModifier())
    }
}
