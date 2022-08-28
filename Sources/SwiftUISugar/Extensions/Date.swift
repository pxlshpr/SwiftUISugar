import SwiftUI
import SwiftSugar

public extension Date {
    var longDateText: Text {
        let dateString = longDateString(onlyShowYearIfNotCurrent: true)
        
        let text: Text
        if isToday {
            text = Text("**Today**, \(dateString)")
        } else if isYesterday {
            text = Text("**Yesterday**, \(dateString)")
        } else if isTomorrow {
            text = Text("**Tomorrow**, \(dateString)")
        } else {
            text = Text(dateString)
        }
        
        return text
    }
}
