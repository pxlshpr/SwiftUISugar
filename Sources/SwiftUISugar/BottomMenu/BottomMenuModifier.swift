import SwiftUI
import SwiftUISugar
import SwiftHaptics

public struct BottomMenuModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    @State var animateBackground: Bool = false
    @State var animatedIsPresented: Bool = false
    @FocusState var isFocused: Bool
    @State var inputText: String = ""
    
    @Binding var isPresented: Bool
    let menu: BottomMenu
    @State var actionToReceiveTextInputFor: BottomMenuAction?
    @State var linkedMenu: BottomMenu?
    
    @State var menuTransition: AnyTransition = .move(edge: .bottom)
    
    public init(isPresented: Binding<Bool>, menu: BottomMenu) {
        _isPresented = isPresented
        self.menu = menu
        
        /// If we only have one action group that takes a text input—set it straight away so the user can input the text
        if let singleTextInputAction = menu.singleTextInputAction {
            _actionToReceiveTextInputFor = State(initialValue: singleTextInputAction)
        } else {
            _actionToReceiveTextInputFor = State(initialValue: nil)
        }
    }
    
    @State var animationDurationBackground: CGFloat = 0.1
    @State var animationDurationButtons: CGFloat = 0.15
    
    @State private var buttonsSize = CGSize.zero
    
    public func body(content: Content) -> some View {
        content
        //            .blur(radius: animatedIsPresented ? 5 : 0)
            .overlay(menuOverlay)
            .onChange(of: isPresented) { isPresented in
                if isPresented {
                    resetForNextPresentation()
                    Haptics.selectionFeedback()
                    animationDurationBackground = 0.29
                    animationDurationButtons = 0.29
                } else {
                    animationDurationBackground = 0.1
                    animationDurationButtons = 0.1
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    //                        isFocused = false
                    //                    }
                }
                
                //                withAnimation(.default) {
                withAnimation(.easeOut(duration: animationDurationBackground)) {
                    animateBackground = isPresented
                }
                withAnimation(.easeOut(duration: animationDurationButtons)) {
                    animatedIsPresented = isPresented
                }
            }
            .onAppear {
                if actionToReceiveTextInputFor != nil && !isFocused && isPresented {
                    isFocused = true
                }
            }
    }
    
    var menuOverlay: some View {
        ZStack {
            if animateBackground {
                backgroundLayer
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .zIndex(1)
            }
            //            if isPresented {
            buttonsLayer
                .transition(.opacity)
                .zIndex(2)
            //            }
        }
    }
    
    //MARK: - Layers
    
    var backgroundLayer: some View {
        Color(.black)
            .opacity(colorScheme == .dark ? 0.6 : 0.3)
        //        Color(.quaternarySystemFill)
        //            .background (.ultraThinMaterial)
            .onTapGesture {
                dismiss()
            }
    }
    
    var actionGroupTransition: AnyTransition {
        if linkedMenu != nil {
            return .move(edge: .leading)
        } else {
            return .move(edge: .bottom).combined(with: .opacity)
        }
    }
    var buttonsLayer: some View {
        VStack(spacing: 0) {
            Spacer()
            //            GeometryReader { geometry in
            //                buttonsContent(geometry)
            //            }
            buttonsContent().readSize { size in
                buttonsSize = size
            }
        }
        //TODO: Get the size here
        .offset(y: animatedIsPresented ? 0 : buttonsSize.height + 50)
    }
    
    //    func buttonsContent(_ geometry: GeometryProxy) -> some View {
    func buttonsContent() -> some View {
        VStack(spacing: 10) {
            if let textInput = actionToReceiveTextInputFor?.textInput {
                inputSections(for: textInput)
                    .transition(.move(edge: .trailing))
            } else if let linkedMenu {
                linkedMenuSections(for: linkedMenu)
                    .transition(.move(edge: .trailing))
            } else {
                actionGroupSections
                //                    .transition(actionGroupTransition)
                    .transition(menuTransition)
            }
            VStack(spacing: 0) {
                if let actionToReceiveTextInputFor {
                    Group {
                        submitTextButton(for: actionToReceiveTextInputFor)
                        Divider()
                    }
                    //                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                    .transition(.move(edge: .bottom))
                }
                cancelButton
            }
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(Color(.secondarySystemGroupedBackground))
            )
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
    
    //MARK: - Sections
    
    func inputSections(for textInput: BottomMenuTextInput) -> some View {
        VStack(spacing: 0) {
            TextField(
                text: $inputText,
                prompt: Text(verbatim: textInput.placeholder),
                axis: .vertical
            ) { }
                .focused($isFocused)
                .padding()
                .keyboardType(textInput.keyboardType)
                .textInputAutocapitalization(textInput.autocapitalization)
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .strokeBorder(Color(.separator).opacity(0.5))
                        .background (
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .foregroundColor(Color(.systemBackground))
                        )
                )
                .frame(maxWidth: .infinity)
                .padding(7)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color(.separator).opacity(0.2))
                        .background (
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(Color(.systemGroupedBackground))
                        )
                )
                .padding(.horizontal)
        }
    }
    
    var actionGroupSections: some View {
        ForEach(menu.groups, id: \.self) {
            actionGroup(for: $0)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(Color(.secondarySystemGroupedBackground))
                )
                .padding(.horizontal)
        }
    }
    
    func linkedMenuSections(for menu: BottomMenu) -> some View {
        ForEach(menu.groups, id: \.self) {
            actionGroup(for: $0)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(Color(.secondarySystemGroupedBackground))
                )
                .padding(.horizontal)
        }
    }
    
    func actionGroup(for actions: BottomMenuActionGroup) -> some View {
        VStack(spacing: 0) {
            if let title = actions.title {
                titleButton(for: title)
            }
            ForEach(actions.withoutTitle.indices, id: \.self) { index in
                if index != 0 {
                    Divider()
                        .padding(.leading, 75)
                }
                actionButton(for: actions.withoutTitle[index])
            }
        }
    }
    
    //MARK: - Buttons
    
    func submitTextButton(for action: BottomMenuAction) -> some View {
        Button {
            if let textInputHandler = action.textInput?.handler {
                textInputHandler(inputText)
            }
            dismiss()
        } label: {
            Text(action.textInput?.submitString ?? "Submit")
                .font(.title3)
                .fontWeight(.regular)
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .disabled(shouldDisableSubmitButton)
    }
    
    func titleButton(for action: BottomMenuAction) -> some View {
        VStack(spacing: 0) {
            Text(action.title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .fontWeight(.regular)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
            Divider()
        }
    }
    
    func actionButton(for action: BottomMenuAction) -> some View {
        Button {
            /// If this action has a tap handler, handle it and dismiss
            if let tapHandler = action.tapHandler {
                /// Delay the action to avoid the animation of it dismissing possibly being interrupted by a `@State` changing `tapHandler`
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tapHandler()
                }
                dismiss()
            } else if action.type == .textField {
                /// If this has a text input handler—change the UI to be able to recieve text input
                Haptics.feedback(style: .soft)
                withAnimation {
                    actionToReceiveTextInputFor = action
                }
                isFocused = true
            } else if action.type == .link, let linkedMenu = action.linkedMenu {
                Haptics.feedback(style: .soft)
                menuTransition = .move(edge: .leading)
                withAnimation {
                    self.linkedMenu = linkedMenu
                }
            }
        } label: {
            HStack {
                if let systemImage = action.systemImage {
                    Image(systemName: systemImage)
                        .imageScale(.large)
                        .frame(width: 50)
                        .fontWeight(.medium)
                        .foregroundColor(action.role == .destructive ? .red : .accentColor)
                }
                Text(action.title)
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(action.role == .destructive ? .red : .accentColor)
                if action.systemImage != nil {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    var cancelButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Cancel")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
    
    //MARK: - Actions
    
    func resetForNextPresentation() {
        if let singleTextInputAction = menu.singleTextInputAction {
            actionToReceiveTextInputFor = singleTextInputAction
        } else {
            actionToReceiveTextInputFor = nil
        }
        if actionToReceiveTextInputFor != nil && !isFocused {
            isFocused = true
        }
    }
    
    func dismiss() {
        //        Haptics.feedback(style: .soft)
        isFocused = false
        /// Reset `actionToReceiveTextInputFor` to nil only if the action groups has other actions besides the one expecting input
        if menu.singleTextInputAction != nil {
            actionToReceiveTextInputFor = nil
        }
        /// Do this after a delay so that setting it to nil doesn't make the the initial menu pop up during the dismissal animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            linkedMenu = nil
            menuTransition = .move(edge: .bottom)
        }
        inputText = ""
        //        withAnimation(.easeOut(duration: 0.2)) {
        isPresented = false
        //        }
    }
    
    //MARK: - Helpers
    
    var shouldDisableSubmitButton: Bool {
        guard let textInputIsValid = actionToReceiveTextInputFor?.textInput?.isValid else {
            return false
        }
        return !textInputIsValid(inputText)
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
