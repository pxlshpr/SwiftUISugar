import SwiftUI
import SwiftSugar
import SwiftHaptics

/**
 Todo: ** Known Glitch **
 [ ] If the color scheme is changed—the next focus doesn't move the search bar up or down as expected.
 */

public struct SearchableView<Content: View>: View {

    @Binding var searchText: String
    var externalIsFocused: Binding<Bool>
    let buttonViews: [AnyView]
    var content: () -> Content

    //MARK: Internal
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState var isFocused: Bool
    @State var isFocusedForAnimation = false

    @Binding var isHidden: Bool
    let focusOnAppear: Bool
    let promptSuffix: String

    let didSubmit: SearchSubmitHandler?
    
    /// Used to save state when moving to background
    @State var isFocusedForAppState: Bool = false

    /**
     - Parameters:
        - promptSuffix: The suffix for the seach prompt. For instance, for `Search Foods`, this will only be `Foods`.
     */
    public init(
        searchText: Binding<String>,
        promptSuffix: String = "Search",
        focused: Binding<Bool> = .constant(true),
        focusOnAppear: Bool = false,
        isHidden: Binding<Bool> = .constant(false),
        didSubmit: SearchSubmitHandler? = nil,
        @ViewBuilder content: @escaping () -> Content)
    {
        _searchText = searchText
        _isHidden = isHidden
        self.promptSuffix = promptSuffix
        self.externalIsFocused = focused
        self.focusOnAppear = focusOnAppear
        self.didSubmit = didSubmit
        self.buttonViews = []
        self.content = content
    }

    /**
     - Parameters:
        - promptSuffix: The suffix for the seach prompt. For instance, for `Search Foods`, this will only be `Foods`.
        - buttonViews: The views to be placed after the clear button on the trailing side. At least two views need to be provided, so if only providing one—include an `EmptyView()` as well to be able to compile.
     */
    public init<Views>(
        searchText: Binding<String>,
        promptSuffix: String = "Search",
        focused: Binding<Bool> = .constant(true),
        focusOnAppear: Bool = false,
        isHidden: Binding<Bool> = .constant(false),
        didSubmit: SearchSubmitHandler? = nil,
        @ViewBuilder buttonViews: @escaping () -> TupleView<Views>,
        @ViewBuilder content: @escaping () -> Content)
    {
        _searchText = searchText
        _isHidden = isHidden
        self.promptSuffix = promptSuffix
        self.externalIsFocused = focused
        self.focusOnAppear = focusOnAppear
        self.didSubmit = didSubmit
        self.buttonViews = buttonViews().getViews
        self.content = content
    }
}
