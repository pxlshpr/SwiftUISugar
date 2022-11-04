import SwiftUI
import SwiftHaptics

public struct BottomMenuModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState var isFocused: Bool

    let menu: BottomMenu
    @Binding var isPresented: Bool
    @State var animateBackground: Bool = false
    @State var animatedIsPresented: Bool = false
    @State var inputText: String = ""
    @State var actionToReceiveTextInputFor: BottomMenuAction?
    @State var linkedMenu: BottomMenu?
    @State var menuTransition: AnyTransition = .move(edge: .bottom)
    @State var animationDurationBackground: CGFloat = 0.1
    @State var animationDurationButtons: CGFloat = 0.15
    @State var buttonsSize = CGSize.zero

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
    
    public func body(content: Content) -> some View {
        content
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
                }
                
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
}
