import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
 
    var url: URL
    var delegate: WKNavigationDelegate?
        var scrollViewDelegate: UIScrollViewDelegate?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = delegate
        webView.scrollView.delegate = scrollViewDelegate
        return webView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
