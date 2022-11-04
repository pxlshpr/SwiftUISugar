import Foundation

extension BottomMenuModifier {
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
//        isPresented = false
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
