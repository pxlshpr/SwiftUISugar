#if canImport(UIKit)
import SwiftUI
import WebKit
import ActivityIndicatorView

public struct WebView: View {

    @State var urlString: String

    @Environment(\.dismiss) var dismiss
    @State var hasAppeared: Bool = false
    @StateObject var vm = ViewModel()
    
    let title: String?
    
    public init(urlString: String, title: String? = nil) {
        _urlString = State(initialValue: urlString)
        self.title = title
    }
    
    @ViewBuilder
    public var body: some View {
        WebViewRepresentable(url: URL(string: urlString)!, delegate: vm)
            .transition(.opacity)
            .overlay(loadingOverlay)
            .navigationBarTitle(title ?? "Website")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { navigationTrailingContent }
            .toolbar { navigationLeadingContent }
            .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    var loadingOverlay: some View {
        if !vm.hasStartedNavigating {
            ActivityIndicatorView(isVisible: .constant(true), type: .scalingDots())
                    .foregroundColor(Color(.tertiaryLabel))
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

    var navigationLeadingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            if vm.isNavigating {
                ActivityIndicatorView(isVisible: .constant(true), type: .opacityDots())
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 20)
//                ProgressView()
//                    .transition(.opacity)
            }
        }
    }
    
    var navigationTrailingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            
            Link(destination: URL(string: urlString)!) {
                Image(systemName: "safari")
            }
            ShareLink(item: URL(string: urlString)!) {
                Image(systemName: "square.and.arrow.up")
//                Label("Learn Swift here", systemImage: "swift")
            }
//            Menu {
//                Button("Copy URL") {
//                    UIPasteboard.general.string = urlString
//                }
//            } label: {
//                Image(systemName: "square.and.arrow.up")
//            }
        }
    }
}
#endif
