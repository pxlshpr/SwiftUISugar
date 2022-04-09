import Combine
import UIKit
import SwiftUI

public struct TextFieldAlert {
    
    // MARK: Properties
    let title: String
    let message: String?
    @Binding var text: String?
    var isPresented: Binding<Bool>? = nil
    
    public init(title: String, message: String? = nil, text: Binding<String?>, isPresented: Binding<Bool>? = nil) {
        self.title = title
        self.message = message
        self._text = text
        self.isPresented = isPresented
    }
    
    // MARK: Modifiers
    func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
        TextFieldAlert(title: title, message: message, text: $text, isPresented: isPresented)
    }
}

extension TextFieldAlert: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = TextFieldAlertViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
        TextFieldAlertViewController(title: title, message: message, text: $text, isPresented: isPresented)
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: UIViewControllerRepresentableContext<TextFieldAlert>) {
        // no update needed
    }
}
