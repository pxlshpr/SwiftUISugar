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

    public var body: some View {
        NavigationView {
            Form {
                datePicker
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
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
