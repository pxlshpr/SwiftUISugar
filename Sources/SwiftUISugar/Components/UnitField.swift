import SwiftUI
import SwiftHaptics

public struct UnitField: View {
    
    @State var label: String
    @Binding var value: String
    @Binding var unit: String?
    @State var units: [String]
    
    @State var showingActionSheet: Bool = false
    @State var actionSheetOptions: [String] = []
    @State var actionSheetSelection: Binding<String?>? = nil

    public init(
        label: String,
        value: Binding<String>,
        unit: Binding<String?>,
        units: [String]
    ) {
        self.label = label
        self._value = value
        self._unit = unit
        self.units = units
    }
    
    public var body: some View {
        Group {
            if let unwrappedUnit = $unit.wrappedValue {
                HStack {
//                    fieldRow(label, value: value, tag: tag, isDecimal: true)
                    Field(label: label, value: $value, isDecimal: true)
                    Text(unwrappedUnit)
                        .foregroundColor(Color.accentColor)
                        .onTapGesture {
                            Haptics.feedback(style: .soft)
                            actionSheetSelection = $unit
                            actionSheetOptions = units
                            showingActionSheet = true
                        }
                }
            } else {
                EmptyView()
            }
        }
        .actionSheet(isPresented: $showingActionSheet) { actionSheet }
    }
    
    var actionSheetButtons: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        for option in actionSheetOptions {
            buttons.append(.default(Text(option), action: {
                actionSheetSelection?.wrappedValue = option
            }))
        }
        buttons.append(.cancel())
        return buttons
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Units"), buttons: actionSheetButtons)
    }
}
