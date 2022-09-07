import SwiftUI

public class NamespaceWrapper: ObservableObject {
    public var namespace: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
