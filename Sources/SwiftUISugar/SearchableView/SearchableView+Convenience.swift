import SwiftUI

extension SearchableView {
    
    var shouldShowSearchBarBackground: Bool {
        !searchText.isEmpty || isFocusedForAnimation
    }
    
    var isExpanded: Bool {
        isFocusedForAnimation || !searchText.isEmpty
    }
    
    var blurRadius: CGFloat {
        guard blurWhileSearching else { return 0 }
        return showingSearchLayer ? 10 : 0
    }
    
    //MARK: Colors
    
    var shadowColor: Color {
        guard !isExpanded else { return .clear }
        return Color(.black).opacity(colorScheme == .light ? 0.2 : 0.2)
    }

    var textFieldColor: Color {
        colorScheme == .light ? Color(hex: colorHexSearchTextFieldLight) : Color(hex: colorHexSearchTextFieldDark)
    }

    @ViewBuilder
    var keyboardColor: some View {
        if !isFocused {
            Color.clear
                .background(.ultraThinMaterial)
        } else {
            colorScheme == .light ? Color(hex: colorHexKeyboardLight) : Color(hex: colorHexKeyboardDark)
        }
    }

    //MARK: Calculated Values
    
    /**
     Note: **We're currently returning a hardcoded offset assuming that they'll be only 1 button (of a size applicable to 20 pixels).**
     
     This needs to be rewritten to:
     [ ] Account for having multiple views in `buttonViews`
     [ ] Account for their actual sizes.
     */
    var shrunkenOffset: CGFloat {
        if buttonViews.count > 0 {
            return 20
        } else {
            return 0
        }
    }
    
    var bottomInset: CGFloat {
        if isFocused {
            return 370
        } else {
            return searchText.isEmpty ? 0 : 100
        }
    }    
}
