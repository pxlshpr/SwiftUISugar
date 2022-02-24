import SwiftUI
import SwiftHaptics

public typealias UnitChangedHandler = (SelectionOption) -> Void

public enum SelectorStyle {
    case actionSheet
    case menu
}

public struct Field: View {

    @Binding var label: String
    var value: Binding<String>?
    @State var keyboardType: UIKeyboardType = .default
    var stylingProvider: StylingProvider?

    @State var placeholder: String? = nil
    @State var unit: String? = nil /// Single (optional) unit

    /// Multiple units
    var units: Binding<[SelectionOption]>? = nil
    var selectedUnit: Binding<SelectionOption>? = nil
    var onUnitChanged: UnitChangedHandler? = nil

    @FocusState private var isFocused: Bool

    //MARK: - Initializers
    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        stylingProvider: StylingProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = label
        self.value = value
        self._keyboardType = State(initialValue: keyboardType)
        self._placeholder = State(initialValue: placeholder)
        self._unit = State(initialValue: unit)
        self.onUnitChanged = onUnitChanged
        self.stylingProvider = stylingProvider
    }

    public init(
        label: Binding<String>,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[SelectionOption]>,
        selectedUnit: Binding<SelectionOption>,
        keyboardType: UIKeyboardType = .alphabet,
        stylingProvider: StylingProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = label
        self.value = value
        self._keyboardType = State(initialValue: keyboardType)
        self._placeholder = State(initialValue: placeholder)
        self.units = units
        self.selectedUnit = selectedUnit
        self.onUnitChanged = onUnitChanged
        self.stylingProvider = stylingProvider
    }

    public init(
        label: String,
        units: Binding<[SelectionOption]>,
        selectedUnit: Binding<SelectionOption>,
        stylingProvider: StylingProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = .constant(label)
        self.value = nil
        self.units = units
        self.selectedUnit = selectedUnit
        self.onUnitChanged = onUnitChanged
        self.stylingProvider = stylingProvider
    }
    
    //MARK: Convenience Initializers

    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        stylingProvider: StylingProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.init(
            label: .constant(label),
            value: value,
            placeholder: placeholder,
            unit: unit,
            keyboardType: keyboardType,
            stylingProvider: stylingProvider,
            onUnitChanged: onUnitChanged)
    }

    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        units: Binding<[SelectionOption]>,
        selectedUnit: Binding<SelectionOption>,
        keyboardType: UIKeyboardType = .alphabet,
        stylingProvider: StylingProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self.init(
            label: .constant(label),
            value: value,
            placeholder: placeholder,
            units: units,
            selectedUnit: selectedUnit,
            keyboardType: keyboardType,
            stylingProvider: stylingProvider,
            onUnitChanged: onUnitChanged)
    }

    public var body: some View {
        if let units = units {
            fieldWithMenu(for: units)
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

    func fieldWithMenu(for units: Binding<[SelectionOption]>) -> some View {
        HStack {
            if value != nil {
                field
            } else {
                labelsLayer
                Spacer()
            }
            if units.count > 1 {
                menu(for: units)
            } else {
                unitButtonText(forSingleUnit: true)
            }
        }
    }

    func menu(for options: Binding<[SelectionOption]>) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options.wrappedValue[index]
                if let provider = stylingProvider, provider.shouldPlaceDividerBefore(option, within: options.wrappedValue)
                {
                    Divider()
                }
                if option.isGroup, let subOptions = option.subOptions {
                    secondaryMenu(for: subOptions, option: option)
                } else {
                    menuButton(for: option)
                }
            }
        } label: {
            unitButtonText()
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }

    @ViewBuilder
    func secondaryMenu(for options: [SelectionOption], option: SelectionOption) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                if let provider = stylingProvider, provider.shouldPlaceDividerBefore(option, within: options)
                {
                    Divider()
                }
                if option.isGroup, let subOptions = option.subOptions {
                    tertiaryMenu(for: subOptions, option: option)
                } else {
                    menuButton(for: option)
                }
            }
        } label: {
            if let systemImage = stylingProvider?.systemImage(for: option) {
                Label(title(for: option), systemImage: systemImage)
            } else {
                Text(title(for: option))
            }
        }
        .onTapGesture {
            Haptics.feedback(style: .soft)
        }
    }

    func title(for option: SelectionOption) -> String {
        stylingProvider?.title(for: option, isPlural: false) ?? "Unsupported Option"
    }

    @ViewBuilder
    func tertiaryMenu(for options: [SelectionOption], option: SelectionOption) -> some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                if let provider = stylingProvider, provider.shouldPlaceDividerBefore(option, within: options)
                {
                    Divider()
                }
                menuButton(for: option)
            }
        } label: {
            if let systemImage = stylingProvider?.systemImage(for: option) {
                Label(title(for: option), systemImage: systemImage)
            } else {
                Text(title(for: option))
            }
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
            VStack (alignment: value == nil ? .trailing : .leading) {
                Text(selectedUnitString)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
            }
            if !forSingleUnit {
                Spacer().frame(width: 5)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
            }
        }
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
        guard let value = value?.wrappedValue, let double = Double(value) else { return false }
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
        if let value = value {
            TextField(placeholder ?? "", text: value)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
                .frame(maxHeight: .infinity)
        }
    }

    @ViewBuilder
    var textFieldLayer: some View {
        HStack {
            Spacer()
                .frame(width: label.widthForLabelFont + Padding)
            textField
//            if let units = unit {
//                Text(units)
//                    .foregroundColor(Color(.clear))
//                    .multilineTextAlignment(.trailing)
//            }
        }
    }

    @ViewBuilder
    var labelsLayer: some View {
        if let value = value {
            HStack {
                Text(label)
                    .foregroundColor(value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
                Spacer()
//                if let units = unit {
//                    Text(units)
//                        .foregroundColor(value.wrappedValue.count > 0 ? Color(.secondaryLabel) : Color(.tertiaryLabel))
//                        .multilineTextAlignment(.trailing)
//                }
            }
        } else {
            Text(label)
                .foregroundColor(Color(.label))
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
        return unitString(for: selectedUnit)
    }

    func unitString(for unit: SelectionOption?) -> String {
        guard let unit = unit, let stylingProvider = stylingProvider else {
            return ""
        }
        if let value = value, let doubleValue = Double(value.wrappedValue) {
            return stylingProvider.title(for: unit, isPlural: doubleValue > 1)
        } else {
            return stylingProvider.title(for: unit, isPlural: false)
        }
    }

    let Padding: CGFloat = 10.0
}
