import Foundation

public struct FormConfirmableAction {
    public let handler: () -> ()
    public let shouldConfirm: Bool
    
    public let confirmationMessage: String?
    public let confirmationButtonTitle: String?
    
    public let buttonImage: String?

    public let isDisabled: Bool

    public init(
        shouldConfirm: Bool = false,
        confirmationMessage: String? = nil,
        confirmationButtonTitle: String? = nil,
        isDisabled: Bool = false,
        buttonImage: String? = nil,
        handler: @escaping () -> ()
    ) {
        self.handler = handler
        self.shouldConfirm = shouldConfirm
        self.confirmationMessage = confirmationMessage
        self.confirmationButtonTitle = confirmationButtonTitle
        self.buttonImage = buttonImage
        self.isDisabled = isDisabled
    }
}
