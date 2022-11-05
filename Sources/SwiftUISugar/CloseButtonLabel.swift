import SwiftUI

public var closeButtonLabel: some View {
    Image(systemName: "multiply.circle.fill")
        .font(.system(size: 20))
        .symbolRenderingMode(.palette)
        .foregroundStyle(
            Color(.tertiaryLabel),
            Color(.quaternaryLabel)
                .opacity(0.5)
        )
}
