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
    
    func logDateText() -> Text {
        let formatter = DateFormatter()
        if self.year == Date().year {
            formatter.dateFormat = "EEEE d MMM"
        } else {
            formatter.dateFormat = "EEEE d MMM yy"
        }
        let dateString = formatter.string(from: self)
        
        let text: Text
        if isToday {
            text = Text("Today")
        } else if isYesterday {
            text = Text("Yesterday")
        } else if isTomorrow {
            text = Text("Tomorrow")
        } else {
            text = Text(dateString)
        }
        
        return text
    }
}
