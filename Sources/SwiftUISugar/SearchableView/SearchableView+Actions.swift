import SwiftUI
import SwiftHaptics

extension SearchableView {
    
    //MARK: - Button Taps
    
    func tappedClearButton() {
        Haptics.feedback(style: .soft)
        searchText = ""
    }
    func tappedSearchBar() {
        Haptics.feedback(style: .soft)
        focusOnSearchTextField()
    }
    
    func tappedSubmit() {
        if let didSubmit {
            Haptics.feedback(style: .soft)
            didSubmit()
        }
        resignFocusOfSearchTextField()
    }

    //MARK: - TextField Focus
    
    func resignFocusOfSearchTextField() {
        isFocused = false
    }
    
    func focusOnSearchTextField() {
        /// This is crucial to be run before setting `isFocused`, as the `TextField` wouldn't be in the view hierarchy while shrunken
        withAnimation {
            isFocusedForAnimation = true
        }
        isFocused = true
    }

    //MARK: - Events
    
    func appeared() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                hasAppeared = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            hasAppearedDelayed = true
        }
    }
    
    func isFocusedChanged(to newValue: Bool) {
        externalIsFocused.wrappedValue = newValue
        withAnimation {
            isFocusedForAnimation = newValue
            /// Animate when focusing only
            if newValue {
                showingKeyboardDismissButton = newValue
            }
        }
        /// No animation when resigning focus
        if !newValue {
            showingKeyboardDismissButton = newValue
        }
    }

    func externalIsFocusedChanged(to newValue: Bool) {
        isFocused = newValue
    }
}
