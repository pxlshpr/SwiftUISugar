import SwiftUI
import SwiftHaptics

public typealias UnitChangedHandler = (SelectionOption) -> Void

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

    @FocusState var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme

    /// Constants
    let Padding: CGFloat = 10.0
    let FontSize = 13.0
    let FontWeight: Font.Weight = .semibold
    let UIFontWeight: UIFont.Weight = .semibold
    static var PaddingTapTargetHorizontal: CGFloat = 10.0
    static var PaddingTapTargetVertical: CGFloat = 7.0


    //MARK: - Initializers
    public init(
        label: Binding<String>,
        value: Binding<String>? = nil,
        placeholder: String? = nil,
        unit: String? = nil,
        units: Binding<[SelectionOption]>? = nil,
        selectedUnit: Binding<SelectionOption>? = nil,
        keyboardType: UIKeyboardType = .alphabet,
        stylingProvider: StylingProvider? = nil,
        onUnitChanged: UnitChangedHandler? = nil
    ) {
        self._label = label
        self.value = value
        self._placeholder = State(initialValue: placeholder)
        self._unit = State(initialValue: unit)
        self.units = units
        self.selectedUnit = selectedUnit
        self._keyboardType = State(initialValue: keyboardType)
        self.onUnitChanged = onUnitChanged
        self.stylingProvider = stylingProvider
    }

    //MARK: Convenience Initializers
    public init(
        label: String,
        value: Binding<String>,
        placeholder: String? = nil,
        unit: String? = nil,
        units: Binding<[SelectionOption]>? = nil,
        selectedUnit: Binding<SelectionOption>? = nil,
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
    
    //MARK: - Legacy
//    public init(
//        label: Binding<String>,
//        value: Binding<String>,
//        placeholder: String? = nil,
//        units: Binding<[SelectionOption]>,
//        selectedUnit: Binding<SelectionOption>,
//        keyboardType: UIKeyboardType = .alphabet,
//        stylingProvider: StylingProvider? = nil,
//        onUnitChanged: UnitChangedHandler? = nil
//    ) {
//        self._label = label
//        self.value = value
//        self._keyboardType = State(initialValue: keyboardType)
//        self._placeholder = State(initialValue: placeholder)
//        self.units = units
//        self.selectedUnit = selectedUnit
//        self.onUnitChanged = onUnitChanged
//        self.stylingProvider = stylingProvider
//    }
}
