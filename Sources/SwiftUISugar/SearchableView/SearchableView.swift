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
    @Environment(\.dismiss) var dismiss

    @FocusState var isFocused: Bool
    @State var isFocusedForAnimation: Bool

    @State var showingKeyboardDismissButton: Bool
    @Binding var isHidden: Bool
    let focusOnAppear: Bool
    let showKeyboardDismiss: Bool
//    let showDismiss: Bool
//    let didTapDismiss: (() -> ())?
    let didPageBack: (() -> ())?
    let didTapToday: (() -> ())?
    let didPageForward: (() -> ())?

    let promptSuffix: String

    let isInTabView: Bool
    let didSubmit: SearchSubmitHandler?
    
    /// Used to save state when moving to background
    @State var isHidingSearchViewsInBackground: Bool = false
    
    @State var hasAppearedDelayed: Bool = false
    @State var hasAppeared: Bool = false
    @State var hasFocusedOnAppear: Bool
    @State var hasCompletedFocusedOnAppearAnimation: Bool

    @Binding var shouldShowToday: Bool

    let keyboardDidShow = NotificationCenter.default.publisher(for: UIWindow.keyboardDidShowNotification)
    let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    let keyboardDidHide = NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)

//    @State var wasDismissing = false
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
        showKeyboardDismiss: Bool = false,
//        showDismiss: Bool = false,
//        didTapDismiss: (() -> ())? = nil,
        didPageBack: (() -> ())? = nil,
        didTapToday: (() -> ())? = nil,
        shouldShowToday: Binding<Bool> = .constant(false),
        didPageForward: (() -> ())? = nil,
        isInTabView: Bool = false,
        didSubmit: SearchSubmitHandler? = nil,
        @ViewBuilder content: @escaping () -> Content)
    {
        _shouldShowToday = shouldShowToday
        _searchText = searchText
        _isHidden = isHidden
        _isFocusedForAnimation = State(initialValue: focusOnAppear)
        _hasFocusedOnAppear = State(initialValue: !focusOnAppear)
        _hasCompletedFocusedOnAppearAnimation = State(initialValue: !focusOnAppear)
        self.promptSuffix = promptSuffix
        self.externalIsFocused = focused
        self.focusOnAppear = focusOnAppear
        self.showKeyboardDismiss = showKeyboardDismiss
//        self.showDismiss = showDismiss
//        self.didTapDismiss = didTapDismiss
        self.didPageBack = didPageBack
        self.didTapToday = didTapToday
        self.didPageForward = didPageForward
        self.isInTabView = isInTabView
        self.didSubmit = didSubmit
        self.buttonViews = []
        self.content = content
        
        _showingKeyboardDismissButton = State(initialValue: focusOnAppear)
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
        showKeyboardDismiss: Bool = false,
//        showDismiss: Bool = false,
//        didTapDismiss: (() -> ())? = nil,
        didPageBack: (() -> ())? = nil,
        didTapToday: (() -> ())? = nil,
        shouldShowToday: Binding<Bool> = .constant(false),
        didPageForward: (() -> ())? = nil,
        isInTabView: Bool = false,
        didSubmit: SearchSubmitHandler? = nil,
        @ViewBuilder buttonViews: @escaping () -> TupleView<Views>,
        @ViewBuilder content: @escaping () -> Content)
    {
        _shouldShowToday = shouldShowToday
        _searchText = searchText
        _isHidden = isHidden
        _isFocusedForAnimation = State(initialValue: focusOnAppear)
        _hasFocusedOnAppear = State(initialValue: !focusOnAppear)
        _hasCompletedFocusedOnAppearAnimation = State(initialValue: !focusOnAppear)
        self.promptSuffix = promptSuffix
        self.externalIsFocused = focused
        self.focusOnAppear = focusOnAppear
        self.showKeyboardDismiss = showKeyboardDismiss
//        self.showDismiss = showDismiss
//        self.didTapDismiss = didTapDismiss
        self.didPageBack = didPageBack
        self.didTapToday = didTapToday
        self.didPageForward = didPageForward
        self.isInTabView = isInTabView
        self.didSubmit = didSubmit
        self.buttonViews = buttonViews().getViews
        self.content = content
        
        _showingKeyboardDismissButton = State(initialValue: focusOnAppear)
    }
}
