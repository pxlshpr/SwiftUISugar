import Foundation
import SwiftUI

public class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    
    public var hudManager: HUDManager? {
        didSet {
            setupHUDWindow()
        }
    }
    
    var hudWindow: UIWindow?
    weak var windowScene: UIWindowScene?
    
    public func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        windowScene = scene as? UIWindowScene
    }
    
    /// A second app window is needed to show the notification banner above `sheet`s, and `fullScreenCover`s
    ///
    /// Source: https://www.fivestars.blog/articles/swiftui-windows/
    ///
    func setupHUDWindow() {
        guard let windowScene = windowScene,
              let hudManager = hudManager
        else { return }
        
        let hudViewController = UIHostingController(
            rootView: HUDView().environmentObject(hudManager)
        )
        hudViewController.view.backgroundColor = .clear
        
        let notificationWindow = PassThroughWindow(windowScene: windowScene)
        notificationWindow.rootViewController = hudViewController
        notificationWindow.isHidden = false
        self.hudWindow = notificationWindow
    }
}
