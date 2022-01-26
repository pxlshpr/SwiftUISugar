import SwiftUI
import SwiftHaptics

public struct UnitField: View {
    
    @Binding var label: String
    @Binding var value: String
    @Binding var unit: String?
    @State var units: [String]
    
    @State var showingActionSheet: Bool = false
    @State var actionSheetOptions: [String] = []
    @State var actionSheetSelection: Binding<String?>? = nil

    public init(
        label: Binding<String>,
        value: Binding<String>,
        unit: Binding<String?>,
        units: [String]
    ) {
        self._label = label
        self.units = units
        self._value = value
        self._unit = unit
    }

    public init(
        label: String,
        value: Binding<String>,
        unit: Binding<String?>,
        units: [String]
    ) {
        self._label = .constant(label)
        self.units = units
        self._value = value
        self._unit = unit
    }

    public var body: some View {
        Group {
            if let unwrappedUnit = $unit.wrappedValue {
                HStack {
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
