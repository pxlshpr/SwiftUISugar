/**
 This turns the SearchField into a small button like the global one in iOS 16.
 
 We've got the basic gist of it done—but we still need to tweak the animations.
 [ ] Try using `matchedGeometry` to sync the buttons etc.
 [ ] Try using the same text element as the placeholder for the textfield and the "Search" button
 [ ] Try having three modes
    [ ] One where we shrink it always, showing "Search" as the text
    [ ] Another one where we shrink
 */

//import SwiftUI
//import SwiftSugar
//import SwiftHaptics
//
//let colorHexKeyboardLight = "CDD0D6"
//let colorHexKeyboardDark = "303030"
//let colorHexSearchTextFieldDark = "535355"
//let colorHexSearchTextFieldLight = "FFFFFF"
//
//public typealias SearchSubmitHandler = (() -> ())
//
//public struct SearchableView<Content: View>: View {
//
//    @Binding var searchText: String
//    var externalIsFocused: Binding<Bool>
//    let buttonViews: [AnyView]
//    var content: () -> Content
//
//    //MARK: Internal
//    @Environment(\.colorScheme) var colorScheme
//    @FocusState var isFocused: Bool
//    @State var showingSearchLayer: Bool = false
//
//    @Binding var isHidden: Bool
//    let blurWhileSearching: Bool
//    let focusOnAppear: Bool
//    let prompt: String
//
//    let didSubmit: SearchSubmitHandler?
//
//    let shrunkenStyle: Bool = true
//
//    public init(
//        searchText: Binding<String>,
//        prompt: String = "Search",
//        focused: Binding<Bool> = .constant(true),
//        blurWhileSearching: Bool = false,
//        focusOnAppear: Bool = false,
//        isHidden: Binding<Bool> = .constant(false),
//        didSubmit: SearchSubmitHandler? = nil,
//        @ViewBuilder content: @escaping () -> Content)
//    {
//        _searchText = searchText
//        _isHidden = isHidden
//        self.prompt = prompt
//        self.externalIsFocused = focused
//        self.blurWhileSearching = blurWhileSearching
//        self.focusOnAppear = focusOnAppear
//        self.didSubmit = didSubmit
//        self.buttonViews = []
//        self.content = content
//    }
//
//    public init<Views>(
//        searchText: Binding<String>,
//        prompt: String = "Search",
//        focused: Binding<Bool> = .constant(true),
//        blurWhileSearching: Bool = false,
//        focusOnAppear: Bool = false,
//        isHidden: Binding<Bool> = .constant(false),
//        didSubmit: SearchSubmitHandler? = nil,
//        @ViewBuilder buttonViews: @escaping () -> TupleView<Views>,
//        @ViewBuilder content: @escaping () -> Content)
//    {
//        _searchText = searchText
//        _isHidden = isHidden
//        self.prompt = prompt
//        self.externalIsFocused = focused
//        self.blurWhileSearching = blurWhileSearching
//        self.focusOnAppear = focusOnAppear
//        self.didSubmit = didSubmit
//        self.buttonViews = buttonViews().getViews
//        self.content = content
//    }
//
//    public var body: some View {
//        ZStack {
//            content()
//                .blur(radius: blurRadius)
//                .frame(width: UIScreen.main.bounds.width)
//            if !isHidden {
//                searchLayer
//                    .zIndex(10)
//                    .transition(.move(edge: .bottom))
//            }
//        }
////        .frame(width: UIScreen.main.bounds.width)
//        .onAppear {
//            if focusOnAppear {
//                focusOnSearchTextField()
//            }
//        }
//        .onChange(of: externalIsFocused.wrappedValue) { newValue in
//            isFocused = newValue
//        }
//        .onChange(of: isFocused) { newValue in
//            externalIsFocused.wrappedValue = newValue
//            if blurWhileSearching && !showingSearchLayer && isFocused {
//                withAnimation {
//                    showingSearchLayer = true
//                }
//            }
//            withAnimation {
//                buttonIsFocused = newValue
//            }
//        }
//    }
//
//    var blurRadius: CGFloat {
//        guard blurWhileSearching else { return 0 }
//        return showingSearchLayer ? 10 : 0
//    }
//
//    func focusOnSearchTextField() {
//        withAnimation {
//            showingSearchLayer = true
//        }
//        isFocused = true
//    }
//
//    var keyboardColor: some View {
//        Group {
//            if !isFocused {
//                Color.clear
//                    .background(
//                        .ultraThinMaterial
//                    )
//    //            return Color.accentColor
//    //                .opacity(0.5)
//            } else {
//                colorScheme == .light ? Color(hex: colorHexKeyboardLight) : Color(hex: colorHexKeyboardDark)
//            }
//        }
//    }
//
//    var textFieldColor: Color {
//        colorScheme == .light ? Color(hex: colorHexSearchTextFieldLight) : Color(hex: colorHexSearchTextFieldDark)
//    }
//
//    var textField: some View {
//        TextField(prompt, text: $searchText)
//            .focused($isFocused)
//            .font(.system(size: 18))
//            .keyboardType(.alphabet)
//            .submitLabel(.search)
//            .autocorrectionDisabled()
//            .onSubmit {
//                if let didSubmit {
//                    Haptics.feedback(style: .soft)
//                    didSubmit()
//                }
////                        guard !searchViewModel.searchText.isEmpty else {
////                            dismiss()
////                            return
////                        }
//                resignFocusOfSearchTextField()
////                        startSearching()
//            }
//    }
//
//    var searchIcon: some View {
//        Image(systemName: "magnifyingglass")
//            .foregroundColor(Color(.secondaryLabel))
//            .font(.system(size: 18))
//            .fontWeight(.semibold)
//    }
//
//    var clearButton: some View {
//        Button {
//            searchText = ""
//        } label: {
//            Image(systemName: "xmark.circle.fill")
//                .foregroundColor(Color(.quaternaryLabel))
//        }
//        .opacity((!searchText.isEmpty && isFocused) ? 1 : 0)
//    }
//
//    var searchBar_normal: some View {
//        ZStack {
//            background
//            ZStack {
//                textFieldBackground
//                HStack {
//                    HStack(spacing: 5) {
//                        searchIcon
//                        textField
//                        Spacer()
//                        clearButton
//                    }
//                    ForEach(buttonViews.indices, id: \.self) { index in
//                        buttonViews[index]
//                    }
//                }
//                .padding(.horizontal, 12)
//            }
//            .padding(.horizontal, 7)
//        }
//    }
//
//    @State var buttonIsFocused = false
//
//    /// Shrunken
//    var searchBar: some View {
//        ZStack {
//            if buttonIsFocused {
//                background
////                    .transition(.move(edge: .bottom))
//                    .transition(.opacity)
//            }
//            HStack {
//                Button {
//                    withAnimation {
//                        buttonIsFocused = true
//                    }
//                    isFocused = true
//                } label: {
//                    ZStack {
//                        textFieldBackground
//                        HStack {
//                            HStack(spacing: 5) {
//                                searchIcon
//                                if buttonIsFocused {
//                                    textField
//                                        .multilineTextAlignment(.leading)
////                                        .transition(.scale.combined(with: .opacity))
//                                    Spacer()
//                                    clearButton
//                                }
//                                if !buttonIsFocused {
//                                    Text("Search")
//                                        .foregroundColor(.white)
//                                        .padding(.trailing, 10)
////                                        .transition(.scale.combined(with: .opacity))
//                                }
//                            }
//                            if buttonIsFocused {
//                                ForEach(buttonViews.indices, id: \.self) { index in
//                                    buttonViews[index]
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 12)
//                    }
//                }
//                if !isFocused {
//                    ForEach(buttonViews.indices, id: \.self) { index in
//                        buttonViews[index]
//                    }
//                }
//            }
//            .padding(.horizontal, 7)
//        }
//    }
//
//    var background: some View {
//        keyboardColor
//            .frame(height: 65)
//    }
//
//    var textFieldBackground: some View {
//        RoundedRectangle(cornerRadius: buttonIsFocused ? 15 : 20, style: .circular)
//            .foregroundColor(textFieldColor)
//            .frame(height: buttonIsFocused ? 48 : 38)
//            .frame(width: buttonIsFocused ? UIScreen.main.bounds.width - 18 : 120)
//    }
//
//    var searchLayer_normal: some View {
//        ZStack {
//            VStack {
//                Spacer()
//                searchBar
//                    .background(
//                        keyboardColor
//                            .edgesIgnoringSafeArea(.bottom)
//                    )
//            }
//        }
//    }
//
//    var searchLayer: some View {
//        ZStack {
//            VStack {
//                Spacer()
//                searchBar
//                    .background(
//                        Group {
//                            if isFocused {
//                                keyboardColor
//                                    .edgesIgnoringSafeArea(.bottom)
//                            }
//                        }
//                    )
//            }
//        }
//    }
//
//    func resignFocusOfSearchTextField() {
//        withAnimation {
//            showingSearchLayer = false
//        }
//        isFocused = false
//    }
//}
//
//extension TupleView {
//    var getViews: [AnyView] {
//        makeArray(from: value)
//    }
//
//    private struct GenericView {
//        let body: Any
//
//        var anyView: AnyView? {
//            AnyView(_fromValue: body)
//        }
//    }
//
//    private func makeArray<Tuple>(from tuple: Tuple) -> [AnyView] {
//        func convert(child: Mirror.Child) -> AnyView? {
//            withUnsafeBytes(of: child.value) { ptr -> AnyView? in
//                let binded = ptr.bindMemory(to: GenericView.self)
//                return binded.first?.anyView
//            }
//        }
//
//        let tupleMirror = Mirror(reflecting: tuple)
//        return tupleMirror.children.compactMap(convert)
//    }
//}
