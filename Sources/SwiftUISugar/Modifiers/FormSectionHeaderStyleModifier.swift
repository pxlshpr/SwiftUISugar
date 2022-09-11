import SwiftUI

public struct FormSectionHeaderStyleModifier: ViewModifier {
    public func body(content: Content) -> some View {
        HStack {
            content
                .textCase(.uppercase)
                .font(.footnote)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.leading, 20)
        .padding(.top, 10)
    }
}

public extension View {
    func formSectionHeaderStyle() -> some View {
        self.modifier(FormSectionHeaderStyleModifier())
    }
}

