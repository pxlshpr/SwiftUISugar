import Foundation
import SwiftUI
import MarqueeText

struct HUDView: View {
    @EnvironmentObject var hudManager: HUDManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Color.clear
//            .ignoresSafeArea(.all)
            .hudView(manager: hudManager) { notification in
                banner(for: notification)
            }
            .statusBarHidden(shouldHideStatusBar)
    }
    
    var shouldHideStatusBar: Bool {
        hudManager.info?.displayEdge == .top
    }
    
    func banner(for info: HUDInfo) -> some View {
        StandardHUDView(info)
    }
    
    func cornerRadius(displayEdge: Edge)-> CGFloat {
        guard displayEdge != .leading && displayEdge != .trailing else {
            return UIDevice.current.userInterfaceIdiom == .phone ? 5 : 10
        }
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return 10
        }
        return UIScreen.main.bounds.width <  UIScreen.main.bounds.height ? 0 : 10
    }
}

struct StandardHUDView: View {
    
    let info: HUDInfo
    
    init(_ info: HUDInfo) {
        self.info = info
    }

    var body: some View {
        content
//            .fixedSize(horizontal: false, vertical: true)
    }
    
    var content: some View {
//        GeometryReader { proxy in
//            VStack {
//                Spacer()
                label
                    .frame(minWidth: 100)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        ZStack {
                            Capsule(style: .continuous)
                                .fill(.regularMaterial)
                                .shadow(color: Color(.black).opacity(0.16), radius: 12, x: 0, y: 5)
                        }
                    )
                    .padding(.horizontal, 40)
//            }
//        }
    }
    
    @ViewBuilder
    var title: some View {
        if let title = info.title {
            VStack {
                Text(title)
                    .font(.system(.headline))
                Spacer()
            }
        }
    }
    
    var imageAndMessage: some View {
        
        @ViewBuilder
        var image: some View {
            if let systemImage = info.systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(Color(.secondaryLabel))
                    .imageScale(.large)
            }
        }
        
        /// Used for spacing (in order to center the real title horizontally across the entire view)
        @ViewBuilder
        var transparentTitle: some View {
            if let title = info.title {
                Text(title)
                    .font(.system(.headline))
                    .opacity(0)
            }
        }
        
        var message: some View {
            MarqueeText(
                text: info.message,
                font: UIFont.preferredFont(forTextStyle: .subheadline),
                leftFade: 16,
                rightFade: 16,
                startDelay: 1.5
            )
            .foregroundColor(.primary.opacity(0.55))
            .bold()
        }
        
        return HStack(spacing: 20) {
            image
            VStack(spacing: 0) {
                transparentTitle
                message
            }
        }
    }
    
    var label: some View {
        ZStack {
            title
            imageAndMessage
        }
        .foregroundColor(.primary)
    }
}
