import SwiftUI

extension SearchableView {
    
    public var body: some View {
        ZStack {
            content()
                .blur(radius: blurRadius)
                .frame(width: UIScreen.main.bounds.width)
                .safeAreaInset(edge: .bottom) { safeAreaBottomInset }
                .edgesIgnoringSafeArea(.bottom)
                .interactiveDismissDisabled(isFocused)
            if !isHidden {
                searchLayer
                    .zIndex(10)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear(perform: appeared)
        .onChange(of: externalIsFocused.wrappedValue, perform: externalIsFocusedChanged)
        .onChange(of: isFocused, perform: isFocusedChanged)
    }
    
    var searchLayer: some View {
        ZStack {
            VStack {
                Spacer()
                searchBar
                    .background(
                        Group {
                            if isFocused {
                                keyboardColor
                                    .edgesIgnoringSafeArea(.bottom)
                            }
                        }
                    )
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
    
    var searchBarContents: some View {
        ZStack {
            textFieldBackground
            HStack {
                textFieldContents
                accessoryViews
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
                    Text("Search")
                        .foregroundColor(Color(.label))
                        .colorMultiply(isExpanded ? Color(.tertiaryLabel) : Color(.secondaryLabel))
                        .opacity(isExpanded ? (searchText.isEmpty ? 1 : 0) : 1)
                        .multilineTextAlignment(.leading)
                        .kerning(0.5)
                    if isExpanded {
                        Text(" \(promptSuffix)")
                            .foregroundColor(Color(.tertiaryLabel))
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
                .foregroundColor(Color(.label))
                .colorMultiply(isExpanded ? Color(.secondaryLabel) : Color(.secondaryLabel))
                .padding(6)
                .background(
                    Circle()
                        .foregroundColor(isExpanded ? textFieldColor : Color(.tertiarySystemGroupedBackground))
                        .shadow(color: shadowColor, radius: 3, x: 0, y: 3)
                )
        }
        .offset(x: isExpanded ? 0 : shrunkenOffset)
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
    }
    
    //MARK: Backgrounds
        
    var textFieldBackground: some View {
        RoundedRectangle(cornerRadius: isExpanded ? 15 : 20, style: .circular)
            .foregroundColor(isExpanded ? textFieldColor : Color(.tertiarySystemGroupedBackground))
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
        Image(systemName: "magnifyingglass")
            .foregroundColor(Color(.secondaryLabel))
            .font(.system(size: 18))
            .fontWeight(.semibold)
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
