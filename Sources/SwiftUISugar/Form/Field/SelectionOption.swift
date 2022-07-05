import Foundation
import SwiftUI

public protocol SelectionOption {
    var optionId: String { get }
    var isGroup: Bool { get }
    var subOptions: [SelectionOption]? { get }
    
    func title(isPlural: Bool) -> String?
    func menuTitle(isPlural: Bool) -> String?
    func subtitle(isPlural: Bool) -> String?
    var accessorySystemItem: String? { get }
    var role: ButtonRole? { get }
}

extension SelectionOption {
    public var isGroup: Bool { false }
    public var subOptions: [SelectionOption]? { nil }
    public func menuTitle(isPlural: Bool) -> String? { nil }
    public func title(isPlural: Bool) -> String? { nil }
    public func subtitle(isPlural: Bool) -> String? { nil }
    public var accessorySystemItem: String? { nil }
    public var role: ButtonRole? { nil }
}
