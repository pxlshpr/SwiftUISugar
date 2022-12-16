import Foundation

extension Notification.Name {
    static var selectionOptionChanged: Notification.Name { return .init("selectionOptionChanged") }
}

#if canImport(UIKit)
import SwiftUI

extension View {
    func onWillResignActive(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
            perform: { _ in f() }
        )
    }

    func onDidEnterBackground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification),
            perform: { _ in f() }
        )
    }

    func onWillEnterForeground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification),
            perform: { _ in f() }
        )
    }

    func onDidBecomeActive(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
            perform: { _ in f() }
        )
    }
}
#endif
