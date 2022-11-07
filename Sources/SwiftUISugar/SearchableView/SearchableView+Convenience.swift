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

    //MARK: Insets
    
    var bottomInset: CGFloat {
        if isFocused {
            return 370
        } else {
            return searchText.isEmpty ? 0 : 100
        }
    }
    
    var safeAreaBottomInset: some View {
        Spacer().frame(height: bottomInset)
    }
}
