import SwiftUI
import SwiftHaptics

public struct DatePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var date: Date

    let didPickDate: ((Date) -> ())
    
    public init(
        date: Date,
        didPickDate: @escaping ((Date) -> ())
    ) {
        _date = State(initialValue: date)
        self.didPickDate = didPickDate
    }

    enum RelativeDay {
        case today
        case yesterday
        case tomorrow
        
        var description: String {
            switch self {
            case .today:        return "Today"
            case .yesterday:    return "Yesterday"
            case .tomorrow:     return "Tomorrow"
            }
        }
        
        var todayOffset: Int {
            switch self {
            case .today:        return 0
            case .yesterday:    return -1
            case .tomorrow:     return 1
            }
        }
    }
    public var body: some View {
        NavigationView {
            Form {
                datePicker
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { trailingContent }
            .toolbar { leadingContent }
        }
    }
    
    var trailingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if date.isToday || date.isYesterday {
                button(relativeDay: .tomorrow)
            } else {
                button(relativeDay: .today)
            }
        }
    }
    
    func button(relativeDay: RelativeDay) -> some View {
        Button(relativeDay.description) {
            Haptics.feedback(style: .soft)
            didPickDate(Date().moveDayBy(relativeDay.todayOffset).startOfDay)
            dismiss()
        }
    }

    var leadingContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if date.isYesterday {
                button(relativeDay: .today)
            } else {
                button(relativeDay: .yesterday)
            }
        }
    }

    var title: String {
        "Pick a date"
    }
    
    var datePicker: some View {
        DatePicker(
            "Pick a date",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .onChange(of: date) { pickedDate in
            Haptics.feedback(style: .soft)
            didPickDate(pickedDate)
            dismiss()
        }
    }
}
