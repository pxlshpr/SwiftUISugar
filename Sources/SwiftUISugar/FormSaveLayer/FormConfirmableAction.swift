import Foundation

public struct FormConfirmableAction {
    public let handler: () -> ()
    public let shouldConfirm: Bool
    
    public let confirmationMessage: String?
    public let confirmationButtonTitle: String?
    
    public let buttonImage: String?

    public let isDisabled: Bool
    public let position: Position?
    
    public enum Position {
        case topTrailing
        
        /// Inline with the form contents
        case inline
        
        /// Positioned at bottom and fills the entire width
        case bottomFilled
        
        case bottomTrailing
    }
    
    public init(
        position: Position? = nil,
        shouldConfirm: Bool = false,
        confirmationMessage: String? = nil,
        confirmationButtonTitle: String? = nil,
        isDisabled: Bool = false,
        buttonImage: String? = nil,
        handler: @escaping () -> ()
    ) {
        self.handler = handler
        self.position = position
        self.shouldConfirm = shouldConfirm
        self.confirmationMessage = confirmationMessage
        self.confirmationButtonTitle = confirmationButtonTitle
        self.buttonImage = buttonImage
        self.isDisabled = isDisabled
    }
}

public extension FormConfirmableAction {
    var shouldPlaceAtBottom: Bool {
        position == nil
        || position == .bottomTrailing
        || position == .bottomFilled
    }
}
