import SwiftUI
import SwiftSugar

public extension Date {
    func longDateText(onlyIncludeDateIfNotRelative: Bool = false) -> Text {
        let dateString = longDateString(onlyShowYearIfNotCurrent: true)
        
        let text: Text
        if isToday {
            if onlyIncludeDateIfNotRelative {
                text = Text("Today")
            } else {
                text = Text("**Today**, \(dateString)")
            }
        } else if isYesterday {
            if onlyIncludeDateIfNotRelative {
                text = Text("Yesterday")
            } else {
                text = Text("**Yesterday**, \(dateString)")
            }
        } else if isTomorrow {
            if onlyIncludeDateIfNotRelative {
                text = Text("Tomorrow")
            } else {
                text = Text("**Tomorrow**, \(dateString)")
            }
        } else {
            text = Text(dateString)
        }
        
        return text
    }
}
