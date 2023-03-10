import SwiftUI
import SwiftHaptics

public struct ToastStyle {
    
    let imageTopColor: Color
    let imageBottomColor: Color
    let titleTopColor: Color
    let titleBottomColor: Color
    let messageColor: Color
    let backgroundColor: Color?
    let pulsesImage: Bool

    public init(
        imageTopColor: Color,
        imageBottomColor: Color,
        pulsesImage: Bool = true,
        titleTopColor: Color,
        titleBottomColor: Color,
        messageColor: Color = .primary,
        backgroundColor: Color? = nil
    ) {
        self.imageTopColor = imageTopColor
        self.imageBottomColor = imageBottomColor
        self.pulsesImage = pulsesImage
        self.titleTopColor = titleTopColor
        self.titleBottomColor = titleBottomColor
        self.messageColor = messageColor
        self.backgroundColor = backgroundColor
    }
    
    public init(
        imageColor: Color = .primary,
        pulsesImage: Bool = true,
        titleColor: Color = .primary,
        messageColor: Color = .primary,
        backgroundColor: Color? = nil
    ) {
        self.init(
            imageTopColor: imageColor,
            imageBottomColor: imageColor,
            pulsesImage: pulsesImage,
            titleTopColor: titleColor,
            titleBottomColor: titleColor,
            messageColor: messageColor,
            backgroundColor: backgroundColor
        )
    }

    public init(
        foregroundColor: Color = .primary,
        backgroundColor: Color? = nil,
        pulsesImage: Bool = true
    ) {
        self.init(
            imageColor: foregroundColor,
            pulsesImage: pulsesImage,
            titleColor: foregroundColor,
            messageColor: foregroundColor,
            backgroundColor: backgroundColor
        )
    }

    static public var plain: ToastStyle {
        ToastStyle()
    }
    
    static public var accented: ToastStyle {
        ToastStyle(foregroundColor: .white, backgroundColor: .accentColor)
    }
}

public struct ToastInfo {
    
    let title: String
    let message: String?
    let style: ToastStyle
    let systemImage: String?
    
    public init(
        title: String,
        message: String? = nil,
        style: ToastStyle = .plain,
        systemImage: String? = nil
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.systemImage = systemImage
    }
}

struct Toast: View {
    
    enum ScaleState {
        case small, normal, large

        var scale: CGFloat {
            switch self {
            case .small: return 0.75
            case .normal: return 1.0
            case .large: return 1.5
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isPulsing = false
    @State private var scaleState: ScaleState = .normal
    @State private var pulseLength: TimeInterval = 0.7
    @State private var pulseDelay: TimeInterval = 0.15
    
    let info: ToastInfo
    
    init(_ info: ToastInfo) {
        self.info = info
    }
    
    var body: some View {
        GeometryReader { geometry in
            content
                .frame(maxWidth: geometry.size.width)
                .padding(.horizontal, 25)
        }
    }
    
    var content: some View {
        var imageForeground: some ShapeStyle {
            LinearGradient(
                colors: [info.style.imageTopColor, info.style.imageBottomColor],
                startPoint: .top, endPoint: .bottom
            )
        }

        var titleForeground: some ShapeStyle {
            LinearGradient(
                colors: [info.style.titleTopColor, info.style.titleBottomColor],
                startPoint: .top, endPoint: .bottom
            )
        }

        var background: some View {
            var shape: some Shape {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
            }
            
            return Group {
                if let backgroundColor = info.style.backgroundColor {
                    shape
                        .fill(backgroundColor)
                } else {
                    shape
                        .fill(.bar)
                }
            }
        }
        
        return HStack(spacing: 15) {
            if let systemImage = info.systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(imageForeground)
                    .imageScale(.large)
                    .scaleEffect(scaleState.scale)
            }
            VStack(alignment: .leading) {
                Text(info.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(titleForeground)
                if let message = info.message {
                    Text(message)
                        .fontWeight(.regular)
                        .foregroundColor(info.style.messageColor)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            background
//                .shadow(color: .black.opacity(colorScheme == .dark ? 0.25 : 0.2), radius: 3, y: 3)
                .shadow(radius: 5, y: 3)
        )
        .onAppear {
            if info.style.pulsesImage {
                startAnimation()
            }
        }
    }
    
    func startAnimation() {
            isPulsing = true
            withAnimation(Animation.linear(duration: pulseLength * 0.25)) {
                scaleState = .large
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (pulseLength * 0.25)) {
                withAnimation(Animation.linear(duration: pulseLength * 0.5)) {
                    scaleState = .small
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (pulseLength * 0.75)) {
                withAnimation(Animation.linear(duration: pulseLength * 0.25)) {
                    scaleState = .normal
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + pulseLength + pulseDelay) {
                withAnimation {
                    if isPulsing {
                        startAnimation()
                    }
                }
            }
        }

        func stopAnimation() {
            isPulsing = false
        }
}

public struct ToastLayer: View {
    
    @State var toastInfo: ToastInfo? = nil
    @State var height: CGFloat = .zero
    @State var isShowing: Bool = false
    
    let showToast = NotificationCenter.default.publisher(for: .showToast)
    
    public init() {
    }
    
    public var body: some View {
        content
            .onReceive(showToast, perform: showToast)
            .zIndex(10)
    }
    
    var content: some View {
        VStack {
            toast
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    var toast: some View {
        if let toastInfo {
            Toast(toastInfo)
                .readSize(onChange: { size in
                    self.height = size.height
                })
                .offset(y: offset)
                .onTapGesture { tappedToast() }
        }
    }
    
    func showToast(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let toastInfo = userInfo[Notification.ToastKeys.toastInfo] as? ToastInfo
        else { return }
        
        self.toastInfo = toastInfo
        withAnimation(.interactiveSpring()) {
            isShowing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            hideToast()
        }
    }
    
    func hideToast() {
        withAnimation {
            isShowing = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            toastInfo = nil
        }
    }

    func tappedToast() {
        Haptics.feedback(style: .soft)
        hideToast()
    }
    
    var offset: CGFloat {
        isShowing ? 60 : -height
    }
    
    public static func showToast(_ toastInfo: ToastInfo) {
        NotificationCenter.default.post(
            name: .showToast,
            object: nil,
            userInfo: [
                Notification.ToastKeys.toastInfo: toastInfo
            ]
        )
    }
}


public extension Notification.Name {
    static var showToast: Notification.Name { return .init("SwiftUISugar.showToast") }
}

extension Notification {
    public struct ToastKeys {
        public static let toastInfo = "toastInfo"
    }
}
