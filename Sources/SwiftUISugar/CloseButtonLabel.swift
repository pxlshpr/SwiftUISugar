import SwiftUI

public struct TopButtonLabel: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let fontSize: CGFloat
    let backgroundStyle: BackgroundStyle
    let systemImage: String
    
    public init(
        systemImage: String,
        forUseOutsideOfNavigationBar: Bool = false,
        backgroundStyle: BackgroundStyle = .standard
    ) {
        self.fontSize = forUseOutsideOfNavigationBar ? 30 : 24
        self.backgroundStyle = backgroundStyle
        self.systemImage = systemImage
    }
    
    public var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: fontSize))
            .symbolRenderingMode(.palette)
            .foregroundStyle(foregroundColor, backgroundColor)
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
    
    public enum BackgroundStyle {
        case standard
        case forPlacingOverMaterials
    }
}

public struct CloseButtonLabel: View {
    
    let backgroundStyle: TopButtonLabel.BackgroundStyle
    let forUseOutsideOfNavigationBar: Bool
    
    public init(
        forUseOutsideOfNavigationBar: Bool = false,
        backgroundStyle: TopButtonLabel.BackgroundStyle = .standard
    ) {
        self.forUseOutsideOfNavigationBar = forUseOutsideOfNavigationBar
        self.backgroundStyle = backgroundStyle
    }
    
    public var body: some View {
        TopButtonLabel(
            systemImage: "xmark.circle.fill",
            forUseOutsideOfNavigationBar: forUseOutsideOfNavigationBar,
            backgroundStyle: backgroundStyle
        )
    }
}

public var navigationLinkArrow: some View {
    Image(systemName: "chevron.right")
        .imageScale(.small)
        .fontWeight(.medium)
        .foregroundColor(Color(.tertiaryLabel))
}
