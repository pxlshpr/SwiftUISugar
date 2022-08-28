import SwiftUI
import SwiftSugar

public extension Date {
    func longDateText(onlyIncludeDateIfNotRelative: Bool = false) -> Text {
        let dateString = longDateString(onlyShowYearIfNotCurrent: true)
        
        let suffix = ", \(dateString)"
        
        let text: Text
        if isToday {
            text = Text("**Today**\(onlyIncludeDateIfNotRelative ? "" : suffix)")
        } else if isYesterday {
            text = Text("**Yesterday**\(onlyIncludeDateIfNotRelative ? "" : suffix)")
        } else if isTomorrow {
            text = Text("**Tomorrow**\(onlyIncludeDateIfNotRelative ? "" : suffix)")
        } else {
            text = Text(dateString)
        }
        
        return text
    }
}
