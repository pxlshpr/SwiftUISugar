#if canImport(UIKit)
import SwiftUI

public struct FormTextFieldClearButton: View {
    
    let isEmpty: Bool
    let onTap: () -> ()

    public init(isEmpty: Bool, onTap: @escaping () -> Void) {
        self.isEmpty = isEmpty
        self.onTap = onTap
    }
    
    public var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20))
                .symbolRenderingMode(.palette)
                .foregroundStyle(
                    Color(.tertiaryLabel),
                    Color(.tertiarySystemFill)
                )
        }
        .opacity(!isEmpty ? 1 : 0)
        .buttonStyle(.borderless)
        .padding(.trailing, 5)
    }
}
#endif
