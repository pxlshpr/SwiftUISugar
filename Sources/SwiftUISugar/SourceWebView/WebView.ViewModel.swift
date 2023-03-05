import SwiftUI
import WebKit

extension WebView {
    class Model: NSObject, ObservableObject, WKNavigationDelegate {
        
        @Published var isNavigating = false
        @Published var hasStartedNavigating = false

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            withAnimation {
                isNavigating = false
            }
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            withAnimation {
                hasStartedNavigating = true
                isNavigating = true
            }
        }
    }
}
