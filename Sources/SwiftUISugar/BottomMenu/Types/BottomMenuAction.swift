import SwiftUI
import SwiftUISugar

public struct BottomMenuAction: Hashable, Equatable {
    let title: String
    let systemImage: String?
    let role: ButtonRole
    let tapHandler: (() -> ())?
    let textInput: BottomMenuTextInput?
    let linkedMenu: BottomMenu?

    public init(title: String, systemImage: String? = nil, role: ButtonRole = .cancel, tapHandler: (() -> Void)? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.tapHandler = tapHandler
        self.role = role
        self.textInput = nil
        self.linkedMenu = nil
    }

    public init(title: String, systemImage: String? = nil, role: ButtonRole = .cancel, linkedMenu: BottomMenu) {
        self.title = title
        self.systemImage = systemImage
        self.tapHandler = nil
        self.role = role
        self.textInput = nil
        self.linkedMenu = linkedMenu
    }

    public init(title: String, systemImage: String? = nil, textInput: BottomMenuTextInput) {
        self.title = title
        self.systemImage = systemImage
        self.role = .cancel
        self.textInput = textInput
        
        self.tapHandler = nil
        self.linkedMenu = nil
    }
    
    var type: BottomMenuActionType {
        if linkedMenu != nil {
            return .link
        }
        
        if textInput == nil {
            if tapHandler == nil {
                return .title
            } else {
                return .button
            }
        } else {
            return .textField
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(systemImage)
    }
    
    public static func ==(lhs: BottomMenuAction, rhs: BottomMenuAction) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
