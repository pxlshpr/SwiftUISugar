import SwiftUI
import SwiftHaptics

public struct Field: View {
    
    @Binding var label: String
    @Binding var value: String
    @State var placeholder: String? = nil
    @State var keyboardType: UIKeyboardType

    /// Single (optional) unit
    @State var unit: String? = nil
    
    /// Multiple units
    var units: Binding<[PickerOption]>? = nil
    var selectedUnit: Binding<PickerOption>? = nil
    var customUnitString: Binding<String>? = nil
    @State var showActionSheetOnAppear: Bool = false
    var onUnitChanged: UnitChangedHandler? = nil

    @State private var showingActionSheet: Bool = false
    @FocusState private var isFocused: Bool

    //MARK: - Initializers
    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showActionSheetOnAppear: Bool = false,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = label
        self._value = value
        self._keyboardType = State(initialValue: keyboardType)
        self._showActionSheetOnAppear = State(initialValue: showActionSheetOnAppear)
        self.placeholder = placeholder
        self.unit = unit
        self.onUnitChanged = onUnitChanged
    }
    
    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[PickerOption]>,
        selectedUnit: Binding<PickerOption>,
        customUnitString: Binding<String>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showActionSheetOnAppear: Bool = false,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = label
        self._value = value
        self._keyboardType = State(initialValue: keyboardType)
        self._showActionSheetOnAppear = State(initialValue: showActionSheetOnAppear)
        self.placeholder = placeholder
        self.units = units
        self.selectedUnit = selectedUnit
        self.customUnitString = customUnitString
        self.onUnitChanged = onUnitChanged
    }
    
    //MARK: Convenience Initializers
    
    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showActionSheetOnAppear: Bool = false,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.init(label: .constant(label), value: value, placeholder: placeholder, unit: unit, keyboardType: keyboardType, showActionSheetOnAppear: showActionSheetOnAppear, onUnitChanged: onUnitChanged)
    }
    
    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[PickerOption]>,
        selectedUnit: Binding<PickerOption>,
        customUnitString: Binding<String>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showActionSheetOnAppear: Bool = false,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.init(label: .constant(label), value: value, placeholder: placeholder, units: units, selectedUnit: selectedUnit, customUnitString: customUnitString, keyboardType: keyboardType, showActionSheetOnAppear: showActionSheetOnAppear, onUnitChanged: onUnitChanged)
    }

    public var body: some View {
        if let units = units {
            fieldWithPicker(for: units)
        } else {
            field
        }
    }
    
    var field: some View {
        ZStack {
            labelsLayer
            textFieldLayer
        }
        .onTapGesture {
            isFocused = true
        }
    }

    func fieldWithPicker(for units: Binding<[PickerOption]>) -> some View {
        HStack {
            field
            unitText
                .onTapGesture {
                    if units.count > 1 {
                        Haptics.feedback(style: .soft)
                        showingActionSheet = true
                    }
                }
        }
        .actionSheet(isPresented: $showingActionSheet) { actionSheet(for: units) }
        .onChange(of: units.count) { newValue in
            if showActionSheetOnAppear && units.wrappedValue.count > 1 {
                showingActionSheet = true
                showActionSheetOnAppear = false
            }
        }
    }

    //MARK: - Components
    @ViewBuilder
    var unitText: some View {
        if let subtitle = subtitle {
            VStack(alignment: .leading) {
                Text(selectedUnitString)
                    .foregroundColor(unitTextColor)
                Text(subtitle)
                    .foregroundColor(unitTextColor)
                    .font(.caption2)
            }
            .foregroundColor(unitTextColor)
        } else {
            Text(selectedUnitString)
                .foregroundColor(unitTextColor)
        }
    }
    
    var subtitle: String? {
        guard let selectedUnit = selectedUnit?.wrappedValue else {
            return nil
        }
        return selectedUnit.subtitle(isPlural: isPlural)
    }
    
    var isPlural: Bool {
        guard let double = Double(value) else { return false }
        return double > 1
    }
    
    var unitTextColor: Color {
        guard let units = units?.wrappedValue else {
            return Color(.secondaryLabel)
        }
        return units.count > 1 ? Color.accentColor : Color(.secondaryLabel)
    }
    
    @ViewBuilder
    var textField: some View {
        TextField(placeholder ?? "", text: $value)
            .focused($isFocused)
            .keyboardType(keyboardType)
            .multilineTextAlignment(.trailing)
            .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    var textFieldLayer: some View {
        HStack {
            Spacer()
                .frame(width: label.widthForLabelFont + Padding)
            textField
            if let units = unit {
                Text(units)
                    .foregroundColor(Color(.clear))
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    @ViewBuilder
    var labelsLayer: some View {
        HStack {
            Text(label)
                .foregroundColor($value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
            Spacer()
            if let units = unit {
                Text(units)
                    .foregroundColor($value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    //MARK: Action Sheet
    
    func actionSheet(for units: Binding<[PickerOption]>) -> ActionSheet {
        ActionSheet(title: Text("Units"), buttons: actionSheetButtons(for: units))
    }

    func actionSheetButtons(for units: Binding<[PickerOption]>) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        for unit in units {
            buttons.append(buttonFor(unit.wrappedValue))
        }
        buttons.append(.cancel())
        return buttons
    }
    
    func buttonFor(_ unit: PickerOption) -> ActionSheet.Button {
        return ActionSheet.Button.default(Text(unitString(for: unit)), action: {
            selectedUnit?.wrappedValue = unit
            onUnitChanged?(unit)
        })
    }
    
    //MARK: - Helpers
    
    var selectedUnitString: String {
        guard let selectedUnit = selectedUnit?.wrappedValue else {
            return ""
        }
        if let customUnitString = customUnitString?.wrappedValue {
            return customUnitString
        } else {
            return unitString(for: selectedUnit)
        }
    }

    func unitString(for unit: PickerOption?) -> String {
        guard let units = units, let firstUnit = units.first?.wrappedValue else {
            return ""
        }
        let unit = unit ?? firstUnit
        guard let value = Double(value) else {
            return unit.title(isPlural: false)
        }
        return unit.title(for: value)
    }
    
    let Padding: CGFloat = 10.0
}

public typealias UnitChangedHandler = (PickerOption) -> Void
