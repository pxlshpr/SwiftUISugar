import SwiftUI

/// Taken from [this medium article](https://prafullkumar77.medium.com/how-to-move-to-the-next-textfield-swiftui-1eb24066fb0a)

public struct FormTextField: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String
    var focusable: Binding<[Bool]>? = nil
    @Binding var returnedOnLastField: Bool

    var returnKeyType: UIReturnKeyType = .next
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var keyboardType: UIKeyboardType = .default
    var tag: Int
    
    init(placeholder: String,
         text: Binding<String>,
         focusable: Binding<[Bool]>? = nil,
         returnedOnLastField: Binding<Bool>,
         returnKeyType: UIReturnKeyType = .next,
         autocapitalizationType: UITextAutocapitalizationType = .none,
         keyboardType: UIKeyboardType = .default,
         tag: Int
    ) {
        self.placeholder = placeholder
        self.focusable = focusable
        self.returnKeyType = returnKeyType
        self.autocapitalizationType = autocapitalizationType
        self.keyboardType = keyboardType
        self.tag = tag
        _text = text
        _returnedOnLastField = returnedOnLastField
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.returnKeyType = returnKeyType
        textField.autocapitalizationType = autocapitalizationType
        textField.keyboardType = keyboardType
        textField.textAlignment = .left
        textField.tag = tag
        //toolbar
        if keyboardType == .numberPad { ///keyboard does not have next so add next button in the toolbar
            var items = [UIBarButtonItem]()
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let toolbar: UIToolbar = UIToolbar()
                  toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Next", style: .plain, target: context.coordinator, action: #selector(Coordinator.showNextTextField))
            items.append(contentsOf: [spacer, doneButton])
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        //Editin listener
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
        if let focusable = focusable?.wrappedValue {
            if focusable[uiView.tag] { ///set focused
                uiView.becomeFirstResponder()
            } else { ///remove keyboard
                uiView.resignFirstResponder()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        let formTextField: FormTextField
        var hasEndedViaReturn = false
        weak var textField: UITextField?
        
        init(_ formTextField: FormTextField) {
            self.formTextField = formTextField
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.textField = textField
            guard let textFieldCount = formTextField.focusable?.wrappedValue.count else { return }
            var focusable: [Bool] = Array(repeating: false, count: textFieldCount) //remove focus from all text field
            focusable[textField.tag] = true ///mark current textField focused
            formTextField.focusable?.wrappedValue = focusable
        }
        ///work around for number pad
        @objc func showNextTextField()  {
            if let textField = self.textField {
                _ = textFieldShouldReturn(textField)
            }
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            hasEndedViaReturn = true
            guard var focusable = formTextField.focusable?.wrappedValue else {
                textField.resignFirstResponder()
                return true
            }
            if (textField.tag + 1) != focusable.count { ///move focus to next text field if exist
                focusable[textField.tag + 1] = true
            } else {
                formTextField.returnedOnLastField = true
            }
            focusable[textField.tag] = false ///remove  focus from current text field
            formTextField.focusable?.wrappedValue = focusable
            return true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            if hasEndedViaReturn == false {///user dismisses keyboard
                guard let textFieldCount = formTextField.focusable?.wrappedValue.count else { return }
                ///reset all text field, so that makeUIView cannot trigger keyboard
                formTextField.focusable?.wrappedValue = Array(repeating: false, count: textFieldCount)
            } else {
                hasEndedViaReturn = false
            }
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            formTextField.text = textField.text ?? ""
        }
    }
}
