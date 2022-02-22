import SwiftUI
import SwiftHaptics

public struct Field_DynamicWidth: View {
    
    @Binding var label: String
    @Binding var value: String
    @State var placeholder: String? = nil
    @State var keyboardType: UIKeyboardType

    /// Single (optional) unit
    @State var unit: String? = nil
    
    /// Multiple units
    var units: Binding<[SelectionOption]>? = nil
    var selectedUnit: Binding<SelectionOption>? = nil
    var customUnitString: Binding<String>? = nil
    @State var showPickerOnAppear: Bool = false
    var customIsShowingPicker: Binding<Bool>? = nil
    var onUnitChanged: UnitChangedHandler? = nil

    @State private var showingActionSheet: Bool = false
    @FocusState private var isFocused: Bool

    @State var selectorStyle: SelectorStyle

    var stylingProvider: StylingProvider?
    
    @State var titleWidth: CGFloat = 0
    @State var subtitleWidth: CGFloat = 0

    //MARK: - Initializers
    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showPickerOnAppear: Bool = false,
        isShowingPicker: Binding<Bool>? = nil,
        selectorStyle: SelectorStyle = .menu,
        stylingProvider: StylingProvider? = nil,
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
        self._selectorStyle = State(initialValue: selectorStyle)
        self.stylingProvider = stylingProvider
//        calculateWidth()
    }
    
    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[SelectionOption]>,
        selectedUnit: Binding<SelectionOption>,
        customUnitString: Binding<String>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showPickerOnAppear: Bool = false,
        isShowingPicker: Binding<Bool>? = nil,
        selectorStyle: SelectorStyle = .menu,
        stylingProvider: StylingProvider? = nil,
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
        self._selectorStyle = State(initialValue: selectorStyle)
        self.stylingProvider = stylingProvider
//        calculateWidth()
        self._titleWidth = State(initialValue: width(for: selectedUnitString, font: UIFont.preferredFont(forTextStyle: .headline)))
        self._subtitleWidth = State(initialValue: width(for: subtitle ?? "", font: UIFont.preferredFont(forTextStyle: .subheadline)))
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
        selectorStyle: SelectorStyle = .menu,
        stylingProvider: StylingProvider? = nil,
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
            selectorStyle: selectorStyle,
            stylingProvider: stylingProvider,
            onUnitChanged: onUnitChanged)
    }
    
    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[SelectionOption]>,
        selectedUnit: Binding<SelectionOption>,
        customUnitString: Binding<String>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        showPickerOnAppear: Bool = false,
        isShowingPicker: Binding<Bool>? = nil,
        selectorStyle: SelectorStyle = .menu,
        stylingProvider: StylingProvider? = nil,
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
            selectorStyle: selectorStyle,
            stylingProvider: stylingProvider,
            onUnitChanged: onUnitChanged)
    }

    public var body: some View {
        if let units = units {
            switch selectorStyle {
            case .actionSheet:
                fieldWithPicker(for: units)
            case .menu:
                fieldWithMenu(for: units)
            }
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

    func fieldWithPicker(for units: Binding<[SelectionOption]>) -> some View {
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
    
    func fieldWithMenu(for units: Binding<[SelectionOption]>) -> some View {
        HStack {
            field
            if units.count > 1 {
                menu(for: units)
            } else {
                unitButtonText(forSingleUnit: true)
            }
        }
    }
    
    func menu(for units: Binding<[SelectionOption]>) -> some View {
        Menu {
            ForEach(units.indices, id: \.self) { index in
                if let provider = stylingProvider, provider.shouldPlaceDividerBefore(units.wrappedValue[index], within: units.wrappedValue) {
                    Divider()
                }
                menuButton(for: units.wrappedValue[index])
            }
        } label: {
            unitButtonText()
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }
    
    func menuButton(for option: SelectionOption) -> some View {
        Button(action: {
            selectedUnit?.wrappedValue = option
            onUnitChanged?(option)
        }) {
            if let systemImage = stylingProvider?.systemImage(for: option) {
                Label(unitString(for: option), systemImage: systemImage)
            } else {
                Text(unitString(for: option))
            }
        }
    }
    
    //MARK: - Option Button
    let FontSize = 13.0
    let FontWeight: Font.Weight = .semibold
    let UIFontWeight: UIFont.Weight = .semibold
    static var PaddingTapTargetHorizontal: CGFloat = 10.0
    static var PaddingTapTargetVertical: CGFloat = 7.0
    
    @Environment(\.colorScheme) var colorScheme

    @ViewBuilder
    func unitButtonText(forSingleUnit: Bool = false) -> some View {
        HStack(spacing: 0) {
            VStack (alignment: .leading) {
                Text(selectedUnitString)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .frame(width: titleWidth)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .frame(width: subtitleWidth)
                }
            }
            if !forSingleUnit {
                Spacer().frame(width: 5)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
            }
        }
        .onChange(of: selectedUnitString, perform: { newValue in
            calculateWidths()
        })
        .transition(.scale)
        .animation(.interactiveSpring(), value: selectedUnitString)
        .foregroundColor(foregroundColor)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.vertical, 3)
        .background(backgroundView)
        .padding(.vertical, Self.PaddingTapTargetVertical)
        .contentShape(Rectangle())
        .grayscale(forSingleUnit ? 1.0 : 0.0)
        .disabled(forSingleUnit)
    }
    
    func width(for string: String, font: UIFont) -> CGFloat {
        string.size(withAttributes:[.font: font]).width
    }

    func calculateWidths() {
        guard !selectedUnitString.isEmpty else { return }
        titleWidth = width(for: selectedUnitString, font: UIFont.preferredFont(forTextStyle: .headline))
        subtitleWidth = width(for: subtitle ?? "", font: UIFont.preferredFont(forTextStyle: .subheadline))
    }
    
    @ViewBuilder
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(pillBackgroundColor)
//            .overlay(RoundedRectangle(cornerRadius: 6))
    }

    var foregroundColor: Color {
        colorScheme == .light ? .accentColor : .white
    }

    var pillBackgroundColor: Color {
        colorScheme == .light ? Color(hex: "E7E1FF") : .accentColor
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
        guard let unit = selectedUnit?.wrappedValue else { return nil }
        return stylingProvider?.subtitle(for: unit, isPlural: isPlural)
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
    
    func actionSheet(for units: Binding<[SelectionOption]>) -> ActionSheet {
        ActionSheet(title: Text("Units"), buttons: actionSheetButtons(for: units))
    }

    func actionSheetButtons(for units: Binding<[SelectionOption]>) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        for unit in units {
            buttons.append(buttonFor(unit.wrappedValue))
        }
        buttons.append(.cancel())
        return buttons
    }
    
    func buttonFor(_ unit: SelectionOption) -> ActionSheet.Button {
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

    func unitString(for unit: SelectionOption?) -> String {
        guard let unit = unit, let stylingProvider = stylingProvider else {
            return ""
        }
        guard let value = Double(value) else {
            return stylingProvider.title(for: unit, isPlural: false)
        }
        return stylingProvider.title(for: unit, isPlural: value > 1)
    }
    
    let Padding: CGFloat = 10.0
}
