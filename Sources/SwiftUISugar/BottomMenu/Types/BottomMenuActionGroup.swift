import Foundation

public struct BottomMenuActionGroup: Hashable {
    var actions: [BottomMenuAction]
    
    public init(actions: [BottomMenuAction]) {
        self.actions = actions
    }
    
    /// Convenience for a `BottomMenuActionGroup` with a single action
    public init(action: BottomMenuAction) {
        self.actions = [action]
    }
    
    //MARK: - Helpers
    var firstAction: BottomMenuAction? {
        actions.first
    }
    
    var title: BottomMenuAction? {
        guard let firstAction, firstAction.type == .title else {
            return nil
        }
        return firstAction
    }
    
    var withoutTitle: [BottomMenuAction] {
        actions.filter { $0.type != .title }
    }

}
