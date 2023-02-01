#if canImport(UIKit)
import Combine
import UIKit
import SwiftUI

public class TextFieldAlertViewController: UIViewController {
    
    /// Presents a UIAlertController (alert style) with a UITextField and a `Done` button
    /// - Parameters:
    ///   - title: to be used as title of the UIAlertController
    ///   - message: to be used as optional message of the UIAlertController
    ///   - text: binding for the text typed into the UITextField
    ///   - isPresented: binding to be set to false when the alert is dismissed (`Done` button tapped)
    init(title: String, confirmationMessage: String?, actions: [UIAlertAction]? = nil, text: Binding<String?>, isPresented: Binding<Bool>?) {
        self.alertTitle = title
        self.confirmationMessage = confirmationMessage
        self.actions = actions
        self._text = text
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Dependencies
    private let alertTitle: String
    private let confirmationMessage: String?
    private let actions: [UIAlertAction]?
    @Binding private var text: String?
    private var isPresented: Binding<Bool>?
    
    // MARK: - Private Properties
    private var subscription: AnyCancellable?
    
    // MARK: - Lifecycle
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlertController()
    }
    
    private func presentAlertController() {
        guard subscription == nil else { return } // present only once
        
        let vc = UIAlertController(title: alertTitle, message: confirmationMessage, preferredStyle: .alert)
        
        /// Add a textField and create a subscription to update the `text` binding
        vc.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.text = self.text
            textField.keyboardType = .alphabet
            textField.autocapitalizationType = .words
            self.subscription = NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: textField)
                .map { ($0.object as? UITextField)?.text }
                .assign(to: \.text, on: self)
        }
        
        /// Add Actions
        if let actions = actions, actions.count > 0 {
            actions.forEach { action in
                vc.addAction(action)
            }
        } else {
            let action = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
                self?.isPresented?.wrappedValue = false
            }
            vc.addAction(action)
        }
        
        present(vc, animated: true, completion: nil)
    }
}
#endif
