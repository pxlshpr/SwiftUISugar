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
//        if focusOnAppear {
//            focusOnSearchTextField()
//        }
    }
    
    func isFocusedChanged(to newValue: Bool) {
        externalIsFocused.wrappedValue = newValue
        withAnimation {
            isFocusedForAnimation = newValue
        }
    }

    func externalIsFocusedChanged(to newValue: Bool) {
        isFocused = newValue
    }
}
