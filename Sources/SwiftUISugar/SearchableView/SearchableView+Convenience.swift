import SwiftUI

extension SearchableView {
    
    var shouldShowSearchBarBackground: Bool {
        !searchText.isEmpty || isFocusedForAnimation
    }
    
    var isExpanded: Bool {
        isFocusedForAnimation || !searchText.isEmpty
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
     Horizontal offset to move elements by so that they align properly.
     
     Note: **Hardcoded Values** We're currently returning a hardcoded value assuming that they'll be only 1 button (of a size applicable to 20 pixels).
     
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
    
    /**
     Bottom inset to be applied the content.
      
     Note: **Harcoded Values** We're currently returning values specific to the iPhone 13 Pro Max, at least for the `OffsetWhileFocused` which takes the keyboard size into account.
     
     Note: We're currently returning `0.0` as the offset while shrunken (and not focused)—so that the scrollview indicator insets for the content go all the way to the bottom. This however has the
     unwanted effect of the actual content not being inset for the safe area at the bottom (as we ignore the bottom safe area inset so that the animation of the background elements during the
     dismissal of the keyboard goes smoothly). We're assuming that when shrunken (implying that no search text is present), the content is in such a state that this wouldn't matter too much.
     However, **this means that the user would need to manually apply a bottom offset to the content** in this specific state **(while the search field isn't focused, and the search text is empty)**,
     if they would like to alleviate this.
     
     [ ] Remove the hardcoded value we've got for `OffsetWhileFocused` which takes into account the keyboard height, or at least hardcode this for all possible devices.
     [ ] Find a way to specify a bottom inset for the content of the scrollView (assuming the user is using this on a scrollView), while maintaining the scroll indicators without an inset. Perhaps place a spacer at the bottom of the content (which is essentially what we want).
     */
    var bottomInset: CGFloat {
        
        let OffsetWhileFocused = 366.0
        let OffsetWhileShrunken = 0.0
        let OffsetWhileExpandedAndNotFocused = 100.0
        
        if isFocused {
            return OffsetWhileFocused
        } else {
            return searchText.isEmpty ? OffsetWhileShrunken : OffsetWhileExpandedAndNotFocused
        }
    }    
}
