#if canImport(UIKit)
import SwiftUI

public struct FormInlineDoneButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    let disabled: Bool
    let onTap: () -> ()
    
    public init(disabled: Bool, onTap: @escaping () -> Void) {
        self.disabled = disabled
        self.onTap = onTap
    }
    
    public var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "checkmark")
                .bold()
                .foregroundColor(foregroundColor)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 19)
                        .foregroundStyle(Color.accentColor.gradient)
                        .shadow(color: Color(.black).opacity(0.2), radius: 2, x: 0, y: 2)
                )
        }
        .disabled(disabled)
        .opacity(disabled ? 0.2 : 1)
    }

    var foregroundColor: Color {
        (colorScheme == .light && disabled)
        ? .black
        : .white
    }
}
#endif
