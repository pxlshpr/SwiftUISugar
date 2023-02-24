import SwiftUI

///Taken from: https://danielsaidi.com/blog/2022/06/21/undimmed-presentation-detents-in-swiftui

public extension View {

    func presentationDetents(
        undimmed detents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil
    ) -> some View {
        self.background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
            .presentationDetents(detents.swiftUISet)
    }

    func presentationDetents(
        undimmed detents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil,
        selection: Binding<PresentationDetent>
    ) -> some View {
        self.background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
            .presentationDetents(
                Set(detents.swiftUISet),
                selection: selection
            )
    }
}

private struct UndimmedDetentView: UIViewControllerRepresentable {

    var largestUndimmed: UndimmedPresentationDetent?

    func makeUIViewController(context: Context) -> UIViewController {
        let result = UndimmedDetentController()
        result.largestUndimmed = largestUndimmed
        return result
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

private class UndimmedDetentController: UIViewController {

    var largestUndimmed: UndimmedPresentationDetent?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        avoidDimmingParent()
        avoidDisablingControls()
    }

    func avoidDimmingParent() {
        let id = largestUndimmed?.uiKitIdentifier
        sheetPresentationController?.largestUndimmedDetentIdentifier = id
    }

    func avoidDisablingControls() {
        presentingViewController?.view.tintAdjustmentMode = .normal
    }
}

extension Collection where Element == UndimmedPresentationDetent {

    var swiftUISet: Set<PresentationDetent> {
        Set(map { $0.swiftUIDetent })
    }
}

extension UISheetPresentationController.Detent.Identifier {

    static func fraction(_ value: CGFloat) -> Self {
        .init("Fraction:\(String(format: "%.1f", value))")
    }

    static func height(_ value: CGFloat) -> Self {
        .init("Height:\(value)")
    }
}

public enum UndimmedPresentationDetent {

    case large
    case medium

    case fraction(_ value: CGFloat)
    case height(_ value: CGFloat)

    var swiftUIDetent: PresentationDetent {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value): return .fraction(value)
        case .height(let value): return .height(value)
        }
    }

    var uiKitIdentifier: UISheetPresentationController.Detent.Identifier {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case .fraction(let value): return .fraction(value)
        case .height(let value): return .height(value)
        }
    }
}
