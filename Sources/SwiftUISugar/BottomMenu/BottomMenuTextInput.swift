import SwiftUI

public struct BottomMenuTextInput {
    let handler: ((String) -> ())
    let isValid: ((String) -> Bool)?
    let placeholder: String
    let keyboardType: UIKeyboardType
    let submitString: String
    let autocapitalization: TextInputAutocapitalization
    
    public init(
        placeholder: String = "",
        keyboardType: UIKeyboardType = .default,
        submitString: String = "",
        autocapitalization: TextInputAutocapitalization = .sentences,
        textInputIsValid: ((String) -> Bool)? = nil,
        textInputHandler: @escaping ((String) -> Void)
    ) {
        self.placeholder = placeholder
        self.submitString = submitString
        self.isValid = textInputIsValid
        self.handler = textInputHandler
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
    }
}
