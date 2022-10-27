import Foundation

public struct BottomMenu {
    var groups: [BottomMenuActionGroup]
    
    public init(groups: [BottomMenuActionGroup]) {
        self.groups = groups
    }

    /// Convenience for `BottomMenu` with a single group
    public init(group: BottomMenuActionGroup) {
        self.groups = [group]
    }

    /// Convenience for `BottomMenu` with a single action
    public init(action: BottomMenuAction) {
        self.groups = [BottomMenuActionGroup(action: action)]
    }

    /// Convenience for `BottomMenu` with a single group of action
    public init(actions: [BottomMenuAction]) {
        self.groups = [BottomMenuActionGroup(actions: actions)]
    }

    //MARK: - Helpers
    
    var singleTextInputAction: BottomMenuAction? {
        guard groups.count == 1,
              groups[0].actions.count == 1,
              let action = groups.first?.actions.first,
              action.type == .textField
        else {
            return nil
        }
        return action
    }
}
