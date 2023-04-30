import SwiftUI

public struct CloseButtonLabel: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let fontSize: CGFloat
    let backgroundStyle: BackgroundStyle
    
    public enum BackgroundStyle {
        case standard
        case forPlacingOverMaterials
    }
    
    public init(
        forUseOutsideOfNavigationBar: Bool = false,
        backgroundStyle: BackgroundStyle = .standard
    ) {
        self.fontSize = forUseOutsideOfNavigationBar ? 30 : 24
        self.backgroundStyle = backgroundStyle
    }
    
    var foregroundColor: Color {
        Color(hex: colorScheme == .light ? "838388" : "A0A0A8")
    }
    
    var backgroundColor: Color {
        switch backgroundStyle {
        case .standard:
            return Color(.quaternaryLabel).opacity(0.5)
//            return Color(hex: colorScheme == .light ? "EEEEEF" : "313135")
        case .forPlacingOverMaterials:
            return colorScheme == .light
            ? Color(hex: "EEEEEF").opacity(0.5)
            : Color(.quaternaryLabel).opacity(0.5)
        }
    }
    
    public var body: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.system(size: fontSize))
            .symbolRenderingMode(.palette)
            .foregroundStyle(foregroundColor, backgroundColor)
    }
    
}

public var navigationLinkArrow: some View {
    Image(systemName: "chevron.right")
        .imageScale(.small)
        .fontWeight(.medium)
        .foregroundColor(Color(.tertiaryLabel))
}
