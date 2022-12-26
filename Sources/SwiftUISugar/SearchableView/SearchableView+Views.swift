import SwiftUI
import Introspect

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
        return isFocused ? 0 : 30
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
                        print("becoming first responder")
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
                .frame(width: UIScreen.main.bounds.width) //TODO: Remove this as `.main` will be deprecated
                .safeAreaInset(edge: .bottom) { safeAreaBottomInset }
                .edgesIgnoringSafeArea(.bottom)
//                .interactiveDismissDisabled(isFocused)
            if !isHidden {
//                GeometryReader { proxy in
                    searchLayer
                        .zIndex(10)
                        .transition(.move(edge: .bottom))
                        .opacity(opacity)
                        .padding(.bottom, bottomPadding)
                        .edgesIgnoringSafeArea(ignoredSafeAreaEdges)
//                        .offset(y: offset)
//                }
            }
        }
        .onAppear(perform: appeared)
        .onChange(of: externalIsFocused.wrappedValue, perform: externalIsFocusedChanged)
        .onChange(of: isFocused, perform: isFocusedChanged)
        .onReceive(keyboardDidShow) { notification in
            withAnimation {
//                hasCompletedFocusedOnAppearAnimation = true
            }
//            print("keyboard did show")
        }
    }
    
    var searchLayer: some View {
        ZStack {
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
            if shouldShowButtonsLayer {
                buttonsLayer
            }
        }
        .onWillResignActive {
            if isFocused {
                withAnimation {
                    isHidingSearchViewsInBackground = true
                }
                resignFocusOfSearchTextField()
            }
        }
        .onDidEnterBackground {
        }
        .onWillEnterForeground {
        }
        .onDidBecomeActive {
            if isHidingSearchViewsInBackground {
                focusOnSearchTextField()
                withAnimation {
                    isHidingSearchViewsInBackground = false
                }
            }
        }
    }

    
    var shouldShowButtonsLayer: Bool {
        didDismiss != nil || showKeyboardDismiss
    }
    
    var buttonsLayer: some View {
        VStack {
            Spacer()
            HStack {
                if let didDismiss {
                    Button {
                        didDismiss()
                    } label: {
                        DismissButtonLabel()
                    }
                }
                Spacer()
                if isFocused, showKeyboardDismiss {
                    Button {
                        resignFocusOfSearchTextField()
                    } label: {
                        DismissButtonLabel(forKeyboard: true)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, isFocused ? 70 : (isExpanded ? 70 : 0))
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
    
    var searchBarContents: some View {
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
        
    var textFieldBackground: some View {
        RoundedRectangle(cornerRadius: isExpanded ? 15 : 20, style: .circular)
            .foregroundColor(isExpanded ? expandedTextFieldColor : collapsedTextFieldColor)
            .frame(height: isExpanded ? 48 : 38)
            .frame(width: isExpanded ? UIScreen.main.bounds.width - 18 : 120)
            .offset(x: isExpanded ? 0 : -shrunkenOffset)
            .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
    }

    var searchBarBackground: some View {
        keyboardColor
            .frame(height: 65)
            .transition(.opacity)
    }
    
    //MARK: Components
    
    var searchIcon: some View {
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
