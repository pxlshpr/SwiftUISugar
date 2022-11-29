import SwiftUI

public var closeButtonLabel: some View {
    Image(systemName: "xmark.circle.fill")
        .font(.system(size: 20))
        .symbolRenderingMode(.palette)
        .foregroundStyle(
            Color(.tertiaryLabel),
            Color(.quaternaryLabel)
                .opacity(0.5)
        )
}

public var navigationLinkArrow: some View {
    Image(systemName: "chevron.right")
        .imageScale(.small)
        .fontWeight(.medium)
        .foregroundColor(Color(.tertiaryLabel))
}
