import SwiftUI

internal struct HUDViewModifier<N: View>: ViewModifier {
    @ObservedObject var hudManager: HUDManager
    let animation: Animation
    var content: (HUDInfo) -> N
    
    var info: HUDInfo? {
        hudManager.info
    }
    
    func body(content: Content)-> some View {
        ZStack {
            content
//            if let info {
//                hudLayer(info)
//            }
            hudLayer
        }
//        .edgesIgnoringSafeArea(.all)
        .animation(animation, value: info)
    }
    
    func hudLayer(_ info: HUDInfo) -> some View {
        
        @ViewBuilder var topSpacer: some View {
            if info.displayEdge == .bottom {
                Spacer()
            }
        }
        
        @ViewBuilder var bottomSpacer: some View {
            if info.displayEdge == .top {
                Spacer()
            }
        }
        
        func handleTap() {
            if info.dismissOnTap {
                /// remove the current notfication
                self.hudManager.remove(notification: info)
            }
            info.tapHandler?()
        }
        
        var transition: AnyTransition {
            AnyTransition.move(edge: info.displayEdge)
        }
        
        @ViewBuilder var hudView: some View {
            content(info)
                .onTapGesture { handleTap() }
                .id(info.id)
                .transition(AnyTransition.move(edge: info.displayEdge))
        }
        
        func topPadding(_ proxy: GeometryProxy) -> CGFloat {
            info.ignoresSafeArea ? -proxy.safeAreaInsets.top : 0
        }
        
        func bottomPadding(_ proxy: GeometryProxy) -> CGFloat {
            info.ignoresSafeArea ? proxy.safeAreaInsets.bottom : 0
        }
        
        var vstack: some View {
            VStack {
                topSpacer
                hudView
                bottomSpacer
            }
        }
        
        var geometryReader: some View {
            GeometryReader { proxy in
                vstack
                .padding(.top, topPadding(proxy))
                .padding(.bottom, bottomPadding(proxy))
            }
            .frame(maxWidth: .infinity)
        }
        
//        return geometryReader
        return vstack
    }
    
    var hudLayer: some View {
        
        @ViewBuilder var topSpacer: some View {
            if let info, info.displayEdge == .bottom {
                Spacer()
            }
        }
        
        @ViewBuilder var bottomSpacer: some View {
            if let info, info.displayEdge == .top {
                Spacer()
            }
        }
        
        func handleTap() {
            guard let info else { return }
            if info.dismissOnTap {
                /// remove the current notfication
                self.hudManager.remove(notification: info)
            }
            info.tapHandler?()
        }
                
        @ViewBuilder var hudView: some View {
            if let info {
                content(info)
                    .onTapGesture { handleTap() }
                    .id(info.id)
                    .transition(AnyTransition.move(edge: info.displayEdge))
            }
        }
        
        func topPadding(_ proxy: GeometryProxy) -> CGFloat {
            if let info, info.ignoresSafeArea {
                return -proxy.safeAreaInsets.top
            } else {
                return 0
            }
        }
        
        func bottomPadding(_ proxy: GeometryProxy) -> CGFloat {
            if let info, info.ignoresSafeArea {
                return -proxy.safeAreaInsets.bottom
            } else {
                return 0
            }
        }
        
        var vstack: some View {
            VStack {
                topSpacer
                hudView
                bottomSpacer
            }
        }
        
        var geometryReader: some View {
            GeometryReader { proxy in
                vstack
                .padding(.top, topPadding(proxy))
                .padding(.bottom, bottomPadding(proxy))
            }
            .frame(maxWidth: .infinity)
        }
        
        return geometryReader
//        return vstack
    }
}

public extension View {
    
    /// notificationView modifier function
    /// - Parameters:
    ///   - handler: a DYNotificationHandler object
    ///   - animation: appear animation of the notfification banner
    ///   - notificationView: notificationView closue - return a DYNotificationView or a custom view.
    /// - Returns: some View
    func hudView<N: View>(
        manager: HUDManager,
        animation: Animation = .easeInOut(duration: 0.5),
        content: @escaping (HUDInfo) -> N
    ) -> some View {
        self.modifier(HUDViewModifier(
            hudManager: manager,
            animation: animation,
            content: content
        ))
    }
    
}
