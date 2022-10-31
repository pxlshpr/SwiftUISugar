//#if canImport(UIKit)
//import SwiftUI
//
//struct NamespaceEnvironmentKey: EnvironmentKey {
//    static var defaultValue: Namespace.ID = Namespace().wrappedValue
//}
//
//extension EnvironmentValues {
//    public var namespace: Namespace.ID {
//        get { self[NamespaceEnvironmentKey.self] }
//        set { self[NamespaceEnvironmentKey.self] = newValue }
//    }
//}
//
//extension View {
//    public func namespace(_ value: Namespace.ID) -> some View {
//        environment(\.namespace, value)
//    }
//}
//#endif
