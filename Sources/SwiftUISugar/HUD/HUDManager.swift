import Foundation
import SwiftUI

public class HUDManager: ObservableObject {

    let queue = DispatchQueue(label: "com.SwiftUISugar.HUD.dispatch.serial")
    @Published public var info: HUDInfo?
    
    public init() {
        self.info = nil
    }
    
    public func show(info: HUDInfo) {
        
        queue.async {
            DispatchQueue.main.async {
                self.info = info
            }
            Thread.sleep(forTimeInterval: info.displayDuration)
            DispatchQueue.main.async {
                self.remove(notification: info)
            }
          
            /// allows the banner to disappear before the next one appears
            Thread.sleep(forTimeInterval: 1.1)
        }
    }
    
    func remove(notification: HUDInfo) {
        if self.info == notification {
            self.info = nil
        }
    }
}

//MARK: - Convenience
public extension HUDManager {
    
    func show(_ message: String) {
        let info = HUDInfo(message: message)
        show(info: info)
    }

    func show(
        title: String? = nil,
        message: String,
        systemImage: String? = nil,
        displayEdge: Edge? = nil,
        ignoresSafeArea: Bool = false,
        duration: TimeInterval? = nil
    ) {
        let info = HUDInfo(
            title: title,
            message: message,
            systemImage: systemImage,
            displayEdge: displayEdge,
            ignoresSafeArea: ignoresSafeArea,
            displayDuration: duration
        )
        show(info: info)
    }
}
