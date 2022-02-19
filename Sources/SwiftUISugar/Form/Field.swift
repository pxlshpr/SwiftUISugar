import SwiftUI
import SwiftHaptics

public typealias UnitChangedHandler = (PickerOption) -> Void

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
    @State var showPickerOnAppear: Bool = false
    var customIsShowingPicker: Binding<Bool>? = nil
    var onUnitChanged: UnitChangedHandler? = nil

    @State private var showingActionSheet: Bool = false
    @FocusState private var isFocused: Bool

    var stringsProvider: StringsProvider?
    
    //MARK: - Initializers
    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showPickerOnAppear: Bool = false,
        isShowingPicker: Binding<Bool>? = nil,
        stringsProvider: StringsProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = label
        self._value = value
        self._keyboardType = State(initialValue: keyboardType)
        self._showPickerOnAppear = State(initialValue: showPickerOnAppear)
        self.customIsShowingPicker = isShowingPicker
        self._placeholder = State(initialValue: placeholder)
        self._unit = State(initialValue: unit)
        self.onUnitChanged = onUnitChanged
        self.stringsProvider = stringsProvider
    }
    
    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[PickerOption]>,
        selectedUnit: Binding<PickerOption>,
        customUnitString: Binding<String>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showPickerOnAppear: Bool = false,
        isShowingPicker: Binding<Bool>? = nil,
        stringsProvider: StringsProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = label
        self._value = value
        self._keyboardType = State(initialValue: keyboardType)
        self._showPickerOnAppear = State(initialValue: showPickerOnAppear)
        self.customIsShowingPicker = isShowingPicker
        self._placeholder = State(initialValue: placeholder)
        self.units = units
        self.selectedUnit = selectedUnit
        self.customUnitString = customUnitString
        self.onUnitChanged = onUnitChanged
        self.stringsProvider = stringsProvider
    }
    
    //MARK: Convenience Initializers
    
    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showPickerOnAppear: Bool = false,
        isShowingPicker: Binding<Bool>? = nil,
        stringsProvider: StringsProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.init(
            label: .constant(label),
            value: value,
            placeholder: placeholder,
            unit: unit,
            keyboardType: keyboardType,
            showPickerOnAppear: showPickerOnAppear,
            isShowingPicker: isShowingPicker,
            stringsProvider: stringsProvider,
            onUnitChanged: onUnitChanged)
    }
    
    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[PickerOption]>,
        selectedUnit: Binding<PickerOption>,
        customUnitString: Binding<String>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showPickerOnAppear: Bool = false,
        isShowingPicker: Binding<Bool>? = nil,
        stringsProvider: StringsProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.init(
            label: .constant(label),
            value: value,
            placeholder: placeholder,
            units: units,
            selectedUnit: selectedUnit,
            customUnitString: customUnitString,
            keyboardType: keyboardType,
            showPickerOnAppear: showPickerOnAppear,
            isShowingPicker: isShowingPicker,
            stringsProvider: stringsProvider,
            onUnitChanged: onUnitChanged)
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
                        customIsShowingPicker?.wrappedValue = true
                    }
                }
        }
        .if(customIsShowingPicker != nil) { view in
            view
                .actionSheet(isPresented: customIsShowingPicker!) { actionSheet(for: units) }
        }
        .if(customIsShowingPicker == nil) { view in
            view
                .actionSheet(isPresented: $showingActionSheet) { actionSheet(for: units) }
        }
        .onChange(of: units.count) { newValue in
            if showPickerOnAppear && units.wrappedValue.count > 1 {
                showingActionSheet = true
                showPickerOnAppear = false
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
                    .animation(.interactiveSpring(), value: selectedUnitString)
                Text(subtitle)
                    .foregroundColor(unitTextColor)
                    .font(.caption2)
                    .animation(.interactiveSpring(), value: subtitle)
            }
            .foregroundColor(unitTextColor)
        } else {
            Text(selectedUnitString)
                .foregroundColor(unitTextColor)
                .animation(.interactiveSpring(), value: selectedUnitString)
        }
    }
    
    var subtitle: String? {
        stringsProvider?.subtitle(isPlural: isPlural)
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
        guard let units = units, let firstUnit = units.first?.wrappedValue, let stringsProvider = stringsProvider else {
            return ""
        }
//        let unit = unit ?? firstUnit
        guard let value = Double(value) else {
            return stringsProvider.title(isPlural: false)
//            return unit.title(isPlural: false)
        }
        return stringsProvider.title(isPlural: value > 1)
//        return unit.title(for: value)
    }
    
    let Padding: CGFloat = 10.0
}
