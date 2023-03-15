import SwiftUI

public struct TapTargetResetLayer: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var wasInBackground: Bool = false
    @State var focusWhenVisible = false
    @State var isPresentingSheet: Bool = false
    @FocusState var isFocused: Bool
    
    let sheetWasDismissed = NotificationCenter.default.publisher(for: .tapTargetResetSheetWasDismissed)
    let sheetWasPresented = NotificationCenter.default.publisher(for: .tapTargetResetSheetWasPresented)
    
    public init() { }
    
    public var body: some View {
        textField
            .onChange(of: scenePhase, perform: scenePhaseChanged)
            .onReceive(sheetWasDismissed, perform: sheetWasDismissed)
            .onReceive(sheetWasPresented, perform: sheetWasPresented)
    }
    
    var textField: some View {
        TextField("", text: .constant(""))
            .focused($isFocused)
            .opacity(0)
    }
    
    func scenePhaseChanged(to newPhase: ScenePhase) {
        switch newPhase {
        case .background:
            wasInBackground = true
        case .active:
            /// If we came from the background and are currently presenting a sheet
            if wasInBackground, isPresentingSheet {
                /// Set this so that the `TextField` gets focused (and immediately dismissed) once the sheet is dismissed
                focusWhenVisible = true
                wasInBackground = false /// reset for next use
            }
        default:
            break
        }
    }
    
    func sheetWasPresented(_ notification: Notification) {
        isPresentingSheet = true
    }
    
    func sheetWasDismissed(_ notification: Notification) {
        
        isPresentingSheet = false /// reset for next use
        
        /// Only continue if we this is called after returning from background
        /// (in which case `focusWhenVisible` would have been set)
        guard focusWhenVisible else { return }
        
        focusWhenVisible = false /// reset for next use

        /// This sequence of events first waits `0.2s` and then focuses the `TextField`
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFocused = true
            
            /// We then queue up `isFocused = false` calls multiple times (every `0.01s` for the next `2s`)
            /// to ensure that:
            /// - The keyboard gets dismissed as soon as possible.
            /// - The keyboard **definitely** does get dismissed (it's not guaranteed which call actually dismisses it,
            /// so I've found that making these multiple calls in quick succession is critical to ensure its dismissal).
            ///
            /// *Note: There are rare instances where you see a quick glimpse of the keyboard being dismissed, but
            /// because:
            /// a) this bug is not a common occurrence for the user to begin with, and
            /// b) the chance of the keyboard dismissal actually being viewed is even less likely,
            /// I've decided its a much more worthy tradeoff than essentially having a broken UI until the view is implicitly
            /// refreshed by some other implicit means.*
            let delays = stride(from: 0.0, through: 2.0, by: 0.01)
            for delay in delays {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    isFocused = false
                }
            }
        }
    }
}

extension TapTargetResetLayer {
    
    public static func presentedSheetChanged(toDismissed: Bool) {
        NotificationCenter.default.post(
            name: toDismissed
            ? .tapTargetResetSheetWasDismissed
            : .tapTargetResetSheetWasPresented,
            object: nil
        )
    }
}

public extension Notification.Name {
    static var tapTargetResetSheetWasDismissed: Notification.Name { return .init("tapTargetResetSheetWasDismissed") }
    static var tapTargetResetSheetWasPresented: Notification.Name { return .init("tapTargetResetSheetWasPresented") }
}
