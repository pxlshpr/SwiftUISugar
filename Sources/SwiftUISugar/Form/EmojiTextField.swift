import SwiftUI

/// Based off answer in: https://stackoverflow.com/a/66397959
public class UIEmojiTextField: UITextField {
    
    /// Amended using: https://stackoverflow.com/a/69760106
    public override var textInputMode: UITextInputMode? {
        .activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
    }
}

public struct EmojiTextField: UIViewRepresentable {
    @Binding public var text: String
    public var placeholder: String = ""
    public var onTappedDismiss: (() -> Void)? = nil
    public var onTappedNext: (() -> Void)? = nil

    public init(text: Binding<String>, placeholder: String = "", onTappedDismiss: (() -> Void)? = nil, onTappedNext: (() -> Void)? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.onTappedDismiss = onTappedDismiss
        self.onTappedNext = onTappedNext
    }
    
    public func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        
        emojiTextField.inputAccessoryView = toolbar(context: context)
        
        return emojiTextField
    }
    
    func toolbar(context: Context) -> UIToolbar {
        let toolbarButtonWidth: CGFloat = 60

        let bar = UIToolbar()
        
        let previous = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: nil)
        previous.width = toolbarButtonWidth
        previous.isEnabled = false
        
        let next = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: context.coordinator, action: #selector(Coordinator.tappedNext))
        next.width = toolbarButtonWidth
        
        let spacer = UIBarButtonItem()

        let dismiss = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: context.coordinator, action: #selector(Coordinator.tappedDismiss))
        dismiss.width = toolbarButtonWidth

        bar.items = [previous, next, spacer, dismiss]
        bar.sizeToFit()
        return bar
    }
    
    public func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        uiView.text = text
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(parent: EmojiTextField) {
            self.parent = parent
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
        
        @objc func tappedDismiss() {
            parent.onTappedDismiss?()
        }
        
        @objc func tappedPrevious() {
            // TODO
        }

        @objc func tappedNext() {
            parent.onTappedNext?()
        }
    }
}
