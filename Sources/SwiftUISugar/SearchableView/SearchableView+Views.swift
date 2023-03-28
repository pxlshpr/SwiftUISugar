import SwiftUI
import Introspect
import SwiftHaptics

extension SearchableView {
    
    public var body: some View {
        contents
//        contents_test
    }
    
    var contents_test: some View {
        VStack {
            Spacer()
            TextField("", text: $searchText)
                .background(.green)
        }
    }
    
    var bottomPadding: CGFloat {
        guard hasCompletedFocusedOnAppearAnimation else { return 0 }
//        return isFocused ? 0 : 30
        if isFocused {
            return 0
        } else {
            if isInTabView {
                return (isExpanded ? 83 : 88) + 5
            } else {
                return 30
            }
        }
    }
    
    var ignoredSafeAreaEdges: Edge.Set {
        guard hasCompletedFocusedOnAppearAnimation else { return [] }
        return isFocused ? [] : .bottom
    }
    
    var opacity: CGFloat {
//        guard hasCompletedFocusedOnAppearAnimation else { return 0 }
        return isHidingSearchViewsInBackground ? 0 : 1
    }
 
    //MARK: TextField
    
    var textField: some View {
        TextField("", text: $searchText)
            .focused($isFocused)
            .font(.system(size: 18))
            .keyboardType(.alphabet)
            .submitLabel(.search)
            .autocorrectionDisabled()
            .onSubmit(tappedSubmit)
            .introspectTextField { uiTextField in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if !hasFocusedOnAppear && focusOnAppear {
                        uiTextField.becomeFirstResponder()
                        hasFocusedOnAppear = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeIn) {
                                hasCompletedFocusedOnAppearAnimation = true
                            }
                        }
                    }
//                }
            }
        
    }
    
    var offset: CGFloat {
        hasCompletedFocusedOnAppearAnimation ? 0 : 70
    }
    
    var contents: some View {
        ZStack {
            content()
                .frame(width: UIScreen.main.bounds.width)
                .safeAreaInset(edge: .bottom) { safeAreaBottomInset }
                .edgesIgnoringSafeArea(.bottom)
            searchLayer
                .zIndex(12)
                .opacity(opacity)
                .padding(.bottom, bottomPadding)
                .edgesIgnoringSafeArea(ignoredSafeAreaEdges)
        }
        .onAppear(perform: appeared)
        .onChange(of: externalIsFocused.wrappedValue, perform: externalIsFocusedChanged)
        .onChange(of: isFocused, perform: isFocusedChanged)
        .onReceive(keyboardDidShow) { notification in
            withAnimation {
//                hasCompletedFocusedOnAppearAnimation = true
            }
//            cprint("keyboard did show")
        }
    }
    
    var searchLayer: some View {
        ZStack {
            if !isHidden {
                VStack {
                    Spacer()
                    searchBar
                        .background(
                            Group {
                                if isFocused || !hasCompletedFocusedOnAppearAnimation {
                                    keyboardColor
                                        .edgesIgnoringSafeArea(.bottom)
                                }
                            }
                        )
                }
                .zIndex(10)
                .transition(.move(edge: .bottom))
            }
//            if shouldShowButtonsLayer {
//                buttonsLayer
//                    .transition(.opacity)
//            }
        }
        //TODO: Removing these temporarily
        .onWillResignActive {
            if isFocused {
//                withAnimation {
//                    isHidingSearchViewsInBackground = true
//                }
//                resignFocusOfSearchTextField()
            }
        }
//        .onDidEnterBackground {
//        }
//        .onWillEnterForeground {
//        }
//        .onDidBecomeActive {
//            if isHidingSearchViewsInBackground {
//                focusOnSearchTextField()
//                withAnimation {
//                    isHidingSearchViewsInBackground = false
//                }
//            }
//        }
    }

    
    var shouldShowButtonsLayer: Bool {
        if focusOnAppear {
            guard hasAppeared else { return false }
        }
        return showKeyboardDismiss
//        return shouldShowDismissButton || showKeyboardDismiss
    }
    
//    var shouldShowDismissButton: Bool {
//        showDismiss || didTapDismiss != nil
//    }
    
    //TODO: Remove this
    var buttonsLayer: some View {
        var bottomPadding: CGFloat {
            guard !isFocused else {
                return 70
            }
            if isExpanded {
                return 70
            } else {
                return 0
//                return isInTabView ? 65 : 0
            }
//            isFocused ? 70 : (isExpanded ? 70 : 0)
        }
        
        return VStack {
            Spacer()
            HStack {
//                if shouldShowDismissButton {
//                    Button {
//                        if let didTapDismiss {
//                            didTapDismiss()
//                        } else {
//                            Haptics.feedback(style: .soft)
//                            dismiss()
//                        }
//                    } label: {
//                        DismissButtonLabel()
//                    }
//                    .transition(.opacity)
//                }
                Spacer()
                if isFocused {
                    if showingKeyboardDismissButton {
                        Button {
                            Haptics.feedback(style: .soft)
                            resignFocusOfSearchTextField()
                        } label: {
                            DismissButtonLabel(forKeyboard: true)
                        }
                        .transition(.scale)
                    }
                } else {
                    if shouldShowPagingButtons {
                        optionalPagingButtons
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, bottomPadding)
            .frame(width: UIScreen.main.bounds.width)
        }
    }
    
    @ViewBuilder
    var keyboardDismissButton: some View {
        if showingKeyboardDismissButton {
            Button {
                Haptics.feedback(style: .soft)
                resignFocusOfSearchTextField()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .foregroundColor(Color(.secondaryLabel))
//                    .padding(6)
            }
//            .transition(.scale.combined(with: .opacity))
            .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }
    
    var optionalPagingButtons: some View {
        HStack {
            if let didPageBack {
                Button {
                    didPageBack()
                } label: {
                    bottomAccessoryButtonLabel("chevron.left")
                }
            }
            
            if let didTapToday {
                Button {
                    didTapToday()
                } label: {
//                    bottomAccessoryButtonLabel("circle.circle.fill")
//                    bottomAccessoryButtonLabel(text: "Today")
                    Text("Today")
                        .textCase(.uppercase)
//                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.secondaryLabel).opacity(shouldShowToday ? 1 : 0.2))
                        .frame(height: 38)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 19, style: .continuous)
                                .foregroundStyle(.ultraThinMaterial)
                                .shadow(color: Color(.black).opacity(0.2), radius: 3, x: 0, y: 3)
                        )

                }
//                .opacity(shouldShowToday ? 1 : 0.5)
                .disabled(!shouldShowToday)
            }
            
            if let didPageForward {
                Button {
                    didPageForward()
                } label: {
                    bottomAccessoryButtonLabel("chevron.right")
                }
            }
        }
    }

    var searchBar: some View {
        ZStack {
            if isExpanded {
                searchBarBackground
            }
            Button {
                tappedSearchBar()
            } label: {
                searchBarContents
            }
            .padding(.horizontal, 7)
            .buttonStyle(SearchableViewButtonStyle())
        }
    }
    
    var expandedTextColor: Color {
        Color(.tertiaryLabel)
    }
    
    var collapsedTextColor: Color {
//        Color(.secondaryLabel)
        Color.white.opacity(0.9)
    }
    
    var expandedAccessoryColor: Color {
        Color(.secondaryLabel)
    }
    
    var collapsedAccessoryColor: Color {
//        Color(.secondaryLabel)
        Color.white.opacity(0.8)
    }
    
    var compactWhenShrunken: Bool {
        didTapToday != nil
    }
    
    var shouldShowPagingButtons: Bool {
        if focusOnAppear {
            guard hasAppearedDelayed else {
                return false
            }
        }
        return didPageBack != nil || didPageForward != nil || didTapToday != nil
    }
    
    var compactAndShrunken: Bool {
        if focusOnAppear {
            guard hasAppearedDelayed else {
                return false
            }
        }
        return compactWhenShrunken && !isFocused && !isExpanded
    }
    
    //MARK: - Experimental
    
    var searchBarContents: some View {
        ZStack {
            HStack {
                textFieldBackground
                if compactAndShrunken {
                    Spacer()
                }
            }
            .padding(.leading, compactAndShrunken ? 56 : 0)
            HStack {
                if !compactAndShrunken {
                    Spacer()
                }
                textFieldContents
                accessoryViews
                keyboardDismissButton
                Spacer()
            }
            .padding(.horizontal, 12)
        }
    }

    var textFieldContents: some View {
        HStack(spacing: 5) {
            searchIcon
            ZStack {
                if isExpanded {
                    HStack {
                        textField
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(isExpanded ? 1 : 0.01)
                        Spacer()
                        clearButton
                    }
                }
                HStack(spacing: 0) {
                    if !compactWhenShrunken {
                        Text("Search")
                            .foregroundColor(.white)
                            .colorMultiply(isExpanded ? expandedTextColor : collapsedTextColor)
                            .opacity(isExpanded ? (searchText.isEmpty ? 1 : 0) : 1)
                            .multilineTextAlignment(.leading)
                    }
                    if isExpanded {
                        Text(" \(promptSuffix)")
                            .foregroundColor(expandedTextColor)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .leading)),
                                removal: .move(edge: .trailing).combined(with: .opacity)))
                            .opacity(searchText.isEmpty ? 1 : 0)
                    }
                }
                .frame(maxWidth: isExpanded ? .infinity : 61, alignment: .leading)
            }
        }
    }
    
    var textFieldBackground: some View {
        var height: CGFloat {
            guard !isExpanded else { return 48 }
            return compactWhenShrunken ? 38 : 38
        }
        
        var width: CGFloat {
            guard !isExpanded else { return UIScreen.main.bounds.width - 18 }
            return compactWhenShrunken ? 38 : 120
        }
        
        var xOffset: CGFloat {
            guard !isExpanded else { return 0 }
            return compactWhenShrunken ? 0 : -shrunkenOffset
        }
        
        /// **Legacy** Stopped using this to hardcode in gradient until we figure out how to transition
        /// from it to a solid color with an animation
        var foregroundColor: Color {
            guard !isExpanded else { return expandedTextFieldColor }
            return compactWhenShrunken ? .clear : collapsedTextFieldColor
        }
        
        var linearGradient: LinearGradient {
            var topColor: Color {
                guard !isExpanded else { return expandedTextFieldColor }
                return compactWhenShrunken ? .clear : Color(hex: "A484FF")
            }
            
            var bottomColor: Color {
                guard !isExpanded else { return expandedTextFieldColor }
                return compactWhenShrunken ? .clear : Color(hex: "8460FF")
            }
            
            return LinearGradient(
                colors: [topColor, bottomColor],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        
        @ViewBuilder
        var background: some View {
            if compactWhenShrunken && !isExpanded {
                Color.clear
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            } else {
                Color.clear
            }
        }
        
        var expandedRect: some View {
            RoundedRectangle(cornerRadius: isExpanded ? 15 : 20, style: .circular)
                .foregroundStyle(linearGradient)
                .background(background)
                .frame(height: height)
                .frame(width: width)
                .offset(x: xOffset)
                .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
                .opacity(isExpanded ? 1 : 0)
        }
        
        var collapsedRect: some View {
            RoundedRectangle(cornerRadius: isExpanded ? 15 : 20, style: .circular)
                .foregroundStyle(foregroundColor.gradient)
                .background(background)
                .frame(height: height)
                .frame(width: width)
                .offset(x: xOffset)
                .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
                .opacity(isExpanded ? 0 : 1)
        }
        
        return ZStack {
            expandedRect
            collapsedRect
        }
    }

    var searchIcon: some View {
        var color: Color {
            guard !isExpanded else { return Color(.secondaryLabel) }
            return compactWhenShrunken ? Color(.secondaryLabel) : .white
        }
        
        var leadingPadding: CGFloat {
            compactAndShrunken ? 52 : 0
//            0
        }
        
        var opacity: CGFloat {
            guard !isExpanded else { return 1.0 }
            return compactWhenShrunken ? 1.0 : 0.5
        }
        
        return Image(systemName: "magnifyingglass")
            .foregroundColor(color)
            .font(.system(size: 18))
            .fontWeight(.semibold)
            .opacity(opacity)
            .padding(.leading, leadingPadding)
    }
    
    //MARK: - Backups
    
    var searchBarContents_backup: some View {
        ZStack {
            textFieldBackground
            HStack {
                Spacer()
                textFieldContents
                accessoryViews
                Spacer()
            }
            .padding(.horizontal, 12)
        }
    }
    
    var textFieldContents_backup: some View {
        HStack(spacing: 5) {
            searchIcon
            ZStack {
                if isExpanded {
                    HStack {
                        textField
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(isExpanded ? 1 : 0.01)
                        Spacer()
                        clearButton
                    }
                }
                HStack(spacing: 0) {
                    Text("Search")
                        .foregroundColor(.white)
                        .colorMultiply(isExpanded ? expandedTextColor : collapsedTextColor)
                        .opacity(isExpanded ? (searchText.isEmpty ? 1 : 0) : 1)
                        .multilineTextAlignment(.leading)
//                        .kerning(0.5)
                    if isExpanded {
                        Text(" \(promptSuffix)")
                            .foregroundColor(expandedTextColor)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .leading)),
                                removal: .move(edge: .trailing).combined(with: .opacity)))
                            .opacity(searchText.isEmpty ? 1 : 0)
                    }
                }
                .frame(maxWidth: isExpanded ? .infinity : 61, alignment: .leading)
            }
        }
    }
    
    var textFieldBackground_backup: some View {
        RoundedRectangle(cornerRadius: isExpanded ? 15 : 20, style: .circular)
            .foregroundColor(isExpanded ? expandedTextFieldColor : collapsedTextFieldColor)
            .frame(height: isExpanded ? 48 : 38)
            .frame(width: isExpanded ? UIScreen.main.bounds.width - 18 : 120)
            .offset(x: isExpanded ? 0 : -shrunkenOffset)
            .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
    }

    var searchIcon_backup: some View {
        var color: Color {
//            Color(.secondaryLabel)
            isExpanded ? Color(.secondaryLabel) : .white
        }
        
        var opacity: CGFloat {
            isExpanded ? 1.0 : 0.5
        }
        
        return Image(systemName: "magnifyingglass")
            .foregroundColor(color)
            .font(.system(size: 18))
            .fontWeight(.semibold)
            .opacity(opacity)
    }

    //MARK: End of Backups
    //MARK: -
    
    var accessoryViews: some View {
        ForEach(buttonViews.indices, id: \.self) { index in
            buttonViews[index]
                .foregroundColor(.white)
                .colorMultiply(isExpanded ? expandedAccessoryColor : collapsedAccessoryColor)
                .padding(6)
                .background(
                    Circle()
                        .foregroundColor(isExpanded ? expandedTextFieldColor : collapsedTextFieldColor)
                        .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
                )
        }
        .offset(x: isExpanded ? 0 : shrunkenOffset)
    }
    
    //MARK: Backgrounds
        
    var searchBarBackground: some View {
        keyboardColor
            .frame(height: 65)
            .transition(.opacity)
    }
    
    //MARK: Components
    
    var clearButton: some View {
        Button {
            tappedClearButton()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(Color(.quaternaryLabel))
        }
        .opacity((!searchText.isEmpty && isFocused) ? 1 : 0)
    }
    
    var safeAreaBottomInset: some View {
        Spacer().frame(height: bottomInset)
    }
}
