/// Taken from here: https://gist.github.com/peterfriese/8fb3d76bdbe21b84495b79b3a86bf898
/// Related links:
/// https://peterfriese.dev/posts/swiftui-confirmation-dialogs/#confirming-interactive-dismissal
/// https://twitter.com/peterfriese/status/1464534470820868100?s=20&t=8N6tRIMQDm6nyfX9kFn7IA
///
/// **WARNING:** Intricacies of using this:
/// 1. Conditional view insertions/removals with `.transition` do not animate.
///     - Workaround is to manually carry out the transitions using simple `.animation` blockcs
/// 2. A `.edgesIgnoringSafeAreaInset(.bottom)` modifier might be needed
/// 
import SwiftUI

extension View {
    public func interactiveDismissDisabled(_ isDisabled: Bool = true, onAttemptToDismiss: (() -> Void)? = nil) -> some View {
        InteractiveDismissableView(view: self, isDisabled: isDisabled, onAttemptToDismiss: onAttemptToDismiss)
    }
    
    public func interactiveDismissDisabled(_ isDisabled: Bool = true, attemptToDismiss: Binding<Bool>) -> some View {
        InteractiveDismissableView(view: self, isDisabled: isDisabled) {
            attemptToDismiss.wrappedValue.toggle()
        }
    }
    
}

private struct InteractiveDismissableView<T: View>: UIViewControllerRepresentable {
    let view: T
    let isDisabled: Bool
    let onAttemptToDismiss: (() -> Void)?
    
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: view)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {
        context.coordinator.dismissableView = self
        uiViewController.rootView = view
        uiViewController.parent?.presentationController?.delegate = context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var dismissableView: InteractiveDismissableView
        
        init(_ dismissableView: InteractiveDismissableView) {
            self.dismissableView = dismissableView
        }
        
        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            !dismissableView.isDisabled
        }
        
        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            dismissableView.onAttemptToDismiss?()
        }
    }
}
