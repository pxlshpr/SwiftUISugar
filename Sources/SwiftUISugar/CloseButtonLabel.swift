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

public struct CloseButtonLabel: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let fontSize: CGFloat
    public init(forNavigationBar: Bool = false) {
        self.fontSize = forNavigationBar ? 24 : 30
    }
    
    public var body: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.system(size: fontSize))
            .symbolRenderingMode(.palette)
            .foregroundStyle(
                Color(hex: colorScheme == .light ? "838388" : "A0A0A8"),      /// 'x' symbol
//                Color(hex: colorScheme == .light ? "EEEEEF" : "313135") /// background
                Color(.quaternaryLabel).opacity(0.5)
            )
    }
}

public var navigationLinkArrow: some View {
    Image(systemName: "chevron.right")
        .imageScale(.small)
        .fontWeight(.medium)
        .foregroundColor(Color(.tertiaryLabel))
}
