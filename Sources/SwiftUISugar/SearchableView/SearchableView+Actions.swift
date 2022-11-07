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
        withAnimation {
            isFocusedForAnimation = true
        }
        isFocused = true
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
        withAnimation {
            showingSearchLayer = false
        }
        isFocused = false
    }
    
    func focusOnSearchTextField() {
        withAnimation {
            showingSearchLayer = true
        }
        isFocused = true
    }

    //MARK: - Events
    
    func appeared() {
        if focusOnAppear {
            focusOnSearchTextField()
        }
    }
    
    func isFocusedChanged(to newValue: Bool) {
        externalIsFocused.wrappedValue = newValue
        if blurWhileSearching && !showingSearchLayer && newValue {
            withAnimation {
                showingSearchLayer = true
            }
        }
        withAnimation {
            isFocusedForAnimation = newValue
        }
    }

    func externalIsFocusedChanged(to newValue: Bool) {
        isFocused = newValue
    }
}
