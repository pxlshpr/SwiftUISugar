#if canImport(UIKit)
import SwiftUI
import WebKit
import ActivityIndicatorView

public struct WebView: View {

    @State var urlString: String

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var hasAppeared: Bool = false
    @StateObject var vm = Model()
    
    let title: String?
    
    public init(urlString: String, title: String? = nil) {
        if !(urlString.hasPrefix("http://")  || urlString.hasPrefix("https://")) {
            _urlString = State(initialValue: "http://\(urlString)")
        } else {
            _urlString = State(initialValue: urlString)
        }
        self.title = title
    }
    
    @ViewBuilder
    public var body: some View {
        WebViewRepresentable(url: URL(string: urlString)!, delegate: vm)
            .transition(.opacity)
            .overlay(loadingOverlay)
            .navigationBarTitle(title ?? "Website")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { leadingContents }
            .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    var loadingOverlay: some View {
        if !vm.hasStartedNavigating {
            ActivityIndicatorView(isVisible: .constant(true), type: .scalingDots())
                .foregroundColor(colorScheme == .dark ? Color.gray : Color(.tertiaryLabel))
                .frame(width: 70, height: 70)
                .transition(.opacity)
        }
    }
    func appeared() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                hasAppeared = true
            }
        }
    }

    var leadingContents: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            
            Link(destination: URL(string: urlString)!) {
                Image(systemName: "safari")
            }
            ShareLink(item: URL(string: urlString)!) {
                Image(systemName: "square.and.arrow.up")
            }
            if vm.isNavigating {
                ActivityIndicatorView(isVisible: .constant(true), type: .opacityDots())
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 20)
            }
        }
    }
}
#endif
