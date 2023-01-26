import SwiftUI

/// Taken from https://www.youtube.com/watch?v=5VPEcZy0FaQ
public extension View {
    /// Forces a Popover to be presented—even on iPhone
    func forcedPopover<Content: View>(isPresented: Binding<Bool>, arrowDirection: UIPopoverArrowDirection, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.background {
            PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
        }
    }
}

struct PopOverController<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    /// View Properties
    @State private var alreadyPresented: Bool = false
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if alreadyPresented {
            /// Updating SwiftUI View, when it's changed
            if let hostingController = uiViewController.presentedViewController  as? CustomHostingView<Content> {
                hostingController.rootView = content
                /// Updating view size when it's updated
                /// or you can define your own size in the SwiftUI View
                hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
            }
            
            /// Close View, if it's toggled Back
            if !isPresented {
                /// Closing Popover
                uiViewController.dismiss(animated: true) {
                    /// Resetting alreadyPresented State
                    alreadyPresented = false
                }
            }
        } else {
            if isPresented {
                /// Presenting PopOver
                let controller = CustomHostingView(rootView: content)
                controller.view.backgroundColor = .clear
                controller.modalPresentationStyle = .popover
                controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
                /// Connecting Delegate
                controller.presentationController?.delegate = context.coordinator
                /// We need to attach the source view so that it will show arrow at correct position
                controller.popoverPresentationController?.sourceView = uiViewController.view
                /// Simply presenting PopOver Controller
                uiViewController.present(controller, animated: true)
            }
        }
    }
    
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        var parent: PopOverController
        
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
        
        func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.alreadyPresented = true
            }
        }
    }
}

/// Custom Hosting Controller for wrapping to its SwiftUI View Size
class CustomHostingView<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.intrinsicContentSize
    }
}
